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

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transactions',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),

                        Text(
                          '${state.transactions.length} total',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final tx = state.transactions[index];
                      final isLast = index == state.transactions.length - 1;

                      return Column(
                        children: [
                          TransactionTile(transaction: tx),
                          if (!isLast)
                            const Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Color(0xFFEEEEEE),
                            ),
                        ],
                      );
                    }, 
                    childCount: state.transactions.length
                    ),
                  ),
                ),
              ],
            ),
            
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () => _showAddTransactionSheet(context),
                backgroundColor: AppColors.brandBlue,
                elevation: 4,
                child: const Icon(
                  Icons.add, 
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
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
