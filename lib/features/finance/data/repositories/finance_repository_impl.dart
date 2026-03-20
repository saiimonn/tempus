import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/finance/data/data_sources/finance_remote_data_source.dart';
import 'package:tempus/features/finance/domain/entities/finance_entity.dart';
import 'package:tempus/features/finance/domain/repositories/finance_repository.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  final FinanceRemoteDataSource dataSource;

  const FinanceRepositoryImpl(this.dataSource);

  factory FinanceRepositoryImpl.create() =>
      FinanceRepositoryImpl(FinanceRemoteDataSource(Supabase.instance.client));

  @override
  Future<FinanceEntity> getFinance() => dataSource.getFinance();

  @override
  Future<FinanceEntity> updateBudget(double weeklyAllowance) =>
      dataSource.updateBudget(weeklyAllowance);
}
