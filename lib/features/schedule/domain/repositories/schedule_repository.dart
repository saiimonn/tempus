import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_subject_entity.dart';

abstract class ScheduleRepository {
  Future <List<ScheduleSubjectEntity>> getSubjects();
  Future <List<ScheduleEntryEntity>> getEntries();
  Future <ScheduleEntryEntity> addEntry({
    required int subId,
    required String subjectName,
    required String subjectCode,
    required List<String> days,
    required String startTime,
    required String endTime,
  });
  Future <void> deleteEntry(int entryId);
}