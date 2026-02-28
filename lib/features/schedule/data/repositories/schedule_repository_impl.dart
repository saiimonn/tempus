import 'package:tempus/features/schedule/data/data_sources/schedule_local_data_source.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_subject_entity.dart';
import 'package:tempus/features/schedule/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleLocalDataSource dataSource;

  const ScheduleRepositoryImpl(this.dataSource);

  @override
  Future <List<ScheduleSubjectEntity>> getSubjects() => 
    dataSource.getSubjects();

  @override 
  Future <List<ScheduleEntryEntity>> getEntries() => 
    dataSource.getEntries();

  @override
  Future <ScheduleEntryEntity> addEntry({
    required int subId,
    required String subjectName,
    required String subjectCode,
    required List<String> days,
    required String startTime,
    required String endTime,
  }) => dataSource.addEntry(
    subId: subId,
    subjectName: subjectName,
    subjectCode: subjectCode,
    days: days,
    startTime: startTime,
    endTime: endTime,
  );

  @override 
  Future <void> deleteEntry(int entryId) => dataSource.deleteEntry(entryId);
}