import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/finance/data/models/finance_model.dart';

class FinanceRemoteDataSource {
  final SupabaseClient _client;

  const FinanceRemoteDataSource(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<FinanceModel> getFinance() async {
    final data = await _client
        .from('finances')
        .select('id, weekly_allowance, total_amount')
        .eq('user_id', _userId)
        .single();

    return FinanceModel.fromMap({
      'id': data['id'],
      'weekly_allowance': (data['weekly_allowance'] as num?)?.toDouble() ?? 0.0,
      'total_amount': (data['total_amount'] as num?)?.toDouble() ?? 0.0,
    });
  }

  Future<FinanceModel> updateBudget(double weeklyAllowance) async {
    final current = await getFinance();
    final spent = current.spentThisWeek.clamp(0.0, double.infinity);
    final newTotal = (weeklyAllowance - spent).clamp(0.0, weeklyAllowance);

    final data = await _client
        .from('finances')
        .update({'weekly_allowance': weeklyAllowance, 'total_amount': newTotal})
        .eq('user_id', _userId)
        .select('id, weekly_allowance, total_amount')
        .single();

    return FinanceModel.fromMap({
      'id': data['id'],
      'weekly_allowance': (data['weekly_allowance'] as num?)?.toDouble() ?? 0.0,
      'total_amount': (data['total_amount'] as num?)?.toDouble ?? 0.0,
    });
  }
}
