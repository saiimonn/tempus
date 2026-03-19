import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/profile/data/models/profile_model.dart';

class ProfileRemoteDataSource {
  final SupabaseClient _client;

  const ProfileRemoteDataSource(this._client);

  Future<ProfileModel> getProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    final metadata = user.userMetadata ?? {};
    return ProfileModel.fromMap({
      'id': user.id,
      'full_name': metadata['full_name'] ?? 'User',
      'email': user.email ?? '',
      'course': metadata['course'] ?? '',
      'year_level': metadata['year_level'] ?? '',
    });
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
