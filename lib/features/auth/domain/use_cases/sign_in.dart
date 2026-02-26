import 'package:tempus/features/auth/domain/entities/auth_user_entity.dart';
import 'package:tempus/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  Future<AuthUserEntity> call({
    required String studentId,
    required String password,
  }) {
    return _repository.signInWithSchoolEmail(
      studentId: studentId,
      password: password,
    );
  }
}
