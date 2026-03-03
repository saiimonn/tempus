import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/finance/presentation/blocs/finance/finance_bloc.dart';
import 'package:tempus/features/finance/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:tempus/features/finance/presentation/widgets/budget_ring.dart';
import 'package:tempus/features/finance/presentation/widgets/set_budget_sheet.dart';
import 'package:tempus/features/finance/presentation/widgets/add_transaction_sheet.dart';
import 'package:tempus/features/finance/presentation/widgets/transaction_tile.dart';

class BudgetTab extends StatelessWidget {
  const BudgetTab({super.key});

  void _showBudgetSheet(BuildContext context, double currentBudget) {
    final financeBloc = context.read<FinanceBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: financeBloc,
        child: SetBudgetSheet(currentBudget: currentBudget),
      ),
    );
  }

  void _showAddTransactionSheet(BuildContext context) {
    final transactionBloc = context.read<TransactionBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: transactionBloc,
        child: const AddTransactionSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, financeState) {
        if (financeState.finance == null) return const SizedBox.shrink();

        final finance = financeState.finance!;

        return BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, txState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Budget ring
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.inputFill.withValues(alpha: 0.5)),
                    ),
                    child: BudgetRing(
                      finance: finance,
                      onEditBudget: () =>
                          _showBudgetSheet(context, finance.weeklyAllowance),
                    ),
                  ),

                  const Gap(20),

                  // Spent this month row
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.inputFill.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 18,
                              color: AppColors.foreground,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Spent this month',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.text,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '₱${finance.spentThisWeek < 0 ? 0 : finance.spentThisWeek.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(20),

                  // Recent Transactions header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showAddTransactionSheet(context),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 16,
                              color: AppColors.brandBlue,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Add new transaction',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.brandBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Gap(12),

                  if (txState.transactions.isEmpty)
                    _buildEmptyTransactions()
                  else
                    Column(
                      children: txState.transactions
                          .take(5)
                          .map((tx) => TransactionTile(transaction: tx))
                          .toList(),
                    ),

                  if (finance.weeklyAllowance == 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFFF59E0B)
                                  .withValues(alpha: 0.4)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline,
                                size: 16, color: Color(0xFFF59E0B)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Budget not set yet. Tap the edit icon to set your budget.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyTransactions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            Icons.receipt_outlined,
            size: 48,
            color: AppColors.foreground.withValues(alpha: 0.4),
          ),
          const Gap(12),
          const Text(
            'No transactions yet',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.foreground,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}