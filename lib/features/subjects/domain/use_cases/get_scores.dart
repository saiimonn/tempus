import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/scores_repository.dart';

class GetScores {
  final ScoresRepository repository;

  const GetScores(this.repository);

  Future<({List<GradeCategoryEntity> categories, Map<int, List<ScoresEntity>> scores})>
      call(int subjectId) async {
    final categories = await repository.getCategories(subjectId);
    final scores = await repository.getScores(subjectId);
    return (categories: categories, scores: scores);
  }
}