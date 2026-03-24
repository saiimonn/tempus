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
        'id': row['id'] as int,
        'name': row['name'] as String,
        'code': row['code'] as String,
      });
    }).toList();
  }

  Future<List<ScheduleEntryModel>> getEntries() async {
    final data = await _client
        .from('schedule')
        .select(
          'id, sub_id, day, start_time, end_time, subject:sub_id(name, code)',
        )
        .eq('is_deleted', false)
        .order('start_time', ascending: true);

    String trimTime(String raw) => raw.length >= 5 ? raw.substring(0, 5) : raw;

    final Map<String, Map<String, dynamic>> grouped = {};

    for (final row in data as List<dynamic>) {
      final subject = row['subject'] as Map<String, dynamic>?;
      final subId = row['sub_id'] as int;
      final start = trimTime(row['start_time'] as String);
      final end = trimTime(row['end_time'] as String);

      final key = '${subId}_${start}_$end';

      if (!grouped.containsKey(key)) {
        grouped[key] = {
          'id': row['id'] as int,
          'sub_id': subId,
          'subject_name': subject?['name'] as String? ?? '',
          'subject_code': subject?['code'] as String? ?? '',
          'start_time': start,
          'end_time': end,
          'days': <String>[],
        };
      }

      final day = row['day'] as String?;
      if (day != null && day.isNotEmpty) {
        (grouped[key]!['days'] as List<String>).add(day);
      }
    }

    return grouped.values.map(ScheduleEntryModel.fromMap).toList();
  }

  Future<ScheduleEntryModel> addEntry({
    required int subId,
    required String subjectName,
    required String subjectCode,
    required List<String> days,
    required String startTime,
    required String endTime,
  }) async {
    if (days.isEmpty) {
      throw ArgumentError('days must not be empty');
    }

    final rows = days
        .map(
          (day) => {
            'sub_id': subId,
            'day': day,
            'start_time': startTime,
            'end_time': endTime,
          },
        )
        .toList();

    final inserted = await _client
        .from('schedule')
        .insert(rows)
        .select('id, sub_id, start_time, end_time')
        .order('id', ascending: true);

    final firstRow = (inserted as List<dynamic>).first as Map<String, dynamic>;

    String trimTime(String raw) => raw.length >= 5 ? raw.substring(0, 5) : raw;

    return ScheduleEntryModel.fromMap({
      'id': firstRow['id'] as int,
      'sub_id': subId,
      'subject_name': subjectName,
      'subject_code': subjectCode,
      'days': days,
      'start_time': trimTime(firstRow['start_time'] as String),
      'end_time': trimTime(firstRow['end_time'] as String),
    });
  }

  Future<void> deleteEntry(int entryId) async {
    final anchor = await _client
        .from('schedule')
        .select('sub_id, start_time, end_time')
        .eq('id', entryId)
        .single();

    final subId = anchor['sub_id'] as int;
    final startTime = anchor['start_time'] as String;
    final endTime = anchor['end_time'] as String;

    await _client
        .from('schedule')
        .update({'is_deleted': true})
        .eq('sub_id', subId)
        .eq('start_time', startTime)
        .eq('end_time', endTime)
        .eq('is_deleted', false);
  }
}
