import 'package:tempus/features/subjects/data/models/grade_category_model.dart';
import 'package:tempus/features/subjects/data/models/subject_model.dart';

class SubjectDetailLocalDataSource {
  Future<SubjectModel> getSubject(dynamic subjectId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // FAKE DATA
    return SubjectModel.fromMap({
      'id': subjectId,
      'name': 'Data Structures and Algorithms',
      'code': 'CS 2101',
      'instructor': 'Dr. Cruz',
      'units': 3,
      'grades': {'prelim': '--', 'midterm': '--', 'final': '--'},
    });
  }

  // FAKE DATA
  Future <List<GradeCategoryModel>> getCategories(dynamic subjectId) async {
    return [
      GradeCategoryModel.fromMap({'id': 1, 'name': 'Quizzes', 'weight': 20.0}),
      GradeCategoryModel.fromMap({'id': 2, 'name': 'Midterm Exam', 'weight': 30.0}),
      GradeCategoryModel.fromMap({'id': 3, 'name': 'Final Project', 'weight': 50.0}),
    ];
  }

  // PLACEHOLDER GRADE
  Future<double> getEstimatedGrade(dynamic subjectId) async => 1.8;

  Future <GradeCategoryModel> addCategory({
    required dynamic subjectId,
    required String name,
    required double weight,
  }) async {
    return GradeCategoryModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      weight: weight,
    );
  }

  Future <void> deleteCategory({
    required dynamic subjectId,
    required int categoryId,
  }) async {
    //NO IMPLEMENTATION YET BR
  }
}