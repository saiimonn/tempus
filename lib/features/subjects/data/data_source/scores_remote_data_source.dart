import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/subjects/data/models/grade_category_model.dart';
import 'package:tempus/features/subjects/data/models/score_model.dart';

class ScoresRemoteDataSource {
  final SupabaseClient _client;

  const ScoresRemoteDataSource(this._client);

  Future<List<GradeCategoryModel>> getCategories(int subjectId) async {
    final data = await _client
        .from('grade_category')
        .select('id, name, weight')
        .eq('sub_id', subjectId)
        .eq('is_deleted', false)
        .order('id', ascending: true);

    return (data as List<dynamic>)
        .map(
          (row) => GradeCategoryModel.fromMap({
            'id': row['id'],
            'name': row['name'],
            'weight': (row['weight'] as num).toDouble(),
          }),
        )
        .toList();
  }

  /// Returns all non-deleted scores for [subjectId], grouped by category id.
  Future<Map<int, List<ScoreModel>>> getScores(int subjectId) async {
    final categories = await getCategories(subjectId);

    // Seed the map with empty lists so every category is always present,
    // even when it has no scores yet.
    final Map<int, List<ScoreModel>> grouped = {
      for (final c in categories) c.id: [],
    };

    // Guard: .inFilter() with an empty list is undefined behaviour in
    // supabase-dart and can throw. Skip the query if there are no categories.
    if (categories.isEmpty) return grouped;

    final categoryIds = categories.map((c) => c.id).toList();

    final data = await _client
        .from('scores')
        .select('id, category_id, title, score_value, max_score')
        .inFilter('category_id', categoryIds)
        .eq('is_deleted', false)
        .order('id', ascending: true);

    for (final row in (data as List<dynamic>)) {
      final categoryId = row['category_id'] as int;
      grouped[categoryId]?.add(
        ScoreModel.fromMap({
          'id': row['id'],
          'title': row['title'],
          'score_value': (row['score_value'] as num).toDouble(),
          'max_score': (row['max_score'] as num).toDouble(),
        }),
      );
    }

    return grouped;
  }

  Future<ScoreModel> addScore({
    required int categoryId,
    required String title,
    required double scoreValue,
    required double maxScore,
  }) async {
    final data = await _client
        .from('scores')
        .insert({
          'category_id': categoryId,
          'title': title,
          'score_value': scoreValue,
          'max_score': maxScore,
        })
        .select('id, title, score_value, max_score')
        .single();

    return ScoreModel.fromMap({
      'id': data['id'],
      'title': data['title'],
      'score_value': (data['score_value'] as num).toDouble(),
      'max_score': (data['max_score'] as num).toDouble(),
    });
  }

  Future<ScoreModel> updateScore({
    required int scoreId,
    required int categoryId,
    required String title,
    required double scoreValue,
    required double maxScore,
  }) async {
    final data = await _client
        .from('scores')
        .update({
          'title': title,
          'score_value': scoreValue,
          'max_score': maxScore,
        })
        .eq('id', scoreId)
        .eq('category_id', categoryId)
        .select('id, title, score_value, max_score')
        .single();

    return ScoreModel.fromMap({
      'id': data['id'],
      'title': data['title'],
      'score_value': (data['score_value'] as num).toDouble(),
      'max_score': (data['max_score'] as num).toDouble(),
    });
  }

  Future<void> deleteScore({
    required int categoryId,
    required int scoreId,
  }) async {
    await _client
        .from('scores')
        .update({'is_deleted': true})
        .eq('id', scoreId)
        .eq('category_id', categoryId);
  }
}
