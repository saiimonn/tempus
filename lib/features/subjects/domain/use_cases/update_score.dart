import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/scores_repository.dart';

class UpdateScore {
  final ScoresRepository repo;

  UpdateScore(this.repo);

  Future<ScoresEntity> call({
    required int scoreId,
    required int categoryId,
    required String title,
    required double scoreValue,
    required double maxScore,
  }) => repo.updateScore(
    scoreId: scoreId,
    categoryId: categoryId,
    title: title,
    scoreValue: scoreValue,
    maxScore: maxScore,
  );
}
