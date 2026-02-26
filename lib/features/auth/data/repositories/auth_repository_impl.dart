import 'package:tempus/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tempus/features/auth/data/models/auth_user_model.dart';
import 'package:tempus/features/auth/domain/entities/auth_user_entity.dart';
import 'package:tempus/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<AuthUserEntity> signInWithSchoolEmail({
    required String studentId,
    required String password,
  }) async {
    final user = await _remoteDataSource.signIn(
      studentId: studentId,
      password: password,
    );

    return AuthUserModel.fromSupabase(user).toEntity();
  }

  @override
  Future<AuthUserEntity> signUpWithSchoolEmail({
    required String fullName,
    required String course,
    required String yearLevel,
    required String studentId,
    required String password,
  }) async {
    final user = await _remoteDataSource.signUp(
      fullName: fullName,
      course: course,
      yearLevel: yearLevel,
      studentId: studentId,
      password: password,
    );

    return AuthUserModel.fromSupabase(user).toEntity();
  }
}
