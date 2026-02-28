import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/tasks/domain/entities/task_entity.dart';
import 'package:tempus/features/tasks/domain/use_cases/add_task.dart';
import 'package:tempus/features/tasks/domain/use_cases/delete_task.dart';
import 'package:tempus/features/tasks/domain/use_cases/get_tasks.dart';
import 'package:tempus/features/tasks/domain/use_cases/update_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks _getTasks;
  final AddTask _addTask;
  final DeleteTask _deleteTask;
  final UpdateTask _updateTask;

  TaskBloc({
    required GetTasks getTasks,
    required AddTask addTask,
    required DeleteTask deleteTasks,
    required UpdateTask updateTasks,
  }) : _getTasks = getTasks,
      _addTask = addTask,
      _deleteTask = deleteTasks,
      _updateTask = updateTasks,
      super(TaskInitial()) {
    on<TaskLoadRequested>(_onLoad);
    on<TaskAddRequested>(_onAdd);
    on<TaskToggleCompleted>(_onToggleCompleted);
    on<TaskDeleteRequested>(_onDelete);
    on<TaskSectionToggled>(_onSectionToggled);
  }

  Future <void> _onLoad(
    TaskLoadRequested event,
    Emitter <TaskState> emit,
  ) async {
    emit(TaskLoading());

    try {
      final tasks = await _getTasks();
      emit(TaskLoaded(tasks));
    } catch(_) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  Future <void> _onAdd(
    TaskAddRequested event,
    Emitter <TaskState> emit,
  ) async {
    if(state is! TaskLoaded) return;

    final curr = state as TaskLoaded;

    try {
      final added = await _addTask(event.task);
      emit(curr.copyWith(tasks: [...curr.tasks, added]));
    } catch(_) {
      emit(TaskError('Failed to add task'));
    }
  }

  Future <void> _onToggleCompleted(
    TaskToggleCompleted event,
    Emitter <TaskState> emit,
  ) async {
    if (state is! TaskLoaded) return;
    final curr = state as TaskLoaded;

    final task = curr.tasks.firstWhere((t) => t.id == event.taskId);
    final updated = task.copyWith(
      status: task.isComplete ? 'pending' : 'completed',
    );

    final updatedList = curr.tasks.map((t) => t.id == event.taskId ? updated : t).toList();
    emit(curr.copyWith(tasks: updatedList));

    try {
      await _updateTask(updated);
    } catch (_) {
      emit(curr);
    }
  }

  Future <void> _onDelete(
    TaskDeleteRequested event,
    Emitter <TaskState> emit,
  ) async {
    if (state is! TaskLoaded) return;

    final curr = state as TaskLoaded;

    try {
      await _deleteTask(event.taskId);
      emit(curr.copyWith(
        tasks: curr.tasks.where((t) => t.id != event.taskId).toList(),
      ));
    } catch(_) {
      emit(TaskError('Failed to  delete task'));
    }
  }

  void _onSectionToggled(
    TaskSectionToggled event,
    Emitter<TaskState> emit,
  ) {
    if (state is! TaskLoaded) return;

    final curr = state as TaskLoaded;
    final expanded = Set<String>.from(curr.expandedSections);

    if (expanded.contains(event.sectionName)) {
      expanded.remove(event.sectionName);
    } else {
      expanded.add(event.sectionName);
    }

    emit(curr.copyWith(expandedSections: expanded));
  }

}