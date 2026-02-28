part of 'subject_bloc.dart';

sealed class SubjectEvent {}

class SubjectLoadRequested extends SubjectEvent {}

class SubjectAddRequested extends SubjectEvent {
  final SubjectEntity subject;
  SubjectAddRequested(this.subject);
}