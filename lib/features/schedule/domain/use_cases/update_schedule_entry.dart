import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';
import 'package:tempus/features/schedule/domain/repositories/schedule_repository.dart';

class UpdateScheduleEntry {
  final ScheduleRepository repo;

  const UpdateScheduleEntry(this.repo);

  Future<ScheduleEntryEntity> call({
    required int entryId,
    required int subId,
    required String subjectName,
    required String subjectCode,
    required List<String> days,
    required String startTime,
    required String endTime,
  }) => repo.updateEntry(
    entryId: entryId,
    subId: subId,
    subjectName: subjectName,
    subjectCode: subjectCode,
    days: days,
    startTime: startTime,
    endTime: endTime,
  );
}
