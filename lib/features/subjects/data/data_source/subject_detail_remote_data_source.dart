import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/subjects/data/models/grade_category_model.dart';
import 'package:tempus/features/subjects/data/models/subject_model.dart';

class SubjectDetailRemoteDataSource {
  final SupabaseClient _client;

  const SubjectDetailRemoteDataSource(this._client);

  Future<SubjectModel> getSubject(int subjectId) async {
    final data = await _client
        .from('subject')
        .select('id, name, code, prof, units')
        .eq('id', subjectId)
        .single();

    return SubjectModel.fromMap({
      'id': data['id'],
      'name': data['name'],
      'code': data['code'],
      'instructor': data['prof'] ?? '',
      'units': data['units'],
    });
  }

  Future<List<GradeCategoryModel>> getCategories(int subjectId) async {
    final data = await _client
        .from('grade_category')
        .select('id, name, weight')
        .eq('sub_id', subjectId)
        .eq('is_deleted', false)
        .order('id', ascending: true);

    return (data as List<dynamic>).map((row) {
      return GradeCategoryModel.fromMap({
        'id': row['id'],
        'name': row['name'],
        'weight': (row['weight'] as num).toDouble(),
      });
    }).toList();
  }

  Future<GradeCategoryModel> addCategory({
    required int subjectId,
    required String name,
    required double weight,
  }) async {
    final data = await _client
        .from('grade_category')
        .insert({'sub_id': subjectId, 'name': name, 'weight': weight})
        .select('id, name, weight')
        .single();

    return GradeCategoryModel.fromMap({
      'id': data['id'],
      'name': data['name'],
      'weight': (data['weight'] as num).toDouble(),
    });
  }

  Future<GradeCategoryModel> updateCategory({
    required int categoryId,
    required String name,
    required double weight,
  }) async {
    final data = await _client
        .from('grade_category')
        .update({'name': name, 'weight': weight})
        .eq('id', categoryId)
        .select('id, name, weight')
        .single();

    return GradeCategoryModel.fromMap({
      'id': data['id'],
      'name': data['name'],
      'weight': (data['weight'] as num).toDouble(),
    });
  }

  Future<void> deleteCategory({
    required int subjectId,
    required int categoryId,
  }) async {
    await _client
        .from('grade_category')
        .update({'is_deleted': true})
        .eq('id', categoryId)
        .eq('sub_id', subjectId);
  }
}
