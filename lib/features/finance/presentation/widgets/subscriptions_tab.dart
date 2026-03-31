import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/finance/presentation/blocs/subscription/subscription_bloc.dart';
import 'package:tempus/features/finance/presentation/widgets/add_subscription_sheet.dart';
import 'package:tempus/features/finance/presentation/widgets/subscription_tile.dart';

class SubscriptionsTab extends StatelessWidget {
  const SubscriptionsTab({super.key});

  void _showAddSubscriptionSheet(BuildContext context) {
    final subscriptionBloc = context.read<SubscriptionBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: subscriptionBloc,
        child: const AddSubscriptionSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state.subscriptions.isEmpty) {
          return _buildEmptyState(context);
        }

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildSummaryCard(state),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subscriptions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final tx = state.subscriptions[index];
                        final isLast = index == state.subscriptions.length - 1;

                        return Column(
                          children: [
                            SubscriptionTile(subscription: tx),
                            if (!isLast)
                              const Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Color(0xFFEEEEEE),
                              ),
                          ],
                        );
                      },
                      childCount: state.subscriptions.length,
                    ),
                  ),
                ),
              ],
            ),
            
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                heroTag: 'subscriptions_fab',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                onPressed: () => _showAddSubscriptionSheet(context),
                backgroundColor: AppColors.brandBlue,
                elevation: 4,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(SubscriptionState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.brandBlue,
            AppColors.brandBlue.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Monthly',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${state.subscriptions.length} Active',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Text(
            '₱${state.totalMonthly.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const Gap(16),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          const Gap(16),
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white70, size: 16),
              const Gap(6),
              Text(
                'Estimated yearly: ₱${(state.totalMonthly * 12).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subscriptions_outlined,
            size: 60,
            color: AppColors.foreground.withValues(alpha: 0.4),
          ),
          const Gap(16),
          const Text(
            'No Subscriptions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
            ),
          ),
          const Gap(20),
          GestureDetector(
            onTap: () => _showAddSubscriptionSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.brandBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Add Subscription',
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