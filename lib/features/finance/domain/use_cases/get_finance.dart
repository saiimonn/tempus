import 'package:tempus/features/finance/domain/entities/finance_entity.dart';
import 'package:tempus/features/finance/domain/repositories/finance_repository.dart';

class GetFinance {
  final FinanceRepository repo;
  
  const GetFinance(this.repo);

  Future <FinanceEntity> call() => repo.getFinance();
}