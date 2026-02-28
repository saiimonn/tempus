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

class AddTaskSubjectSelected extends AddTaskEvent {
  final int id;
  final String name;
  final String code;
  AddTaskSubjectSelected({
    required this.id,
    required this.name,
    required this.code,
  });
}

class AddTaskSubjectCleared extends AddTaskEvent {}