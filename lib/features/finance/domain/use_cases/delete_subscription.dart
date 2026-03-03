import 'package:tempus/features/finance/domain/repositories/subscription_repository.dart';

class DeleteSubscription {
  final SubscriptionRepository repo;

  DeleteSubscription(this.repo);

  Future <void> call(int id) => repo.deleteSubscription(id);
}