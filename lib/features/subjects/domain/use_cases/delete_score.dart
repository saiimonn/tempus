import 'package:tempus/features/subjects/domain/repositories/scores_repository.dart';

class DeleteScore {
  final ScoresRepository repo;

  const DeleteScore(this.repo);

  Future <void> call({
    required int categoryId,
    required int scoreId,
  }) => repo.deleteScore(
    categoryId: categoryId,
    scoreId: scoreId,
  );
}