import 'package:tempus/features/finance/domain/entities/finance_entity.dart';

abstract class FinanceRepository {
  Future <FinanceEntity> getFinance();
  Future <FinanceEntity> updateBudget(double weeklyAllowance);
}