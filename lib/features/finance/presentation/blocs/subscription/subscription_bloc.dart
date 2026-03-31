import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/finance/domain/entities/subscription_entity.dart';
import 'package:tempus/features/finance/domain/use_cases/add_subscription.dart';
import 'package:tempus/features/finance/domain/use_cases/delete_subscription.dart';
import 'package:tempus/features/finance/domain/use_cases/get_subscriptions.dart';
import 'package:tempus/features/finance/domain/use_cases/update_subscription.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetSubscriptions _getSubscriptions;
  final AddSubscription _addSubscription;
  final UpdateSubscription _updateSubscription;
  final DeleteSubscription _deleteSubscription;

  SubscriptionBloc({
    required GetSubscriptions getSubscriptions,
    required AddSubscription addSubscription,
    required UpdateSubscription updateSubscription,
    required DeleteSubscription deleteSubscription,
  })  : _getSubscriptions = getSubscriptions,
        _addSubscription = addSubscription,
        _updateSubscription = updateSubscription,
        _deleteSubscription = deleteSubscription,
        super(const SubscriptionState()) {
    on<SubscriptionLoadRequested>(_onLoad);
    on<SubscriptionAddRequested>(_onAdd);
    on<SubscriptionUpdateRequested>(_onUpdate);
    on<SubscriptionDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(
    SubscriptionLoadRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(state.copyWith(status: SubscriptionStatus.loading));
    try {
      final subscriptions = await _getSubscriptions();
      emit(state.copyWith(
          status: SubscriptionStatus.loaded, subscriptions: subscriptions));
    } catch (_) {
      emit(state.copyWith(
          status: SubscriptionStatus.error,
          errorMessage: 'Failed to load subscriptions'));
    }
  }

  Future<void> _onAdd(
    SubscriptionAddRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      final newSub = await _addSubscription(
          title: event.title, monthlyPrice: event.monthlyPrice);
      emit(state.copyWith(
          subscriptions: [...state.subscriptions, newSub]));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Failed to add subscription'));
    }
  }

  Future<void> _onUpdate(
    SubscriptionUpdateRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    final previous = state.subscriptions;

    final optimistic = state.subscriptions.map((s) {
      if (s.id != event.id) return s;
      return s.copyWith(title: event.title, monthlyPrice: event.monthlyPrice);
    }).toList();
    emit(state.copyWith(subscriptions: optimistic));

    try {
      final updated = await _updateSubscription(
          id: event.id,
          title: event.title,
          monthlyPrice: event.monthlyPrice);
      final confirmed = state.subscriptions
          .map((s) => s.id == updated.id ? updated : s)
          .toList();
      emit(state.copyWith(subscriptions: confirmed));
    } catch (_) {
      emit(state.copyWith(subscriptions: previous));
    }
  }

  Future<void> _onDelete(
    SubscriptionDeleteRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      await _deleteSubscription(event.id);
      emit(state.copyWith(
          subscriptions: state.subscriptions
              .where((s) => s.id != event.id)
              .toList()));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Failed to delete subscription'));
    }
  }
}