import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_subject.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_subjects.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final GetSubjects _getSubjects;
  final AddSubject _addSubject;

  SubjectBloc({
    required GetSubjects getSubjects,
    required AddSubject addSubject,
  }) : _getSubjects = getSubjects,
      _addSubject = addSubject,
      super(SubjectInitial()) {
    on<SubjectLoadRequested>(_onLoad);
    on<SubjectAddRequested>(_onAdd);
  }

  Future<void> _onLoad(
    SubjectLoadRequested event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    try {
      final subjects = await _getSubjects();
      emit(SubjectLoaded(subjects));
    } catch(_) {
      emit(SubjectError('Failed to load subjects'));
    }
  }

  Future<void> _onAdd(
    SubjectAddRequested event,
    Emitter <SubjectState> emit,
  ) async {
    if (state is! SubjectLoaded) return;

    final curr = state as SubjectLoaded;

    try {
      final added = await _addSubject(event.subject);
      emit(SubjectLoaded([...curr.subjects, added]));
    } catch (_) {
      emit(SubjectError('Failed to add subject'));
    }
  }
}