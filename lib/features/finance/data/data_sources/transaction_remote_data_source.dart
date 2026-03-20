import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/finance/data/models/transaction_model.dart';

class TransactionRemoteDataSource {
  final SupabaseClient _client;

  const TransactionRemoteDataSource(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<({int id, double totalAmount})> _getFinancesRow() async {
    final row = await _client
        .from('finances')
        .select('id, total_amount')
        .eq('user_id', _userId)
        .single();

    return (
      id: row['id'] as int,
      totalAmount: (row['total_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Future<List<TransactionModel>> getTransactions() async {
    final finances = await _getFinancesRow();

    final data = await _client
        .from('transactions')
        .select('id, title, amount, created_at')
        .eq('finances_id', finances.id)
        .eq('is_deleted', false)
        .order('created_at', ascending: false);

    return (data as List<dynamic>).map((row) {
      final signedAmount = (row['amount'] as num).toDouble();
      return TransactionModel.fromMap({
        'id': row['id'],
        'title': row['title'],
        'amount': signedAmount.abs(),
        'created_at': row['created_at'],
        'is_income': signedAmount >= 0,
      });
    }).toList();
  }

  Future<TransactionModel> addTransaction({
    required String title,
    required double amount,
    required bool isIncome,
  }) async {
    final finances = await _getFinancesRow();

    final signedAmount = isIncome ? amount.abs() : -amount.abs();

    final data = await _client
        .from('transactions')
        .insert({
          'finances_id': finances.id,
          'title': title,
          'amount': signedAmount,
        })
        .select('id, title, amount, created_at')
        .single();

    await _client
        .from('finances')
        .update({'total_amount': finances.totalAmount + signedAmount})
        .eq('id', finances.id);

    final storedAmount = (data['amount'] as num).toDouble();
    return TransactionModel.fromMap({
      'id': data['id'],
      'title': data['title'],
      'amount': storedAmount.abs(),
      'created_at': data['created_at'],
      'is_income': storedAmount >= 0,
    });
  }

  Future<void> deleteTransaction(int id) async {
    final txRow = await _client
        .from('transactions')
        .select('amount, finances_id')
        .eq('id', id)
        .single();

    final signedAmount = (txRow['amount'] as num).toDouble();
    final financesId = txRow['finances_id'] as int;

    await _client
        .from('transactions')
        .update({'is_deleted': true})
        .eq('id', id);

    final financesRow = await _client
        .from('finances')
        .select('total_amount')
        .eq('id', financesId)
        .single();

    final currentTotal =
        (financesRow['total_amount'] as num?)?.toDouble() ?? 0.0;

    await _client
        .from('finances')
        .update({'total_amount': currentTotal - signedAmount})
        .eq('id', financesId);
  }
}
