import 'package:tempus/features/finance/data/models/finance_model.dart';

class FinanceLocalDataSource {
  Future<FinanceModel> getFinance() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return FinanceModel.fromMap({
      'id': 1,
      'weekly_allowance': 5000.0,
      'total_amount': 5000.0,
    });
  }

  Future <FinanceModel> updateBudget(double weeklyAllowance) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return FinanceModel.fromMap({
      'id': 1,
      'weekly_allowance': weeklyAllowance,
      'total_amount': weeklyAllowance,
    });
  }
}