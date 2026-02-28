import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/onboarding/domain/use_cases/mark_onboarding_complete.dart';

part 'onboarding_events.dart';
part 'onboarding_states.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final MarkOnboardingComplete _markOnboardingComplete;

  static const String _userId = 'guest_or_global';

  OnboardingBloc({required MarkOnboardingComplete markOnboardingComplete})
    : _markOnboardingComplete = markOnboardingComplete,
      super(const OnboardingState()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingComplete>(_onComplete);
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit
  ) {
    emit(state.copyWith(currentPage: event.index));
  }

  Future<void> _onComplete(
    OnboardingComplete event,
    Emitter<OnboardingState> emit
  ) async {
    await _markOnboardingComplete(_userId);
    emit(state.copyWith(isComplete: true));
  }
}