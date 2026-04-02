import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/subjects/domain/entities/subject_detail_entity.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_grade_category.dart';
import 'package:tempus/features/subjects/domain/use_cases/delete_grade_category.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_subject_detail.dart';
import 'package:tempus/features/subjects/domain/use_cases/update_grade_category.dart';
import 'package:tempus/features/subjects/domain/use_cases/update_subject.dart';

part 'subject_detail_event.dart';
part 'subject_detail_state.dart';

class SubjectDetailBloc extends Bloc<SubjectDetailEvent, SubjectDetailState> {
  final GetSubjectDetail _getSubjectDetail;
  final AddGradeCategory _addGradeCategory;
  final UpdateGradeCategory _updateGradeCategory;
  final DeleteGradeCategory _deleteGradeCategory;
  final UpdateSubject _updateSubject;

  int? _subjectId;

  SubjectDetailBloc({
    required GetSubjectDetail getSubjectDetail,
    required AddGradeCategory addGradeCategory,
    required UpdateGradeCategory updateGradeCategory,
    required DeleteGradeCategory deleteGradeCategory,
    required UpdateSubject updateSubject,
  }) : _getSubjectDetail = getSubjectDetail,
       _addGradeCategory = addGradeCategory,
       _updateGradeCategory = updateGradeCategory,
       _deleteGradeCategory = deleteGradeCategory,
       _updateSubject = updateSubject,
       super(SubjectDetailInitial()) {
    on<SubjectDetailLoadRequested>(_onLoad);
    on<SubjectDetailCategoryAddRequested>(_onAddCategory);
    on<SubjectDetailCategoryUpdateRequested>(_onUpdateCategory);
    on<SubjectDetailCategoryDeleteRequested>(_onDeleteCategory);
    on<SubjectDetailSubjectUpdateRequested>(_onUpdateSubject);
  }

  Future<void> _onLoad(
    SubjectDetailLoadRequested event,
    Emitter<SubjectDetailState> emit,
  ) async {
    _subjectId = event.subjectId;
    emit(SubjectDetailLoading());
    try {
      final detail = await _getSubjectDetail(event.subjectId);
      emit(SubjectDetailLoaded(detail));
    } catch (_) {
      emit(SubjectDetailError('Failed to load subject details'));
    }
  }

  Future<void> _onAddCategory(
    SubjectDetailCategoryAddRequested event,
    Emitter<SubjectDetailState> emit,
  ) async {
    if (_subjectId == null) return;
    try {
      await _addGradeCategory(
        subjectId: _subjectId!,
        name: event.name,
        weight: event.weight,
      );
      // Re-fetch to get accurate estimated grade (scores are included).
      final detail = await _getSubjectDetail(_subjectId!);
      emit(SubjectDetailLoaded(detail));
    } catch (_) {
      emit(SubjectDetailError('Failed to add category'));
    }
  }

  Future<void> _onUpdateCategory(
    SubjectDetailCategoryUpdateRequested event,
    Emitter<SubjectDetailState> emit,
  ) async {
    if (_subjectId == null) return;

    try {
      await _updateGradeCategory(
        categoryId: event.categoryId,
        name: event.name,
        weight: event.weight,
      );

      final detail = await _getSubjectDetail(_subjectId);
      emit(SubjectDetailLoaded(detail));
    } catch (_) {
      emit(SubjectDetailError('Failed to update category'));
    }
  }

  Future<void> _onDeleteCategory(
    SubjectDetailCategoryDeleteRequested event,
    Emitter<SubjectDetailState> emit,
  ) async {
    if (_subjectId == null) return;
    try {
      await _deleteGradeCategory(
        categoryId: event.categoryId,
        subjectId: _subjectId!,
      );
      // Re-fetch to keep estimated grade consistent.
      final detail = await _getSubjectDetail(_subjectId!);
      emit(SubjectDetailLoaded(detail));
    } catch (_) {
      emit(SubjectDetailError('Failed to delete category'));
    }
  }

  Future<void> _onUpdateSubject(
    SubjectDetailSubjectUpdateRequested event,
    Emitter<SubjectDetailState> emit,
  ) async {
    if (_subjectId == null) return;
    if (state is! SubjectDetailLoaded) return;
    final curr = state as SubjectDetailLoaded;

    try {
      await _updateSubject(event.subject);
      final detail = await _getSubjectDetail(_subjectId);
      emit(SubjectDetailLoaded(detail, savedSuccessfully: true));
    } catch (_) {
      emit(SubjectDetailLoaded(curr.detail, saveError: true));
    }
  }
}
