class SubscriptionEntity {
  final int id;
  final String title;
  final double monthlyPrice;

  const SubscriptionEntity({
    required this.id,
    required this.title,
    required this.monthlyPrice,
  });

  SubscriptionEntity copyWith({
    int? id,
    String? title,
    double? monthlyPrice,
  }) {
    return SubscriptionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
    );
  }
}