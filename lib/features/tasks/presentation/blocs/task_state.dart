part of 'task_bloc.dart';

sealed class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;

  TaskLoaded(this.tasks);

  List<TaskEntity> get todayTasks => tasks
    .where((t) => !t.isComplete && t.isToday)
    .toList();

  List<TaskEntity> get upcomingTasks => tasks
    .where((t) => !t.isComplete && t.isUpcoming)
    .toList();

  List<TaskEntity> get noDueTasks => tasks
    .where((t) => !t.isComplete && t.hasNoDue)
    .toList();

  List<TaskEntity> get completedTasks => tasks
    .where((t) => t.isComplete)
    .toList();

  int get pendingCount => tasks.where((t) => !t.isComplete).length;
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}