import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_subject_entity.dart';

part 'add_schedule_event.dart';
part 'add_schedule_state.dart';

const ScheduleDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class AddScheduleBloc extends Bloc<AddScheduleEvent, AddScheduleState> {
  AddScheduleBloc() : super(const AddScheduleState()) {
    on<AddScheduleSubjectSelected>(_onSubjectSelected);
    on<AddScheduleDayToggled>(_onDayToggled);
    on<AddScheduleStartTimeChanged>(_onStartTimeChanged);
    on<AddScheduleEndTimeChanged>(_onEndTimeChanged);
  }

  void _onSubjectSelected(
    AddScheduleSubjectSelected event,
    Emitter <AddScheduleState> emit,
  ) {
    emit(state.copyWith(selectedSubject: event.subject));
  }

  void _onDayToggled(
    AddScheduleDayToggled event,
    Emitter <AddScheduleState> emit,
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
    AddScheduleStartTimeChanged event,
    Emitter <AddScheduleState> emit,
  ) {
    final picked = event.time;
    final startMins = picked.hour * 60 + picked.minute;
    final endMins = state.endTime.hour * 60 + state.endTime.minute;

    TimeOfDay newEnd = state.endTime;

    if(endMins <= startMins) {
      final bumped = startMins + 90;
      newEnd = TimeOfDay(hour: (bumped ~/60) % 24, minute: bumped % 60);
    }

    emit(state.copyWith(startTime: picked, endTime: newEnd));
  }

  void _onEndTimeChanged(
    AddScheduleEndTimeChanged event,
    Emitter <AddScheduleState> emit,
  ) {
    emit(state.copyWith(endTime: event.time));
  }
}