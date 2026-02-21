import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/onboarding/data/onboarding_service.dart';

// EVENTS
abstract class OnboardingEvent {}

class PageChanged extends OnboardingEvent {
  final int index;
  PageChanged(this.index);
}

class CompleteOnboarding extends OnboardingEvent {}

// STATE
class OnboardingState {
  final int currentPage;
  final bool isComplete;
  OnboardingState({this.currentPage = 0, this.isComplete = false});
}

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingState()) {
    on<PageChanged>((event, emit) => emit(OnboardingState(currentPage: event.index)));

    on<CompleteOnboarding>((event, emit) async {
      await OnboardingService.markComplete('guest_or_global');
      emit(OnboardingState(currentPage: state.currentPage, isComplete: true));
    });
  }
}