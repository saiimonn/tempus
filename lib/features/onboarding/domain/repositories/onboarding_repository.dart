abstract class OnboardingRepository {
  Future<bool> isOnboardingComplete(String userId);
  Future<void> markOnboardingComplete(String userId);
}