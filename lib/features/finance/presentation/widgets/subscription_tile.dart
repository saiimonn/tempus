import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/finance/domain/entities/subscription_entity.dart';
import 'package:tempus/features/finance/presentation/blocs/subscription/subscription_bloc.dart';

class SubscriptionTile extends StatelessWidget {
  final SubscriptionEntity subscription;

  const SubscriptionTile({super.key, required this.subscription});

  Color get _iconColor {
    final hue = subscription.title.hashCode.abs() % 360;
    return HSVColor.fromAHSV(1, hue.toDouble(), 0.55, 0.80).toColor();
  }

  String get _initials {
    final words = subscription.title.trim().split(' ');
    if (words.length >= 2) return '${words[0][0]}${words[1][0]}'.toUpperCase();
    return subscription.title
        .substring(0, subscription.title.length.clamp(0, 2))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('tx_${subscription.id}'),
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
        context.read<SubscriptionBloc>().add(
          SubscriptionDeleteRequested(subscription.id),
        );
      },
      
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              subscription.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            
            Text(
              '₱${subscription.monthlyPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
