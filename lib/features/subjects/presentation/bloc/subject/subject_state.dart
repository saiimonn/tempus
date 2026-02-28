part of 'subject_bloc.dart';

sealed class SubjectState {}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final List<SubjectEntity> subjects;
  SubjectLoaded(this.subjects);
}

class SubjectError extends SubjectState {
  final String message;
  SubjectError(this.message);
}