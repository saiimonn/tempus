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
      'weekly_allowance':
          (data['weekly_allowance'] as num?)?.toDouble() ?? 0.0,
      'total_amount': (data['total_amount'] as num?)?.toDouble() ?? 0.0,
    });
  }

  Future<FinanceModel> updateBudget(double weeklyAllowance) async {
    final current = await getFinance();

    // total_amount represents the remaining balance (not amount spent).
    //
    // Case A — first time setting a budget (previous allowance was 0):
    //   total_amount should be reset to the full new allowance (nothing spent yet).
    //
    // Case B — changing an existing budget mid-cycle:
    //   Preserve how much the user has already spent and apply it to the
    //   new allowance. spent = old_allowance - old_total_amount.
    //   new_total = new_allowance - spent, floored at 0.
    final double newTotal;
    if (current.weeklyAllowance == 0) {
      // Fresh account — no spending history yet
      newTotal = weeklyAllowance;
    } else {
      final spent =
          (current.weeklyAllowance - current.totalAmount).clamp(0.0, double.infinity);
      newTotal = (weeklyAllowance - spent).clamp(0.0, weeklyAllowance);
    }

    final data = await _client
        .from('finances')
        .update({
          'weekly_allowance': weeklyAllowance,
          'total_amount': newTotal,
        })
        .eq('user_id', _userId)
        .select('id, weekly_allowance, total_amount')
        .single();

    return FinanceModel.fromMap({
      'id': data['id'],
      'weekly_allowance':
          (data['weekly_allowance'] as num?)?.toDouble() ?? 0.0,
      'total_amount': (data['total_amount'] as num?)?.toDouble() ?? 0.0,
    });
  }
}