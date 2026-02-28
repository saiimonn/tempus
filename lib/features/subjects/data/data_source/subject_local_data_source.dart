import 'package:tempus/features/subjects/data/models/subject_model.dart';

class SubjectLocalDataSource {
  Future <List<SubjectModel>> getSubjects() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // MOCK DATA CUZZIN
    return [
      SubjectModel.fromMap({
        'id': '1',
        'name': 'Mathematics',
        'code': 'MATH101',
        'instructor': 'Dr. Smith',
        'units': 3,
        'grades': {'prelim': '1.25', 'midterm': '1.50', 'final': '--'},
      }),
      SubjectModel.fromMap({
        'id': '2',
        'name': 'Physics',
        'code': 'PHYS202',
        'instructor': 'Prof. Gable',
        'units': 3,
        'grades': {'prelim': '1.75', 'midterm': '1.25', 'final': '--'},
      }),
    ];
  }

  Future<SubjectModel> addSubject(SubjectModel sub) async {

    // NO DB IMPLEMENTATION
    return SubjectModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: sub.name,
      code: sub.code,
      instructor: sub.instructor,
      units: sub.units,
      grades: sub.grades,
    );
  }
}