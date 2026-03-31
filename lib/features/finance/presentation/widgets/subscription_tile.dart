import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/finance/domain/entities/subscription_entity.dart';
import 'package:tempus/features/finance/presentation/blocs/subscription/subscription_bloc.dart';
import 'package:tempus/features/finance/presentation/widgets/edit_subscription_sheet.dart';

class SubscriptionTile extends StatelessWidget {
  final SubscriptionEntity subscription;

  const SubscriptionTile({super.key, required this.subscription});

  void _showContextMenu(BuildContext context) {
    final subBloc = context.read<SubscriptionBloc>();

    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(subscription.title, style: const TextStyle(fontSize: 12)),

        message: Text(
          '₱${subscription.monthlyPrice.toStringAsFixed(2)} / month',
          style: const TextStyle(fontSize: 12),
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
                  value: subBloc,
                  child: EditSubscriptionSheet(subscription: subscription),
                ),
              );
            },
            child: const Text('Edit'),
          ),

          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              subBloc.add(SubscriptionDeleteRequested(subscription.id));
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
    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                subscription.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '₱${subscription.monthlyPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),

                GestureDetector(
                  onTap: () => _showContextMenu(context),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.more_vert_rounded,
                      size: 16,
                      color: AppColors.foreground.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
