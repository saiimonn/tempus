import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';
import 'package:tempus/features/schedule/domain/repositories/schedule_repository.dart';

class AddScheduleEntry {
  final ScheduleRepository repo;

  const AddScheduleEntry(this.repo);

  Future<ScheduleEntryEntity> call({
    required int subId,
    required String subjectName,
    required String subjectCode,
    required List<String> days,
    required String startTime,
    required String endTime,
  }) => repo.addEntry(
    subId: subId,
    subjectName: subjectName,
    subjectCode: subjectCode,
    days: days,
    startTime: startTime,
    endTime: endTime,
  );
}
