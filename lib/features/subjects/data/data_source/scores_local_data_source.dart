import 'package:tempus/features/subjects/data/models/grade_category_model.dart';
import 'package:tempus/features/subjects/data/models/score_model.dart';

class ScoresLocalDataSource {
  Future<List<GradeCategoryModel>> getCategories(int subjectId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // FAKE DATA
    return [
      GradeCategoryModel.fromMap({'id': 1, 'name': 'Quizzes', 'weight': 20.0}),
      GradeCategoryModel.fromMap({'id': 2, 'name': 'Midterm Exam', 'weight': 30.0}),
      GradeCategoryModel.fromMap({'id': 3, 'name': 'Final Project', 'weight': 50.0}),
    ];
  }

// FAKE DATA
  Future<Map<int, List<ScoreModel>>> getScores(int subjectId) async {
    return {
      1: [
        ScoreModel.fromMap({
          'id': 101,
          'title': 'Algebra Quiz',
          'score_value': 18.0,
          'max_score': 20.0,
        }),
        ScoreModel.fromMap({
          'id': 102,
          'title': 'Trigonometry Quiz',
          'score_value': 14.0,
          'max_score': 20.0,
        }),
      ],
      2: [
        ScoreModel.fromMap({
          'id': 201,
          'title': 'Midterm Examination',
          'score_value': 85.0,
          'max_score': 100.0,
        }),
      ],
      3: [],
    };
  }

  Future <ScoreModel> addScore({
    required int categoryId,
    required String title,
    required double scoreValue,
    required maxScore,
  }) async {
    return ScoreModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      scoreValue: scoreValue,
      maxScore: maxScore,
    );
  }

  Future<void> deleteScore({
    required int categoryId,
    required int scoreId,
  }) async {
    // NO DB IMPLEMENTATION YET
  }
}