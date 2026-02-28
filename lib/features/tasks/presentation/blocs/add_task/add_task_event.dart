part of 'add_task_bloc.dart';

sealed class AddTaskEvent {}

class AddTaskDueDateChanged extends AddTaskEvent {
  final DateTime date;
  AddTaskDueDateChanged(this.date);
}

class AddTaskDueDateCleared extends AddTaskEvent {}

class AddTaskDueTimeChanged extends AddTaskEvent {
  final String time; // "HH:mm"
  AddTaskDueTimeChanged(this.time);
}