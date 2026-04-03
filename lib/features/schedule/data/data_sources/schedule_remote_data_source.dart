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
                  'start_time': startTime,
                  'end_time': endTime,
                },
              )
              .toList(),
        )
        .select('id');

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
    final oldStart = seed['start_time'] as String;
    final oldEnd = seed['end_time'] as String;

    await _client
        .from('schedule')
        .update({'is_deleted': true})
        .eq('sub_id', oldSubId)
        .eq('start_time', oldStart)
        .eq('end_time', oldEnd)
        .eq('is_deleted', false);

    final rows = await _client
        .from('schedule')
        .insert(
          days
              .map(
                (day) => {
                  'sub_id': subId,
                  'day': day,
                  'start_time': startTime,
                  'end_time': endTime,
                },
              )
              .toList(),
        )
        .select('id');

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

  Future<void> deleteEntry(int entryId) async {
    final seed = await _client
        .from('schedule')
        .select('sub_id, start_time, end_time')
        .eq('id', entryId)
        .single();

    final subId = seed['sub_id'] as int;
    final startTime = seed['start_time'] as String;
    final endTime = seed['end_time'] as String;

    await _client
        .from('schedule')
        .update({'is_deleted': true})
        .eq('sub_id', subId)
        .eq('start_time', startTime)
        .eq('end_time', endTime)
        .eq('is_deleted', false);
  }

  String _trimTime(String raw) => raw.length >= 5 ? raw.substring(0, 5) : raw;
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
