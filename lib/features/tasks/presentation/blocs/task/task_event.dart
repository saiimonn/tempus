part of 'task_bloc.dart';

sealed class TaskEvent {}

class TaskLoadRequested extends TaskEvent {}

class TaskAddRequested extends TaskEvent {
  final TaskEntity task;
  TaskAddRequested(this.task);
}

class TaskToggleCompleted extends TaskEvent {
  final int taskId;
  TaskToggleCompleted(this.taskId);
}

class TaskDeleteRequested extends TaskEvent {
  final int taskId;
  TaskDeleteRequested(this.taskId);
}

class TaskSectionToggled extends TaskEvent {
  final String sectionName;
  TaskSectionToggled(this.sectionName);
}