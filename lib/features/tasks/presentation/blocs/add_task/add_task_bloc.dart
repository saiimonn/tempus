import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_task_event.dart';
part 'add_task_state.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  AddTaskBloc() : super(const AddTaskState()) {
    on<AddTaskDueDateChanged>(_onDueDateChanged);
    on<AddTaskDueDateCleared>(_onDueDateCleared);
    on<AddTaskDueTimeChanged>(_onDueTimeChanged);
    on<AddTaskSubjectSelected>(_onSubjectSelected);
    on<AddTaskSubjectCleared>(_onSubjectCleared);
  }

  void _onDueDateChanged(
    AddTaskDueDateChanged event,
    Emitter<AddTaskState> emit,
  ) {
    emit(state.copyWith(dueDate: event.date));
  }

  void _onDueDateCleared(
    AddTaskDueDateCleared event,
    Emitter<AddTaskState> emit,
  ) {
    emit(state.copyWith(clearDueDate: true, clearDueTime: true));
  }

  void _onDueTimeChanged(
    AddTaskDueTimeChanged event,
    Emitter<AddTaskState> emit,
  ) {
    emit(state.copyWith(dueTime: event.time));
  }

  void _onSubjectSelected(
    AddTaskSubjectSelected event,
    Emitter <AddTaskState> emit,
  ) {
    emit(state.copyWith(
      selectedSubject: SelectedSubject(
        id: event.id,
        name: event.name,
        code: event.code,
      ),
    ));
  }

  void _onSubjectCleared(
    AddTaskSubjectCleared event,
    Emitter <AddTaskState> emit,
  ) {
    emit(state.copyWith(clearSubject: true));
  }
}