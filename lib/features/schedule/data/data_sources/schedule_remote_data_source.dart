import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/schedule/data/models/schedule_entry_model.dart';
import 'package:tempus/features/schedule/data/models/schedule_subject_model.dart';

class ScheduleRemoteDataSource {
  final SupabaseClient _client;

  const ScheduleRemoteDataSource(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<List<ScheduleSubjectModel>> getSubjects() async {
    final data = await _client
        .from('subject')
        .select('id, name, code')
        .eq('user_id', _userId)
        .eq('is_deleted', false)
        .order('id', ascending: true);

    return (data as List<dynamic>).map((row) {
      return ScheduleSubjectModel.fromMap({
        'id': row['id'],
        'name': row['name'],
        'code': row['code'],
      });
    }).toList();
  }

  Future<List<ScheduleEntryModel>> getEntries() async {
    // Step 1 — get the user's subject ids & metadata in one shot.
    final subjectRows = await _client
        .from('subject')
        .select('id, name, code')
        .eq('user_id', _userId)
        .eq('is_deleted', false);

    final subjects = (subjectRows as List<dynamic>);
    if (subjects.isEmpty) return [];

    final subjectNames = <int, String>{};
    final subjectCodes = <int, String>{};
    for (final s in subjects) {
      final id = s['id'] as int;
      subjectNames[id] = s['name'] as String;
      subjectCodes[id] = s['code'] as String;
    }

    final subjectIds = subjectNames.keys.toList();

    final scheduleRows = await _client
        .from('schedule')
        .select('id, sub_id, day, start_time, end_time')
        .inFilter('sub_id', subjectIds)
        .eq('is_deleted', false)
        .order('start_time', ascending: true);

    final Map<String, _GroupedEntry> grouped = {};

    for (final row in (scheduleRows as List<dynamic>)) {
      final subId = row['sub_id'] as int;
      final startTime = _trimTime(row['start_time'] as String);
      final endTime = _trimTime(row['end_time'] as String);
      final day = row['day'] as String;
      final rowId = row['id'] as int;

      final key = '$subId|$startTime|$endTime';

      grouped.putIfAbsent(
        key,
        () => _GroupedEntry(
          id: rowId,
          subId: subId,
          subjectName: subjectNames[subId] ?? '',
          subjectCode: subjectCodes[subId] ?? '',
          startTime: startTime,
          endTime: endTime,
          days: [],
        ),
      );

      grouped[key]!.days.add(day);
    }

    const dayOrder = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return grouped.values.map((g) {
      g.days.sort((a, b) => dayOrder.indexOf(a).compareTo(dayOrder.indexOf(b)));
      return ScheduleEntryModel(
        id: g.id,
        subId: g.subId,
        subjectName: g.subjectName,
        subjectCode: g.subjectCode,
        days: List<String>.from(g.days),
        startTime: g.startTime,
        endTime: g.endTime,
      );
    }).toList();
  }

  Future<ScheduleEntryModel> addEntry({
    required int subId,
    required String subjectName,
    required String subjectCode,
    required List<String> days,
    required String startTime,
    required String endTime,
  }) async {
    assert(days.isNotEmpty, 'days must not be empty');

    final rows = await _client
        .from('schedule')
        .insert(
          days
              .map(
                (day) => {
                  'sub_id': subId,
                  'day': day,
                  'start_time': _withSeconds(startTime),
                  'end_time': _withSeconds(endTime),
                  'is_deleted': false,
                },
              )
              .toList(),
        )
        .select('id');

    // Insert debug: log returned inserted IDs for visibility
    try {
      final insertedIds = (rows as List<dynamic>).map((r) => r['id']).toList();
      print('ScheduleRemoteDataSource.addEntry: inserted ids=$insertedIds');
    } catch (e) {
      print(
        'ScheduleRemoteDataSource.addEntry: unexpected insert response: $rows',
      );
    }

    final firstId = (rows as List<dynamic>).first['id'] as int;

    return ScheduleEntryModel(
      id: firstId,
      subId: subId,
      subjectName: subjectName,
      subjectCode: subjectCode,
      days: List<String>.from(days),
      startTime: startTime,
      endTime: endTime,
    );
  }

  Future<ScheduleEntryModel> updateEntry({
    required int entryId,
    required int subId,
    required String subjectName,
    required String subjectCode,
    required List<String> days,
    required String startTime,
    required String endTime,
  }) async {
    assert(days.isNotEmpty, 'days must not be empty');

    final seed = await _client
        .from('schedule')
        .select('sub_id, start_time, end_time')
        .eq('id', entryId)
        .single();

    final oldSubId = seed['sub_id'] as int;
    // Trim times to `HH:MM` so we can match rows regardless of whether the DB
    // stores seconds (HH:MM:SS) — use LIKE with a trailing '%' to match either.
    final oldStart = _trimTime(seed['start_time'] as String);
    final oldEnd = _trimTime(seed['end_time'] as String);

    // Find the actual row IDs that belong to the grouped entry (same sub_id +
    // start/end time window). This mirrors the grouping logic used by
    // getEntries and ensures we mark exactly those rows deleted before inserting
    // the new grouped rows.
    final oldStartFull = _withSeconds(oldStart);
    final oldEndFull = _withSeconds(oldEnd);

    // Select matching row IDs by exact start/end normalized to HH:MM:SS.
    // This mirrors addEntry which writes HH:MM:SS and avoids mismatches.
    // Try exact normalized match first (HH:MM:SS). If nothing found, fall
    // back to a LIKE search on trimmed HH:MM to cover DB rows with/without
    // seconds. Add debug prints to help trace matching behavior.
    var matchedRows = await _client
        .from('schedule')
        .select('id')
        .eq('sub_id', oldSubId)
        .eq('start_time', oldStartFull)
        .eq('end_time', oldEndFull)
        .eq('is_deleted', false);

    var ids = (matchedRows as List<dynamic>)
        .map((r) => r['id'] as int)
        .toList();

    if (ids.isEmpty) {
      // Fallback to LIKE on trimmed values
      print(
        'ScheduleRemoteDataSource.updateEntry: exact match failed for subId=$oldSubId start=$oldStartFull end=$oldEndFull - falling back to LIKE',
      );
      final oldStartTrim = _trimTime(oldStartFull);
      final oldEndTrim = _trimTime(oldEndFull);

      matchedRows = await _client
          .from('schedule')
          .select('id')
          .eq('sub_id', oldSubId)
          .like('start_time', '$oldStartTrim%')
          .like('end_time', '$oldEndTrim%')
          .eq('is_deleted', false);

      ids = (matchedRows as List<dynamic>).map((r) => r['id'] as int).toList();
      print(
        'ScheduleRemoteDataSource.updateEntry: fallback LIKE found ${ids.length} rows for subId=$oldSubId',
      );
    } else {
      print(
        'ScheduleRemoteDataSource.updateEntry: exact match found ${ids.length} rows for entryId=$entryId',
      );
    }

    if (ids.isNotEmpty) {
      await _client
          .from('schedule')
          .update({'is_deleted': true})
          .inFilter('id', ids)
          .eq('is_deleted', false);
      print(
        'ScheduleRemoteDataSource.updateEntry: marked ${ids.length} rows is_deleted=true',
      );
    } else {
      print(
        'ScheduleRemoteDataSource.updateEntry: no rows marked deleted for entryId=$entryId',
      );
    }

    final rows = await _client
        .from('schedule')
        .insert(
          days
              .map(
                (day) => {
                  'sub_id': subId,
                  'day': day,
                  'start_time': _withSeconds(startTime),
                  'end_time': _withSeconds(endTime),
                },
              )
              .toList(),
        )
        .select('id');

    // Debug: show inserted rows payload and returned IDs for update flow
    // Log inserted IDs for update flow
    try {
      final insertedIdsLog = (rows as List<dynamic>)
          .map((r) => r['id'])
          .toList();
      print(
        'ScheduleRemoteDataSource.updateEntry: inserted ids=$insertedIdsLog',
      );
    } catch (e) {
      print(
        'ScheduleRemoteDataSource.updateEntry: unexpected insert response: $rows',
      );
    }

    final insertedIds = (rows as List<dynamic>)
        .map((r) => r['id'] as int)
        .toList();

    // Ensure newly-inserted rows are active (is_deleted = false). Some DB/RLS
    // triggers or policies may result in unexpected is_deleted states; explicitly
    // re-activate the newly created rows to guarantee they are visible.
    if (insertedIds.isNotEmpty) {
      await _client
          .from('schedule')
          .update({'is_deleted': false})
          .inFilter('id', insertedIds);
    }

    final firstId = insertedIds.first;

    return ScheduleEntryModel(
      id: firstId,
      subId: subId,
      subjectName: subjectName,
      subjectCode: subjectCode,
      days: List<String>.from(days),
      startTime: startTime,
      endTime: endTime,
    );
  }

  Future<void> deleteEntry(int entryId) async {
    final seed = await _client
        .from('schedule')
        .select('sub_id, start_time, end_time')
        .eq('id', entryId)
        .single();

    final subId = seed['sub_id'] as int;
    // Trim times to `HH:MM` so we can match rows regardless of whether the DB
    // stores seconds — find the exact row IDs and mark them deleted explicitly.
    final startTime = _trimTime(seed['start_time'] as String);
    final endTime = _trimTime(seed['end_time'] as String);

    final startFull = _withSeconds(startTime);
    final endFull = _withSeconds(endTime);

    // Select matching row IDs by exact start/end normalized to HH:MM:SS,
    // then mark those specific rows deleted. This uses the same time format
    // addEntry uses when inserting rows.
    // Try exact normalized match first (HH:MM:SS). If nothing found, fall
    // back to LIKE on trimmed HH:MM. Add debug prints for visibility.
    var matchedRows = await _client
        .from('schedule')
        .select('id')
        .eq('sub_id', subId)
        .eq('start_time', startFull)
        .eq('end_time', endFull)
        .eq('is_deleted', false);

    var ids = (matchedRows as List<dynamic>)
        .map((r) => r['id'] as int)
        .toList();

    if (ids.isEmpty) {
      // Fallback to LIKE on trimmed HH:MM
      print(
        'ScheduleRemoteDataSource.deleteEntry: exact match failed for subId=$subId start=$startFull end=$endFull - falling back to LIKE',
      );
      final startTrim = _trimTime(startFull);
      final endTrim = _trimTime(endFull);

      matchedRows = await _client
          .from('schedule')
          .select('id')
          .eq('sub_id', subId)
          .like('start_time', '$startTrim%')
          .like('end_time', '$endTrim%')
          .eq('is_deleted', false);

      ids = (matchedRows as List<dynamic>).map((r) => r['id'] as int).toList();
      print(
        'ScheduleRemoteDataSource.deleteEntry: fallback LIKE found ${ids.length} rows for subId=$subId',
      );
    } else {
      print(
        'ScheduleRemoteDataSource.deleteEntry: exact match found ${ids.length} rows for entryId=$entryId',
      );
    }

    if (ids.isNotEmpty) {
      await _client
          .from('schedule')
          .update({'is_deleted': true})
          .inFilter('id', ids)
          .eq('is_deleted', false);
      print(
        'ScheduleRemoteDataSource.deleteEntry: marked ${ids.length} rows is_deleted=true',
      );
    } else {
      print(
        'ScheduleRemoteDataSource.deleteEntry: no rows marked deleted for entryId=$entryId',
      );
    }
  }

  String _trimTime(String raw) => raw.length >= 5 ? raw.substring(0, 5) : raw;

  /// Ensure a time string is in `HH:MM:SS` form. If input is `HH:MM` this
  /// appends `:00`. If it's already `HH:MM:SS` it is returned unchanged.
  String _withSeconds(String t) {
    if (t.length == 5) return '$t:00';
    if (t.length == 8) return t;
    // Fallback: return as-is to avoid altering unexpected formats.
    return t;
  }
}

class _GroupedEntry {
  final int id;
  final int subId;
  final String subjectName;
  final String subjectCode;
  final String startTime;
  final String endTime;
  final List<String> days;

  _GroupedEntry({
    required this.id,
    required this.subId,
    required this.subjectName,
    required this.subjectCode,
    required this.startTime,
    required this.endTime,
    required this.days,
  });
}
