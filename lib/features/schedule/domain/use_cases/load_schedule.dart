import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_subject_entity.dart';
import 'package:tempus/features/schedule/domain/repositories/schedule_repository.dart';

class LoadSchedule {
  final ScheduleRepository repo;

  const LoadSchedule(this.repo);

  Future<({List<ScheduleSubjectEntity> subjects, List<ScheduleEntryEntity> entries})> call() async {
    final subjects = await repo.getSubjects();
    final entries = await repo.getEntries();
    return (subjects: subjects, entries: entries);
  }
}