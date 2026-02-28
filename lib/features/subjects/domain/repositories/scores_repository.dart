import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';

abstract class ScoresRepository {
  Future <List<GradeCategoryEntity>> getCategories(int subjectId);
  Future <Map<int, List<ScoresEntity>>> getScores(int subjectId);
  Future <ScoresEntity> addScore({
    required int categoryId,
    required String title,
    required double scoreValue,
    required double maxScore,
  });

  Future <void> deleteScore({
    required int categoryId,
    required int scoreId,
  });
}