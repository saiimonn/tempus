import 'package:tempus/features/finance/domain/entities/subscription_entity.dart';
import 'package:tempus/features/finance/domain/repositories/subscription_repository.dart';

class AddSubscription {
  final SubscriptionRepository repo;

  AddSubscription(this.repo);

  Future <SubscriptionEntity> call({
    required String title,
    required double monthlyPrice,
  }) => repo.addSubscription(
    title: title,
    monthlyPrice: monthlyPrice,
  );
}