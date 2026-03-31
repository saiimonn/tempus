import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/finance/domain/entities/transaction_entity.dart';
import 'package:tempus/features/finance/presentation/blocs/finance/finance_bloc.dart';
import 'package:tempus/features/finance/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:tempus/features/finance/presentation/widgets/edit_transaction_sheet.dart';

class TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionTile({super.key, required this.transaction});

  String get _subtitleText {
    final parts = <String>[];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDay = DateTime(
      transaction.createdAt.year,
      transaction.createdAt.month,
      transaction.createdAt.day,
    );
    final diff = txDay.difference(today).inDays;

    if (diff == 0) {
      parts.add('Today');
    } else if (diff == -1) {
      parts.add('Yesterday');
    } else if (diff < 0 && diff > -7) {
      parts.add('${diff.abs()} days ago');
    } else {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      parts.add(
          '${months[transaction.createdAt.month - 1]} ${transaction.createdAt.day}');
    }
    parts.add(transaction.isIncome ? 'Income' : 'Expense');

    return parts.join(' · ');
  }

  void _showContextMenu(BuildContext context) {
    final txBloc = context.read<TransactionBloc>();

    // FinanceBloc is in scope inside BudgetTab; guard for TransactionsTab.
    FinanceBloc? financeBloc;
    try {
      financeBloc = context.read<FinanceBloc>();
    } catch (_) {}

    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(
          transaction.title,
          style: const TextStyle(fontSize: 13),
        ),
        message: Text(
          '${transaction.isIncome ? '+' : '-'}₱${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 13,
            color: transaction.isIncome
                ? AppColors.success
                : AppColors.destructive,
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => BlocProvider.value(
                  value: txBloc,
                  child: EditTransactionSheet(transaction: transaction),
                ),
              );
            },
            child: const Text('Edit'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              txBloc.add(TransactionDeleteRequested(transaction.id));
              // Reload the finance summary so the budget ring stays in sync.
              financeBloc?.add(FinanceLoadRequested());
            },
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final amountColor = isIncome ? AppColors.success : AppColors.destructive;
    final sign = isIncome ? '+' : '-';

    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Direction indicator
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: amountColor.withValues(alpha: 0.12),
                border: Border.all(
                    color: amountColor.withValues(alpha: 0.4), width: 1.5),
              ),
              child: Icon(
                isIncome
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 12,
                color: amountColor,
              ),
            ),

            const Gap(12),

            // Title + date label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text),
                  ),
                  Text(
                    _subtitleText,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.foreground),
                  ),
                ],
              ),
            ),

            // Signed amount
            Text(
              '$sign₱${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: amountColor),
            ),

            
            GestureDetector(
              onTap: () => _showContextMenu(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.more_vert_rounded,
                  size: 16,
                  color: AppColors.foreground.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}