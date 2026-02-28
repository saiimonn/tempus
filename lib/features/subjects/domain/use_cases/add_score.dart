import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/scores_repository.dart';

class AddScore {
  final ScoresRepository repo;

  const AddScore(this.repo);

  Future <ScoresEntity> call({
    required int categoryId,
    required String title,
    required double scoreValue,
    required double maxScore,
  }) => repo.addScore(
    categoryId: categoryId,
    title: title,
    scoreValue: scoreValue,
    maxScore: maxScore,
  );
}