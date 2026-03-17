import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/finance/domain/entities/transaction_entity.dart';
import 'package:tempus/features/finance/presentation/blocs/transaction/transaction_bloc.dart';

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
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'June',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      parts.add(
        '${months[transaction.createdAt.month - 1]} ${transaction.createdAt.day} ',
      );
    }
    parts.add(transaction.isIncome ? 'Income' : 'Expense');

    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final amountColor = isIncome ? AppColors.success : AppColors.destructive;
    final sign = isIncome ? '+' : '-';

    return Dismissible(
      key: Key('tx_${transaction.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.destructive.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),

        child: const Icon(
          Icons.delete_outline,
          color: AppColors.destructive,
          size: 22,
        ),
      ),

      onDismissed: (_) {
        context.read<TransactionBloc>().add(
          TransactionDeleteRequested(transaction.id),
        );
      },
      
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: amountColor.withValues(alpha: 0.12),
                border: Border.all(
                  color: amountColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
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
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  
                  Text(
                    _subtitleText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
            ),
            
            Text(
              '$sign₱${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
