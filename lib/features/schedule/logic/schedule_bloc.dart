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

// STATES
abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<Map<String, dynamic>> subjects;

  final List<ScheduleEntry> entries;

  ScheduleLoaded({required this.subjects, required this.entries});

  ScheduleLoaded copyWith({
    List<Map<String, dynamic>>? subjects,
    List<ScheduleEntry>? entries,
  }) {
    return ScheduleLoaded(
      subjects: subjects ?? this.subjects,
      entries: entries ?? this.entries,
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
  }

  Future<void> _onLoad(
    LoadSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    await Future.delayed(Duration(milliseconds: 500));

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
        subjectName: 'Mathematics',
        subjectCode: 'MATH101',
        days: ['Monday', 'Wednesday', 'Friday'],
        startTime: '08:00',
        endTime: '09:30',
      ),

      ScheduleEntry(
        id: 2,
        subId: 2,
        subjectName: 'Physics',
        subjectCode: 'PHYS202',
        days: ['Tuesday', 'Thursday'],
        startTime: '10:00',
        endTime: '11:30',
      ),
    ];

    emit(ScheduleLoaded(subjects: subjects, entries: entries));
  }

  void _onAdd(
    AddScheduleEntry event,
    Emitter<ScheduleState> emit,
  ) {
    if(state is! ScheduleLoaded) return;

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

    emit(current.copyWith(
      entries: [...current.entries, newEntry],
    ));
  }

  void _onDelete(
    DeleteScheduleEntry event,
    Emitter<ScheduleState> emit,
  ) {
    if (state is! ScheduleLoaded) return;
    
    final current= state as ScheduleLoaded;

    emit(current.copyWith(
      entries: current.entries
        .where((e) => e.id != event.entryid)
        .toList(),
    ));
  }
}