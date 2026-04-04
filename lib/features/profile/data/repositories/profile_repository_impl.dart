import 'package:tempus/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:tempus/features/profile/domain/entities/profile_entity.dart';
import 'package:tempus/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _dataSource;

  const ProfileRepositoryImpl(this._dataSource);

  @override
  Future<ProfileEntity> getProfile() => _dataSource.getProfile();

  @override
  Future<ProfileEntity> updateProfile({
    required String fullName,
    required String course,
    required String yearLevel,
  }) => _dataSource.updateProfile(
    fullName: fullName,
    course: course,
    yearLevel: yearLevel,
  );

  @override
  Future<void> signOut() => _dataSource.signOut();
}
