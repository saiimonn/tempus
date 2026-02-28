import 'package:tempus/features/tasks/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future <List<TaskEntity>> getTasks();
  Future <TaskEntity> addTask(TaskEntity task);
  Future <TaskEntity> updateTask(TaskEntity task);
  Future <void> deleteTask(int taskId);
}