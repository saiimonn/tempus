part of 'subject_detail_bloc.dart';

sealed class SubjectDetailState extends Equatable {
  const SubjectDetailState();

  @override
  List<Object?> get props => [];
}

class SubjectDetailInitial extends SubjectDetailState {}

class SubjectDetailLoading extends SubjectDetailState {}

class SubjectDetailLoaded extends SubjectDetailState {
  final SubjectDetailEntity detail;
  final bool savedSuccessfully;
  final bool saveError;

  const SubjectDetailLoaded(
    this.detail, {
    this.savedSuccessfully = false,
    this.saveError = false,
  });

  @override
  List<Object?> get props => [detail, savedSuccessfully, saveError];
}

class SubjectDetailError extends SubjectDetailState {
  final String message;
  
  const SubjectDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
