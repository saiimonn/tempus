import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/finance/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:tempus/features/finance/presentation/widgets/add_transaction_sheet.dart';
import 'package:tempus/features/finance/presentation/widgets/transaction_tile.dart';

class TransactionsTab extends StatelessWidget {
  const TransactionsTab({super.key});

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
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state.transactions.isEmpty) {
          return _buildEmptyState(context);
        }

        final grouped = state.groupedTransactions;
        final sortedKeys = grouped.keys.toList();

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              itemCount: sortedKeys.length,
              itemBuilder: (context, i) {
                final weekLabel = sortedKeys[i];
                final txList = grouped[weekLabel]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 4),
                      child: Text(
                        weekLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.foreground,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.inputFill.withValues(alpha: 0.5),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: txList
                            .map((tx) => TransactionTile(transaction: tx))
                            .toList(),
                      ),
                    ),
                    const Gap(16),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () => _showAddTransactionSheet(context),
                backgroundColor: AppColors.brandBlue,
                elevation: 4,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        );
      }
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 60,
            color: AppColors.foreground.withValues(alpha: 0.4),
          ),

          const Gap(16),

          const Text(
            'No Transactions yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
          ),

          const Gap(20),

          GestureDetector(
            onTap: () => _showAddTransactionSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.brandBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Add Transaction',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}