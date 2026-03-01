import 'package:tempus/features/finance/domain/entities/transaction_entity.dart';
import 'package:tempus/features/finance/domain/repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repo;

  GetTransactions(this.repo);

  Future <List<TransactionEntity>> call() => repo.getTransactions();
}