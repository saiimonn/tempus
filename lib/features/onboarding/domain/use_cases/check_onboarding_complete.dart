import 'package:tempus/features/onboarding/domain/repositories/onboarding_repository.dart';

class CheckOnboardingComplete {
  final OnboardingRepository repo;

  const CheckOnboardingComplete(this.repo);

  Future<bool> call(String userId) {
    return repo.isOnboardingComplete(userId);
  }
}