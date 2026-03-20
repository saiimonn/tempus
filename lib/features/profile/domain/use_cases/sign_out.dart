import 'package:tempus/features/profile/domain/repositories/profile_repository.dart';

class SignOut {
  final ProfileRepository repo;
  const SignOut(this.repo);
  Future<void> call() => repo.signOut();
}