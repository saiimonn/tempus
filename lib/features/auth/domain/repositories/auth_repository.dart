import 'package:tempus/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<AuthUserEntity> signInWithSchoolEmail({
    required String studentId,
    required String password,
  });

  Future<AuthUserEntity> signUpWithSchoolEmail({
    required String fullName,
    required String course,
    required String yearLevel,
    required String studentId,
    required String password,
  });
}
