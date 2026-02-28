part of 'add_schedule_bloc.dart';

sealed class AddScheduleEvent {}

class AddScheduleSubjectSelected extends AddScheduleEvent {
  final ScheduleSubjectEntity subject;
  AddScheduleSubjectSelected(this.subject);
}

class AddScheduleDayToggled extends AddScheduleEvent {
  final String day;
  AddScheduleDayToggled(this.day);
}

class AddScheduleStartTimeChanged extends AddScheduleEvent {
  final TimeOfDay time;
  AddScheduleStartTimeChanged(this.time);
}

class AddScheduleEndTimeChanged extends AddScheduleEvent {
  final TimeOfDay time;
  AddScheduleEndTimeChanged(this.time);
}