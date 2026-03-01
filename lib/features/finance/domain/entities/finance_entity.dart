class FinanceEntity {
  final int id;
  final double weeklyAllowance;
  final double totalAmount;

  const FinanceEntity({
    required this.id,
    required this.weeklyAllowance,
    required this.totalAmount,
  });

  double get spentThisWeek => weeklyAllowance - totalAmount;

  double get budgetProgress =>
    weeklyAllowance > 0 ? (spentThisWeek / weeklyAllowance).clamp(0.0, 1.0) : 0.0;

  FinanceEntity copyWith({
    int? id,
    double? weeklyAllowance,
    double? totalAmount,
  }) {
    return FinanceEntity(
      id: id ?? this.id,
      weeklyAllowance: weeklyAllowance ?? this.weeklyAllowance,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}