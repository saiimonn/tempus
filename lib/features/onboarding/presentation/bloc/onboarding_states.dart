part of 'onboarding_bloc.dart';

class OnboardingState extends Equatable {
  final int currentPage;
  final bool isComplete;

  const OnboardingState({this.currentPage = 0, this.isComplete = false});

  OnboardingState copyWith({int? currentPage, bool? isComplete}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [currentPage, isComplete];
}
