part of 'subscription_bloc.dart';

sealed class SubscriptionEvent {}

class SubscriptionLoadRequested extends SubscriptionEvent {}

class SubscriptionAddRequested extends SubscriptionEvent {
  final String title;
  final double monthlyPrice;
  SubscriptionAddRequested({required this.title, required this.monthlyPrice});
}

class SubscriptionDeleteRequested extends SubscriptionEvent {
  final int id;
  SubscriptionDeleteRequested(this.id);
}
