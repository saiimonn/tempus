part of 'schedule_bloc.dart';

sealed class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleSubjectEntity> subjects;
  final List<ScheduleEntryEntity> entries;
  final int selectedDayIndex;

  static const List<String> dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  ScheduleLoaded({
    required this.subjects,
    required this.entries,
    this.selectedDayIndex = 0,
  });

  String get selectedDayName => dayNames[selectedDayIndex];

  List <ScheduleEntryEntity> get entriesForSelectedDay => 
    entries.where((e) => e.days.contains(selectedDayName)).toList();

  ScheduleLoaded copyWith({
    List<ScheduleSubjectEntity>? subjects,
    List<ScheduleEntryEntity>? entries,
    int? selectedDayIndex
  }) {
    return ScheduleLoaded(
      subjects: subjects ?? this.subjects,
      entries: entries ?? this.entries,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
    );
  }
}

class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError(this.message);
}