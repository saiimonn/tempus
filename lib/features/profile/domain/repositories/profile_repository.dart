import 'package:tempus/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
  
  Future<ProfileEntity> updateProfile({
    required String fullName,
    required String course,
    required String yearLevel,
  });
  
  Future<void> signOut();
}