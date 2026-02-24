import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/schedule/data/schedule_model.dart';

// EVENTS
abstract class ScheduleEvent {}

class LoadSchedule extends ScheduleEvent {}

class AddScheduleEntry extends ScheduleEvent {
  final int subId;
  final String subjectName;
  final String subjectCode;
  final List<String> days;
  final String startTime;
  final String endTime;

  AddScheduleEntry({
    required this.subId,
    required this.subjectName,
    required this.subjectCode,
    required this.days,
    required this.startTime,
    required this.endTime,
  });
}

class DeleteScheduleEntry extends ScheduleEvent {
  final int entryid;
  DeleteScheduleEntry({required this.entryid});
}

class SelectDay extends ScheduleEvent {
  final int dayIndex; // 0 = Monday, 6 = Sunday
  SelectDay(this.dayIndex);
}

class NavigateDayPrev extends ScheduleEvent {}

class NavigateDayNext extends ScheduleEvent {}

// STATES
abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<Map<String, dynamic>> subjects;
  final List<ScheduleEntry> entries;
  final int selectedDayIndex; // 0 = Monday, 6 = Sunday

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

  List<ScheduleEntry> get entriesForSelectedDay =>
      entries.where((e) => e.days.contains(selectedDayName)).toList();

  ScheduleLoaded copyWith({
    List<Map<String, dynamic>>? subjects,
    List<ScheduleEntry>? entries,
    int? selectedDayIndex,
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

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial()) {
    on<LoadSchedule>(_onLoad);
    on<AddScheduleEntry>(_onAdd);
    on<DeleteScheduleEntry>(_onDelete);
    on<SelectDay>(_onSelectDay);
    on<NavigateDayPrev>(_onPrev);
    on<NavigateDayNext>(_onNext);
  }

  Future<void> _onLoad(
    LoadSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    await Future.delayed(const Duration(milliseconds: 500));

    // Determine today's index (0=Mon, 6=Sun), default to 0 if weekend
    final now = DateTime.now();
    final todayIndex = now.weekday - 1; // DateTime: 1=Mon, 7=Sun → 0–6

    // MOCK DATA
    final subjects = <Map<String, dynamic>>[
      {'id': 1, 'name': 'Mathematics', 'code': 'MATH101'},
      {'id': 2, 'name': 'Physics', 'code': 'PHYS202'},
      {'id': 3, 'name': 'Data Structures and Algorithms', 'code': 'CS2101'},
    ];

    final entries = <ScheduleEntry>[
      ScheduleEntry(
        id: 1,
        subId: 1,
        subjectName: 'Data Structures and Algorithms',
        subjectCode: 'DSA',
        days: ['Monday', 'Wednesday', 'Friday'],
        startTime: '07:30',
        endTime: '10:00',
      ),
      ScheduleEntry(
        id: 2,
        subId: 2,
        subjectName: 'Object Oriented Programming',
        subjectCode: 'OOP',
        days: ['Monday', 'Tuesday', 'Thursday'],
        startTime: '10:00',
        endTime: '12:30',
      ),
      ScheduleEntry(
        id: 3,
        subId: 3,
        subjectName: 'Technical and Professional English',
        subjectCode: 'TPE',
        days: ['Monday', 'Wednesday'],
        startTime: '13:00',
        endTime: '14:00',
      ),
      ScheduleEntry(
        id: 4,
        subId: 1,
        subjectName: 'Data Structures and Algorithms Practicum',
        subjectCode: 'DATAP',
        days: ['Monday', 'Friday'],
        startTime: '15:00',
        endTime: '16:30',
      ),
    ];

    emit(ScheduleLoaded(
      subjects: subjects,
      entries: entries,
      selectedDayIndex: todayIndex.clamp(0, 6),
    ));
  }

  void _onAdd(
    AddScheduleEntry event,
    Emitter<ScheduleState> emit,
  ) {
    if (state is! ScheduleLoaded) return;
    final current = state as ScheduleLoaded;

    final newEntry = ScheduleEntry(
      id: DateTime.now().millisecondsSinceEpoch,
      subId: event.subId,
      subjectName: event.subjectName,
      subjectCode: event.subjectCode,
      days: event.days,
      startTime: event.startTime,
      endTime: event.endTime,
    );

    emit(current.copyWith(entries: [...current.entries, newEntry]));
  }

  void _onDelete(
    DeleteScheduleEntry event,
    Emitter<ScheduleState> emit,
  ) {
    if (state is! ScheduleLoaded) return;
    final current = state as ScheduleLoaded;

    emit(current.copyWith(
      entries: current.entries.where((e) => e.id != event.entryid).toList(),
    ));
  }

  void _onSelectDay(SelectDay event, Emitter<ScheduleState> emit) {
    if (state is! ScheduleLoaded) return;
    final current = state as ScheduleLoaded;
    emit(current.copyWith(selectedDayIndex: event.dayIndex.clamp(0, 6)));
  }

  void _onPrev(NavigateDayPrev event, Emitter<ScheduleState> emit) {
    if (state is! ScheduleLoaded) return;
    final current = state as ScheduleLoaded;
    final newIndex = (current.selectedDayIndex - 1).clamp(0, 6);
    emit(current.copyWith(selectedDayIndex: newIndex));
  }

  void _onNext(NavigateDayNext event, Emitter<ScheduleState> emit) {
    if (state is! ScheduleLoaded) return;
    final current = state as ScheduleLoaded;
    final newIndex = (current.selectedDayIndex + 1).clamp(0, 6);
    emit(current.copyWith(selectedDayIndex: newIndex));
  }
}