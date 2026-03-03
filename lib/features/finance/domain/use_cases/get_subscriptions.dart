import 'package:tempus/features/finance/domain/entities/subscription_entity.dart';
import 'package:tempus/features/finance/domain/repositories/subscription_repository.dart';

class GetSubscriptions {
  final SubscriptionRepository repo;

  GetSubscriptions(this.repo);

  Future <List<SubscriptionEntity>> call() => repo.getSubscriptions();
}