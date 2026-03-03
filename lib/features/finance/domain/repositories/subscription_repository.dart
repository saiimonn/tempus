import 'package:tempus/features/finance/domain/entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Future <List<SubscriptionEntity>> getSubscriptions();
  Future <SubscriptionEntity> addSubscription({
    required String title,
    required double monthlyPrice,
  });
  Future <void> deleteSubscription(int id);
}