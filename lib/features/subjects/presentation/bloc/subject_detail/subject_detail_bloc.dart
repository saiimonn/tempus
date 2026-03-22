import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/subjects/domain/entities/subject_detail_entity.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_grade_category.dart';
import 'package:tempus/features/subjects/domain/use_cases/delete_grade_category.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_subject_detail.dart';

part 'subject_detail_event.dart';
part 'subject_detail_state.dart';

class SubjectDetailBloc extends Bloc<SubjectDetailEvent, SubjectDetailState> {
  final GetSubjectDetail _getSubjectDetail;
  final AddGradeCategory _addGradeCategory;
  final DeleteGradeCategory _deleteGradeCategory;

  int? _subjectId;

  SubjectDetailBloc({
    required GetSubjectDetail getSubjectDetail,
    required AddGradeCategory addGradeCategory,
    required DeleteGradeCategory deleteGradeCategory,
  })  : _getSubjectDetail = getSubjectDetail,
        _addGradeCategory = addGradeCategory,
        _deleteGradeCategory = deleteGradeCategory,
        super(SubjectDetailInitial()) {
    on<SubjectDetailLoadRequested>(_onLoad);
    on<SubjectDetailCategoryAddRequested>(_onAddCategory);
    on<SubjectDetailCategoryDeleteRequested>(_onDeleteCategory);
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
}