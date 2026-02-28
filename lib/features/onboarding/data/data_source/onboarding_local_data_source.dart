import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSource {
  static String _key(String userId) => 'onboarding_complete_$userId';

  Future<bool> isComplete(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key(userId)) ?? false;
  }

  Future<void> markOnboardingComplete(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(userId), true);
  }
}