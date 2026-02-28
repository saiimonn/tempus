part of 'schedule_bloc.dart';

sealed class ScheduleEvent {}

class ScheduleLoadRequested extends ScheduleEvent {}

class ScheduleEntryAddRequested extends ScheduleEvent {
  final int subId;
  final String subjectName;
  final String subjectCode;
  final List<String> days;
  final String startTime;
  final String endTime;

  ScheduleEntryAddRequested({
    required this.subId,
    required this.subjectName,
    required this.subjectCode,
    required this.days,
    required this.startTime,
    required this.endTime,
  });
}

class ScheduleEntryDeleteRequested extends ScheduleEvent {
  final int entryId;
  ScheduleEntryDeleteRequested(this.entryId);
}

class ScheduleDaySelected extends ScheduleEvent {
  final int dayIndex;
  ScheduleDaySelected(this.dayIndex);
}

class ScheduleDayPrevRequested extends ScheduleEvent {}

class ScheduleDayNextRequested extends ScheduleEvent {}