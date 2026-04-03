import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_subject_entity.dart';
import 'package:tempus/features/schedule/domain/use_cases/add_schedule_entry.dart';
import 'package:tempus/features/schedule/domain/use_cases/update_schedule_entry.dart';
import 'package:tempus/features/schedule/domain/use_cases/delete_schedule_entry.dart';
import 'package:tempus/features/schedule/domain/use_cases/load_schedule.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final LoadSchedule _loadSchedule;
  final AddScheduleEntry _addScheduleEntry;
  final UpdateScheduleEntry _updateScheduleEntry;
  final DeleteScheduleEntry _deleteScheduleEntry;

  ScheduleBloc({
    required LoadSchedule loadSchedule,
    required AddScheduleEntry addScheduleEntry,
    required UpdateScheduleEntry updateScheduleEntry,
    required DeleteScheduleEntry deleteScheduleEntry,
  }) : _loadSchedule = loadSchedule,
       _addScheduleEntry = addScheduleEntry,
       _updateScheduleEntry = updateScheduleEntry,
       _deleteScheduleEntry = deleteScheduleEntry,
       super(ScheduleInitial()) {
    on<ScheduleLoadRequested>(_onLoad);
    on<ScheduleSubjectsRefreshRequested>(_onRefreshSubjects);
    on<ScheduleEntryAddRequested>(_onAdd);
    on<ScheduleEntryUpdateRequested>(_onUpdate);
    on<ScheduleEntryDeleteRequested>(_onDelete);
    on<ScheduleDaySelected>(_onSelectDay);
    on<ScheduleDayPrevRequested>(_onPrev);
    on<ScheduleDayNextRequested>(_onNext);
  }

  Future<void> _onLoad(
    ScheduleLoadRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    try {
      final result = await _loadSchedule();
      final todayIndex = (DateTime.now().weekday - 1).clamp(0, 6);
      emit(
        ScheduleLoaded(
          subjects: result.subjects,
          entries: result.entries,
          selectedDayIndex: todayIndex,
        ),
      );
    } catch (_) {
      emit(ScheduleError('Failed to load schedule'));
    }
  }

  Future<void> _onRefreshSubjects(
    ScheduleSubjectsRefreshRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state is! ScheduleLoaded) return;
    final current = state as ScheduleLoaded;

    try {
      final result = await _loadSchedule();
      emit(current.copyWith(subjects: result.subjects));
    } catch (_) {}
  }

  Future<void> _onAdd(
    ScheduleEntryAddRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state is! ScheduleLoaded) return;
    final current = state as ScheduleLoaded;
    try {
      final inserted = await _addScheduleEntry(
        subId: event.subId,
        subjectName: event.subjectName,
        subjectCode: event.subjectCode,
        days: event.days,
        startTime: event.startTime,
        endTime: event.endTime,
      );
      emit(current.copyWith(entries: [...current.entries, inserted]));
    } catch (_) {
      emit(ScheduleError('Failed to add schedule entry'));
    }
  }

  Future<void> _onUpdate(
    ScheduleEntryUpdateRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state is! ScheduleLoaded) return;

    final curr = state as ScheduleLoaded;

    final optimistic = curr.entries.map((e) {
      if (e.id != event.entryId) return e;

      return e.copyWith(
        subId: event.subId,
        subjectName: event.subjectName,
        subjectCode: event.subjectCode,
        days: event.days,
        startTime: event.startTime,
        endTime: event.endTime,
      );
    }).toList();

    emit(curr.copyWith(entries: optimistic));

    try {
      final updated = await _updateScheduleEntry(
        entryId: event.entryId,
        subId: event.subId,
        subjectName: event.subjectName,
        subjectCode: event.subjectCode,
        days: event.days,
        startTime: event.startTime,
        endTime: event.endTime,
      );

      final confirmed = curr.entries
          .map((e) => e.id == event.entryId ? updated : e)
          .toList();

      // After successfully updating on the server, refresh the full schedule
      // from the backend so the UI reflects the canonical DB state (grouping,
      // generated ids, and any server-side normalization).
      try {
        final result = await _loadSchedule();
        emit(
          ScheduleLoaded(
            subjects: result.subjects,
            entries: result.entries,
            selectedDayIndex: curr.selectedDayIndex,
          ),
        );
      } catch (_) {
        // If reload fails for any reason, fall back to the optimistic confirmed
        // state so the UI still reflects the update immediately.
        emit(curr.copyWith(entries: confirmed));
      }
    } catch (_) {
      emit(curr);
    }
  }

  Future<void> _onDelete(
    ScheduleEntryDeleteRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state is! ScheduleLoaded) return;
    final current = state as ScheduleLoaded;
    try {
      await _deleteScheduleEntry(event.entryId);
      emit(
        current.copyWith(
          entries: current.entries.where((e) => e.id != event.entryId).toList(),
        ),
      );
    } catch (_) {
      emit(ScheduleError('Failed to delete schedule entry'));
    }
  }

  void _onSelectDay(ScheduleDaySelected event, Emitter<ScheduleState> emit) {
    if (state is! ScheduleLoaded) return;
    emit(
      (state as ScheduleLoaded).copyWith(
        selectedDayIndex: event.dayIndex.clamp(0, 6),
      ),
    );
  }

  void _onPrev(ScheduleDayPrevRequested event, Emitter<ScheduleState> emit) {
    if (state is! ScheduleLoaded) return;
    final current = state as ScheduleLoaded;
    emit(
      current.copyWith(
        selectedDayIndex: (current.selectedDayIndex - 1).clamp(0, 6),
      ),
    );
  }

  void _onNext(ScheduleDayNextRequested event, Emitter<ScheduleState> emit) {
    if (state is! ScheduleLoaded) return;
    final current = state as ScheduleLoaded;
    emit(
      current.copyWith(
        selectedDayIndex: (current.selectedDayIndex + 1).clamp(0, 6),
      ),
    );
  }
}
