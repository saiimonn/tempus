class OnboardingItem {
  final String title;
  final String desc;

  OnboardingItem({required this.title, required this.desc});
}

final List<OnboardingItem> onboardingPages = [
  OnboardingItem(
    title: "Welcome to Tempus",
    desc: "",
  ),
  
  OnboardingItem(
    title: "Task Tracking",
    desc: "Never miss a deadline again. Organize your assignments by subject and track your completion progress in real-time",
  ),
  
  OnboardingItem(
    title: "Schedule Builder",
    desc: "View your daily classes at a glance and build your class schedule with ease. Know exactly when and where your next lecture is.",
  ),
  
  OnboardingItem(
    title: "Budget Tracking",
    desc: "Manage your weekly allowance efficiently. Log your daily expenses and see how much you have left for the rest of the week.",
  ),
  
  OnboardingItem(
    title: "Grade Calculator",
    desc: "Stay on top of your academic performance. Track your scores across different categories to see your standing in every subject.",
  ),
];
