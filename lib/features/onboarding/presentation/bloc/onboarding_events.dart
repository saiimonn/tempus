part of 'onboarding_bloc.dart';

sealed class OnboardingEvent {}

class OnboardingPageChanged extends OnboardingEvent {
  final int index;
  OnboardingPageChanged(this.index);
}

class OnboardingComplete extends OnboardingEvent {}