import 'package:tempus/features/finance/domain/entities/finance_entity.dart';
import 'package:tempus/features/finance/domain/repositories/finance_repository.dart';

class UpdateFinance {
  final FinanceRepository repo;

  UpdateFinance(this.repo);

  Future <FinanceEntity> call(double weeklyAllowance) => repo.updateBudget(weeklyAllowance);
}