import 'package:tempus/features/tasks/domain/entities/task_entity.dart';
import 'package:tempus/features/tasks/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repo;

  GetTasks(this.repo);

  Future <List<TaskEntity>> call() => repo.getTasks();
}