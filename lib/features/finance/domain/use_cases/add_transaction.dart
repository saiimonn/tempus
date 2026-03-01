import 'package:tempus/features/finance/domain/entities/transaction_entity.dart';
import 'package:tempus/features/finance/domain/repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repo;

  AddTransaction(this.repo);

  Future <TransactionEntity> call({
    required String title,
    required double amount,
    required bool isIncome,
  }) => repo.addTransaction(
    title: title,
    amount: amount,
    isIncome: isIncome,
  );
}