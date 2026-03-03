import 'package:tempus/features/finance/data/data_sources/subscription_local_data_source.dart';
import 'package:tempus/features/finance/domain/entities/subscription_entity.dart';
import 'package:tempus/features/finance/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionsLocalDataSource dataSource;

  const SubscriptionRepositoryImpl(this.dataSource);

  @override
  Future <List<SubscriptionEntity>> getSubscriptions() => dataSource.getSubscriptions();

  @override
  Future <SubscriptionEntity> addSubscription({
    required String title,
    required double monthlyPrice,
  }) => dataSource.addSubscription(
    title: title,
    monthlyPrice: monthlyPrice,
  );

  @override
  Future <void> deleteSubscription(int id) => dataSource.deleteSubscription(id);
}