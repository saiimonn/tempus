import 'package:tempus/features/finance/domain/entities/transaction_entity.dart';
import 'package:tempus/features/finance/domain/repositories/transaction_repository.dart';
import 'package:tempus/features/finance/data/data_sources/transaction_local_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionsLocalDataSource dataSource;

  const TransactionRepositoryImpl(this.dataSource);

  @override
  Future <List<TransactionEntity>> getTransactions() => dataSource.getTransactions();

  @override
  Future <TransactionEntity> addTransaction({
    required String title,
    required double amount,
    required bool isIncome,
  }) => dataSource.addTransaction(
    title: title,
    amount: amount,
    isIncome: isIncome,
  );

  @override
  Future <void> deleteTransaction(int id) => dataSource.deleteTransaction(id);
}