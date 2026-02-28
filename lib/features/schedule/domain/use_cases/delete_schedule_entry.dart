import 'package:tempus/features/schedule/domain/repositories/schedule_repository.dart';

class DeleteScheduleEntry {
  final ScheduleRepository repo;

  const DeleteScheduleEntry(this.repo);

  Future <void> call(int entryId) => repo.deleteEntry(entryId);
}