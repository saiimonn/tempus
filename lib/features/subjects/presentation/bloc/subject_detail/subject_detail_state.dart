part of 'subject_detail_bloc.dart';

sealed class SubjectDetailState {}

class SubjectDetailInitial extends SubjectDetailState {}

class SubjectDetailLoading extends SubjectDetailState {}

class SubjectDetailLoaded extends SubjectDetailState {
  final SubjectDetailEntity detail;
  SubjectDetailLoaded(this.detail);
}

class SubjectDetailError extends SubjectDetailState {
  final String message;
  SubjectDetailError(this.message);
}