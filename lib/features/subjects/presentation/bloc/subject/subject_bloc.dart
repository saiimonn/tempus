import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/subjects/data/data_source/subject_remote_data_source.dart';
import 'package:tempus/features/subjects/data/repositories/subject_repository_impl.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_subject.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_subjects.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final GetSubjects _getSubjects;
  final AddSubject _addSubject;

  final void Function()? onSubjectAdded;

  SubjectBloc({
    required GetSubjects getSubjects,
    required AddSubject addSubject,
    this.onSubjectAdded,
  })  : _getSubjects = getSubjects,
        _addSubject = addSubject,
        super(SubjectInitial()) {
    on<SubjectLoadRequested>(_onLoad);
    on<SubjectAddRequested>(_onAdd);
  }

  factory SubjectBloc.create() {
    final repo =
        SubjectRepositoryImpl(SubjectRemoteDataSource(Supabase.instance.client));
    return SubjectBloc(
      getSubjects: GetSubjects(repo),
      addSubject: AddSubject(repo),
    );
  }

  Future<void> _onLoad(
    SubjectLoadRequested event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    try {
      final subjects = await _getSubjects();
      emit(SubjectLoaded(subjects));
    } catch (_) {
      emit(SubjectError('Failed to load subjects'));
    }
  }

  Future<void> _onAdd(
    SubjectAddRequested event,
    Emitter<SubjectState> emit,
  ) async {
    if (state is! SubjectLoaded) return;
    final curr = state as SubjectLoaded;
    try {
      final added = await _addSubject(event.subject);
      emit(SubjectLoaded([...curr.subjects, added]));
      onSubjectAdded?.call();
    } catch (_) {
      emit(SubjectError('Failed to add subject'));
    }
  }
}