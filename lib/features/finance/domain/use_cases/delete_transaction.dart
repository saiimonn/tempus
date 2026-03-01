import 'package:tempus/features/finance/domain/repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repo;

  DeleteTransaction(this.repo);

  Future <void> call(int id) => repo.deleteTransaction(id);
}