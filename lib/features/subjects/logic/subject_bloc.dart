import 'package:flutter_bloc/flutter_bloc.dart';

// EVENTS
abstract class SubjectEvent {}

class LoadSubjects extends SubjectEvent {}

class AddSubject extends SubjectEvent {
  final Map<String, dynamic> subject;
  AddSubject(this.subject);
}

//STATES
abstract class SubjectState {}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final List<Map<String, dynamic>> subjects;
  SubjectLoaded(this.subjects);
}

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubjectBloc() : super(SubjectInitial()) {
    on<LoadSubjects>((event, emit) async {
      emit(SubjectLoading());

      await Future.delayed(const Duration(milliseconds: 500));
      emit(
        SubjectLoaded([
          {
            'id': '1',
            'name': 'Mathematics',
            'code': 'MATH101',
            'instructor': 'Dr. Smith',
            'grades': {'prelim': '1.25', 'midterm': '1.50', 'final': '--'},
            'units': 3,
          },
          {
            'id': '2',
            'name': 'Physics',
            'code': 'PHYS202',
            'instructor': 'Prof. Gable',
            'grades': {'prelim': '1.75', 'midterm': '1.25', 'final': '--'},
            'units': 3,
          },
        ]),
      );
    });

    on<AddSubject>((event, emit) async {
      if (state is SubjectLoaded) {
        final currentSubjects = (state as SubjectLoaded).subjects;
        emit(SubjectLoaded(List.from(currentSubjects)..add(event.subject)));
      }
    });
  }
}
