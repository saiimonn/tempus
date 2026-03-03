class TransactionEntity {
  final int id;
  final String title;
  final double amount;
  final DateTime createdAt;
  final bool isIncome;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.createdAt,
    this.isIncome = false,
  });

  TransactionEntity copyWith({
    int? id,
    String? title,
    double? amount,
    DateTime? createdAt,
    bool? isIncome,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      isIncome: isIncome ?? this.isIncome,
    );
  }
}