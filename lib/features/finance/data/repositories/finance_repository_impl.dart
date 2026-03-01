import 'package:tempus/features/finance/data/data_sources/finance_local_data_source.dart';
import 'package:tempus/features/finance/domain/entities/finance_entity.dart';
import 'package:tempus/features/finance/domain/repositories/finance_repository.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final FinanceLocalDataSource dataSource;

  const FinanceRepositoryImpl(this.dataSource);

  @override
  Future <FinanceEntity> getFinance() => dataSource.getFinance();

  @override
  Future <FinanceEntity> updateBudget(double weeklyAllowance) =>
    dataSource.updateBudget(weeklyAllowance);
}