import 'package:tempus/features/finance/data/models/subscription_model.dart';

class SubscriptionsLocalDataSource {
  Future <List<SubscriptionModel>> getSubscriptions() async {
    Future.delayed(const Duration(milliseconds: 400));

    return [
      SubscriptionModel.fromMap({
        'id': 1,
        'title': 'Netflix',
        'monthly_price': 100.75,
      }),
      SubscriptionModel.fromMap({
        'id': 2,
        'title': 'Spotify',
        'monthly_price': 79.0,
      }),
      SubscriptionModel.fromMap({
        'id': 3,
        'title': 'YouTube Premium',
        'monthly_price': 189.0,
      }),
    ];
  }

  Future <SubscriptionModel> addSubscription({
    required String title,
    required double monthlyPrice,
  }) async {
    return SubscriptionModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      monthlyPrice: monthlyPrice,
    );
  }

  Future <void> deleteSubscription(int id) async {}
}