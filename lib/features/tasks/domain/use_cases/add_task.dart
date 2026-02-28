import 'package:tempus/features/tasks/domain/entities/task_entity.dart';
import 'package:tempus/features/tasks/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repo;

  AddTask(this.repo);

  Future <TaskEntity> call(TaskEntity task) => repo.addTask(task); 
}