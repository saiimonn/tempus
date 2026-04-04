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

  Future<ProfileModel> updateProfile({
    required String fullName,
    required String course,
    required String yearLevel,
  }) async {
    final res = await _client.auth.updateUser(
      UserAttributes(
        data: {
          'full_name': fullName,
          'course': course,
          'year_level': yearLevel,
        },
      ),
    );

    final user = res.user;
    if (user == null) throw Exception('Failed to update profile');

    final metadata = user.userMetadata ?? {};

    return ProfileModel.fromMap({
      'id': user.id,
      'full_name': metadata['full_name'] ?? fullName,
      'email': user.email ?? '',
      'course': metadata['course'] ?? course,
      'year_level': metadata['year_level'] ?? yearLevel,
    });
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
