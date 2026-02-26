import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  final SupabaseClient _client;
  static const String _schoolDomain = '@usc.edu.ph';

  const AuthRemoteDataSource(this._client);

  Future<User> signIn({
    required String studentId,
    required String password,
  }) async {
    final fullEmail = '$studentId$_schoolDomain';

    final AuthResponse response = await _client.auth.signInWithPassword(
      email: fullEmail,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Unable to sign in. Please try again.');
    }

    return user;
  }

  Future<User> signUp({
    required String fullName,
    required String course,
    required String yearLevel,
    required String studentId,
    required String password,
  }) async {
    final fullEmail = '$studentId$_schoolDomain';

    final AuthResponse response = await _client.auth.signUp(
      email: fullEmail,
      password: password,
      data: {'full_name': fullName, 'course': course, 'year_level': yearLevel},
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Unable to create account. Please try again.');
    }

    return user;
  }
}
