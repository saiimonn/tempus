import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/subjects/data/data_source/scores_remote_data_source.dart';
import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';
import 'package:tempus/features/subjects/domain/repositories/scores_repository.dart';

class ScoresRepositoryImpl implements ScoresRepository {
  final ScoresRemoteDataSource dataSource;

  const ScoresRepositoryImpl(this.dataSource);

  factory ScoresRepositoryImpl.create() =>
      ScoresRepositoryImpl(ScoresRemoteDataSource(Supabase.instance.client));

  @override
  Future<List<GradeCategoryEntity>> getCategories(int subjectId) =>
      dataSource.getCategories(subjectId);

  @override
  Future<Map<int, List<ScoresEntity>>> getScores(int subjectId) =>
      dataSource.getScores(subjectId);

  @override
  Future<ScoresEntity> addScore({
    required int categoryId,
    required String title,
    required double scoreValue,
    required double maxScore,
  }) => dataSource.addScore(
    categoryId: categoryId,
    title: title,
    scoreValue: scoreValue,
    maxScore: maxScore,
  );

  @override
  Future<ScoresEntity> updateScore({
    required int scoreId,
    required int categoryId,
    required String title,
    required double scoreValue,
    required double maxScore,
  }) => dataSource.updateScore(
    scoreId: scoreId,
    categoryId: categoryId,
    title: title,
    scoreValue: scoreValue,
    maxScore: maxScore,
  );

  @override
  Future<void> deleteScore({required int categoryId, required int scoreId}) =>
      dataSource.deleteScore(categoryId: categoryId, scoreId: scoreId);
}
