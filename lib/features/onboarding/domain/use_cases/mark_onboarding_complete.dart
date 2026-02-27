import 'package:tempus/features/onboarding/domain/repositories/onboarding_repository.dart';

class MarkOnboardingComplete {
  final OnboardingRepository repo;

  const MarkOnboardingComplete(this.repo);

  Future<void> call(String userId) {
    return repo.markOnboardingComplete(userId);
  }
}