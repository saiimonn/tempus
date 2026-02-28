import 'package:tempus/features/tasks/domain/repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repo;

  DeleteTask(this.repo);

  Future <void> call(int taskId) => repo.deleteTask(taskId);
}