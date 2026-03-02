part of 'subscription_bloc.dart';

enum SubscriptionStatus { initial, loading, loaded, error }

class SubscriptionState {
  final SubscriptionStatus status;
  final List<SubscriptionEntity> subscriptions;
  final String? errorMessage;

  const SubscriptionState({
    this.status = SubscriptionStatus.initial,
    this.subscriptions = const [],
    this.errorMessage,
  });

  double get totalMonthly =>
      subscriptions.fold(0, (sum, s) => sum + s.monthlyPrice);

  SubscriptionState copyWith({
    SubscriptionStatus? status,
    List<SubscriptionEntity>? subscriptions,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      subscriptions: subscriptions ?? this.subscriptions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
