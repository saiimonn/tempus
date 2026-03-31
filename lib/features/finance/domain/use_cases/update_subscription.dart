import 'package:tempus/features/finance/domain/entities/subscription_entity.dart';
import 'package:tempus/features/finance/domain/repositories/subscription_repository.dart';

class UpdateSubscription {
  final SubscriptionRepository repo;

  UpdateSubscription(this.repo);

  Future<SubscriptionEntity> call({
    required int id,
    required String title,
    required double monthlyPrice,
  }) =>
      repo.updateSubscription(id: id, title: title, monthlyPrice: monthlyPrice);
}
