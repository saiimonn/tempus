import 'package:tempus/features/auth/domain/entities/auth_user_entity.dart';
import 'package:tempus/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;

  const SignUpUseCase(this._repository);

  Future<AuthUserEntity> call({
    required String fullName,
    required String course,
    required String yearLevel,
    required String studentId,
    required String password,
  }) {
    return _repository.signUpWithSchoolEmail(
      fullName: fullName,
      course: course,
      yearLevel: yearLevel,
      studentId: studentId,
      password: password,
    );
  }
}
