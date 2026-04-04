import 'package:tempus/features/profile/domain/entities/profile_entity.dart';
import 'package:tempus/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repo;

  const UpdateProfile(this.repo);

  Future<ProfileEntity> call({
    required String fullName,
    required String course,
    required String yearLevel,
  }) => repo.updateProfile(
    fullName: fullName,
    course: course,
    yearLevel: yearLevel,
  );
}
