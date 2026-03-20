import 'package:tempus/features/profile/domain/entities/profile_entity.dart';
import 'package:tempus/features/profile/domain/repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repo;
  const GetProfile(this.repo);
  Future<ProfileEntity> call() => repo.getProfile();
}
