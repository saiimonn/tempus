import 'package:tempus/features/finance/domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.id,
    required super.title,
    required super.monthlyPrice,
  });

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] as int,
      title: map['title'] as String,
      monthlyPrice: (map['monthly_price'] as num).toDouble(), 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'monthly_price': monthlyPrice,
    };
  }
}