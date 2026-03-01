import 'package:tempus/features/finance/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future <List<TransactionEntity>> getTransactions();
  Future <TransactionEntity> addTransaction({
    required String title,
    required double amount,
    required bool isIncome,
  });
  Future <void> deleteTransaction(int id);
}