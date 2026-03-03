import 'package:tempus/features/finance/data/models/transaction_model.dart';

class TransactionsLocalDataSource {
  Future<List<TransactionModel>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 400));
    final now = DateTime.now();

    return [
      TransactionModel.fromMap({
        'id': 1,
        'title': 'Jollibee',
        'amount': 250.0,
        'created_at': now.subtract(const Duration(days: 0)).toIso8601String(),
        'is_income': false,
      }),
      TransactionModel.fromMap({
        'id': 2,
        'title': 'Allowance',
        'amount': 500.0,
        'created_at': now.subtract(const Duration(days: 1)).toIso8601String(),
        'is_income': true,
      }),
      TransactionModel.fromMap({
        'id': 3,
        'title': 'Grab',
        'amount': 180.0,
        'created_at': now.subtract(const Duration(days: 2)).toIso8601String(),
        'is_income': false,
      }),
      TransactionModel.fromMap({
        'id': 4,
        'title': 'Printing',
        'amount': 45.0,
        'created_at': now.subtract(const Duration(days: 3)).toIso8601String(),
        'is_income': false,
      }),
      TransactionModel.fromMap({
        'id': 5,
        'title': 'Merienda',
        'amount': 65.0,
        'created_at': now.subtract(const Duration(days: 7)).toIso8601String(),
        'is_income': false,
      }),
      TransactionModel.fromMap({
        'id': 6,
        'title': 'Weekly Allowance',
        'amount': 1500.0,
        'created_at': now.subtract(const Duration(days: 7)).toIso8601String(),
        'is_income': true,
      }),
      TransactionModel.fromMap({
        'id': 7,
        'title': 'Lunch',
        'amount': 120.0,
        'created_at': now.subtract(const Duration(days: 14)).toIso8601String(),
        'is_income': false,
      }),
    ];
  }

  Future <TransactionModel> addTransaction({
    required String title,
    required double amount,
    required bool isIncome,
  }) async {
    return TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      amount: amount,
      createdAt: DateTime.now(),
      isIncome: isIncome,
    );
  }

  Future <void> deleteTransaction(int id) async {}
}