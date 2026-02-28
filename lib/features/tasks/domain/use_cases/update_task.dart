import 'package:tempus/features/tasks/domain/entities/task_entity.dart';
import 'package:tempus/features/tasks/domain/repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repo;

  UpdateTask(this.repo);

  Future <TaskEntity> call(TaskEntity task) => repo.updateTask(task);
}