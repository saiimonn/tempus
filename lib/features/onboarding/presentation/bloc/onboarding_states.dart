part of 'onboarding_bloc.dart';

class OnboardingState {
  final int currentPage;
  final bool isComplete;

  const OnboardingState({
    this.currentPage = 0,
    this.isComplete = false,
  });

  OnboardingState copyWith({int? currentPage, bool? isComplete}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}