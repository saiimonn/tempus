import 'package:tempus/features/onboarding/data/data_source/onboarding_local_data_source.dart';
import 'package:tempus/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _dataSource;

  const OnboardingRepositoryImpl(this._dataSource);

  @override
  Future<bool> isOnboardingComplete(String userId) {
    return _dataSource.isComplete(userId);
  }

  @override
  Future<void> markOnboardingComplete(String userId) {
    return _dataSource.markOnboardingComplete(userId);
  }
}