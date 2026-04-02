part of 'subject_detail_bloc.dart';

sealed class SubjectDetailEvent {}

class SubjectDetailLoadRequested extends SubjectDetailEvent {
  final dynamic subjectId;
  SubjectDetailLoadRequested(this.subjectId);
}

class SubjectDetailCategoryAddRequested extends SubjectDetailEvent {
  final String name;
  final double weight;
  SubjectDetailCategoryAddRequested(this.name, this.weight);
}

class SubjectDetailCategoryUpdateRequested extends SubjectDetailEvent {
  final int categoryId;
  final String name;
  final double weight;
  SubjectDetailCategoryUpdateRequested(
    this.categoryId,
    this.name,
    this.weight,
  );
}

class SubjectDetailCategoryDeleteRequested extends SubjectDetailEvent {
  final int categoryId;
  SubjectDetailCategoryDeleteRequested(this.categoryId);
}

class SubjectDetailSubjectUpdateRequested extends SubjectDetailEvent {
  final SubjectEntity subject;
  SubjectDetailSubjectUpdateRequested(this.subject);
}
