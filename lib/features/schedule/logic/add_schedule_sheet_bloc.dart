import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const ScheduleDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

// EVENTS
abstract class AddScheduleEvent {}

class SubjectSelected extends AddScheduleEvent {
  final Map<String, dynamic> subject;
  SubjectSelected(this.subject);
}

class DayToggled extends AddScheduleEvent {
  final String day;
  DayToggled(this.day);
}

class StartTimeChanged extends AddScheduleEvent {
  final TimeOfDay time;
  StartTimeChanged(this.time);
}

class EndTimeChanged extends AddScheduleEvent {
  final TimeOfDay time;
  EndTimeChanged(this.time);
}

// STATE

class AddScheduleState {
  final Map<String, dynamic>? selectedSubject;
  final Set<String> selectedDays;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const AddScheduleState({
    this.selectedSubject,
    this.selectedDays = const {},
    this.startTime = const TimeOfDay(hour: 7, minute: 30),
    this.endTime = const TimeOfDay(hour: 9, minute: 0),
  });

  bool get timeInvalid {
    final s = startTime.hour * 60 + startTime.minute;
    final e = endTime.hour * 60 + endTime.minute;
    return e <= s;
  }

  bool get isValid => 
    selectedSubject != null && selectedDays.isNotEmpty && !timeInvalid;

  String get startTimeStr {
    final h = startTime.hour.toString().padLeft(2, '0');
    final m = startTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get endTimeStr {
    final h = endTime.hour.toString().padLeft(2, '0');
    final m = endTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  AddScheduleState copyWith({
    Map<String, dynamic>? selectedSubject,
    Set<String>? selectedDays,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool clearSubject = false,
  }) {
    return AddScheduleState(
      selectedSubject:
        clearSubject ? null : (selectedSubject ?? this.selectedSubject),
      selectedDays: selectedDays ?? this.selectedDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

class AddScheduleBloc extends Bloc<AddScheduleEvent, AddScheduleState> {
  AddScheduleBloc() : super(const AddScheduleState()) {
    on<SubjectSelected>(_onSubjectSelected);
    on<DayToggled>(_onDayToggled);
    on<StartTimeChanged>(_onStartTimeChanged);
    on<EndTimeChanged>(_onEndTimeChanged);
  }

  void _onSubjectSelected(
    SubjectSelected event,
    Emitter<AddScheduleState> emit,
  ) {
    emit(state.copyWith(selectedSubject: event.subject));
  }

  void _onDayToggled(
    DayToggled event,
    Emitter<AddScheduleState> emit,
  ) {
    final updated = Set<String>.from(state.selectedDays);
    if(updated.contains(event.day)) {
      updated.remove(event.day);
    } else {
      updated.add(event.day);
    }
    emit(state.copyWith(selectedDays: updated));
  }

  void _onStartTimeChanged(
    StartTimeChanged event,
    Emitter<AddScheduleState> emit,
  ) {
    final picked = event.time;

    final startMins = picked.hour * 60 + picked.minute;
    final endMins = picked.minute * 60 + state.endTime.minute;

    TimeOfDay newEnd = state.endTime;
    if (endMins >= startMins) {
      final bumped = startMins + 90;
      newEnd = TimeOfDay(hour: (bumped ~/ 60) % 24, minute: bumped % 60);
    }

    emit(state.copyWith(startTime: picked, endTime: newEnd));
  }

  void _onEndTimeChanged(
    EndTimeChanged event,
    Emitter<AddScheduleState> emit,
  ) {
    emit(state.copyWith(endTime: event.time));
  }
}