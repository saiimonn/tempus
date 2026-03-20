import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:tempus/features/tasks/data/models/task_model.dart';
import 'package:tempus/features/tasks/domain/entities/task_entity.dart';
import 'package:tempus/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource dataSource;

  const TaskRepositoryImpl(this.dataSource);

  factory TaskRepositoryImpl.create() =>
      TaskRepositoryImpl(TaskRemoteDataSource(Supabase.instance.client));

  @override
  Future<List<TaskEntity>> getTasks() => dataSource.getTasks();

  @override
  Future<TaskEntity> addTask(TaskEntity task) {
    final model = TaskModel.fromEntity(task);
    return dataSource.addTask(model);
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) {
    final model = TaskModel.fromEntity(task);
    return dataSource.updateTask(model);
  }

  @override
  Future<void> deleteTask(int taskId) => dataSource.deleteTask(taskId);
}
