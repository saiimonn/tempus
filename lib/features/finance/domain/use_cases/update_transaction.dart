import 'package:tempus/features/finance/domain/entities/transaction_entity.dart';
import 'package:tempus/features/finance/domain/repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository repo;

  UpdateTransaction(this.repo);

  Future<TransactionEntity> call({
    required int id,
    required String title,
    required double amount,
    required bool isIncome,
  }) => repo.updateTransaction(
    id: id,
    title: title,
    amount: amount,
    isIncome: isIncome,
  );
}
