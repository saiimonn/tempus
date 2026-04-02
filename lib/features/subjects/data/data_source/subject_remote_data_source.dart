import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/subjects/data/models/subject_model.dart';

class SubjectRemoteDataSource {
  final SupabaseClient _client;

  const SubjectRemoteDataSource(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<List<SubjectModel>> getSubjects() async {
    final data = await _client
        .from('subject')
        .select('id, name, code, prof, units')
        .eq('user_id', _userId)
        .eq('is_deleted', false)
        .order('id', ascending: true);

    return (data as List<dynamic>).map((row) {
      return SubjectModel.fromMap({
        'id': row['id'],
        'name': row['name'],
        'code': row['code'],
        'instructor': row['prof'] ?? '',
        'units': row['units'],
      });
    }).toList();
  }

  Future<SubjectModel> addSubject(SubjectModel subject) async {
    final data = await _client
        .from('subject')
        .insert({
          'user_id': _userId,
          'name': subject.name,
          'code': subject.code,
          'prof': subject.instructor.isNotEmpty ? subject.instructor : null,
          'units': subject.units,
        })
        .select('id, name, code, prof, units')
        .single();

    return SubjectModel.fromMap({
      'id': data['id'],
      'name': data['name'],
      'code': data['code'],
      'instructor': data['prof'] ?? '',
      'units': data['units'],
    });
  }

  Future<SubjectModel> updateSubject(SubjectModel subject) async {
    final data = await _client
        .from('subject')
        .update({
          'name': subject.name,
          'code': subject.code,
          'prof': subject.instructor.isNotEmpty ? subject.instructor : null,
          'units': subject.units,
        })
        .eq('id', subject.id)
        .eq('user_id', _userId)
        .select('id, name, code, prof, units')
        .single();

    return SubjectModel.fromMap({
      'id': data['id'],
      'name': data['name'],
      'code': data['code'],
      'instructor': data['prof'] ?? '',
      'units': data['units'],
    });
  }
}
