import 'package:tempus/features/onboarding/domain/entities/onboarding_item_entity.dart';

class OnboardingItemModel extends OnboardingItemEntity {
  const OnboardingItemModel({
    required super.title,
    required super.desc,
  });
}

final List<OnboardingItemModel> onboardingItems = [
  const OnboardingItemModel(
    title: "Welcome to Tempus",
    desc: '',
  ),

  const OnboardingItemModel(
    title: 'Task Tracking',
    desc:
        'Never miss a deadline again. Organize your assignments by subject and track your completion progress in real-time',
  ),
  const OnboardingItemModel(
    title: 'Schedule Builder',
    desc:
        'View your daily classes at a glance and build your class schedule with ease. Know exactly when and where your next lecture is.',
  ),
  const OnboardingItemModel(
    title: 'Budget Tracking',
    desc:
        'Manage your weekly allowance efficiently. Log your daily expenses and see how much you have left for the rest of the week.',
  ),
  const OnboardingItemModel(
    title: 'Grade Calculator',
    desc:
        'Stay on top of your academic performance. Track your scores across different categories to see your standing in every subject.',
  ),
];