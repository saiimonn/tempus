import 'package:tempus/features/finance/domain/entities/finance_entity.dart';

class FinanceModel extends FinanceEntity {
  const FinanceModel({
    required super.id,
    required super.weeklyAllowance,
    required super.totalAmount,
  });

  factory FinanceModel.fromMap(Map<String, dynamic> map) {
    return FinanceModel(
      id: map['id'] as int,
      weeklyAllowance: (map['weekly_allowance'] as num).toDouble(),
      totalAmount: (map['total_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weekly_allowance': weeklyAllowance,
      'total_amount': totalAmount,
    };
  }
}