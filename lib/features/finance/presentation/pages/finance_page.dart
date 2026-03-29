import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/finance/data/data_sources/finance_remote_data_source.dart';
import 'package:tempus/features/finance/data/data_sources/subscription_remote_data_source.dart';
import 'package:tempus/features/finance/data/data_sources/transaction_remote_data_source.dart';
import 'package:tempus/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:tempus/features/finance/data/repositories/subscription_repository_impl.dart';
import 'package:tempus/features/finance/data/repositories/transaction_repository_impl.dart';
import 'package:tempus/features/finance/domain/entities/finance_entity.dart';
import 'package:tempus/features/finance/domain/use_cases/get_finance.dart';
import 'package:tempus/features/finance/domain/use_cases/update_budget.dart';
import 'package:tempus/features/finance/domain/use_cases/get_subscriptions.dart';
import 'package:tempus/features/finance/domain/use_cases/add_subscription.dart';
import 'package:tempus/features/finance/domain/use_cases/delete_subscription.dart';
import 'package:tempus/features/finance/domain/use_cases/get_transactions.dart';
import 'package:tempus/features/finance/domain/use_cases/add_transaction.dart';
import 'package:tempus/features/finance/domain/use_cases/delete_transaction.dart';
import 'package:tempus/features/finance/presentation/blocs/finance/finance_bloc.dart';
import 'package:tempus/features/finance/presentation/blocs/subscription/subscription_bloc.dart';
import 'package:tempus/features/finance/presentation/blocs/transaction/transaction_bloc.dart';
import 'package:tempus/features/finance/presentation/widgets/budget_tab.dart';
import 'package:tempus/features/finance/presentation/widgets/subscriptions_tab.dart';
import 'package:tempus/features/finance/presentation/widgets/transactions_tab.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  static List<BlocProvider> createProviders() {
    final client = Supabase.instance.client;

    final financeRepo = FinanceRepositoryImpl(FinanceRemoteDataSource(client));
    final transactionRepo = TransactionRepositoryImpl(
      TransactionsRemoteDataSource(client),
    );
    final subscriptionRepo = SubscriptionRepositoryImpl(
      SubscriptionRemoteDataSource(client),
    );

    return [
      BlocProvider<FinanceBloc>(
        create: (_) => FinanceBloc(
          getFinance: GetFinance(financeRepo),
          updateBudget: UpdateBudget(financeRepo),
        )..add(FinanceLoadRequested()),
      ),
      BlocProvider<TransactionBloc>(
        create: (_) => TransactionBloc(
          getTransactions: GetTransactions(transactionRepo),
          addTransaction: AddTransaction(transactionRepo),
          deleteTransaction: DeleteTransaction(transactionRepo),
        )..add(TransactionLoadRequested()),
      ),
      BlocProvider<SubscriptionBloc>(
        create: (_) => SubscriptionBloc(
          getSubscriptions: GetSubscriptions(subscriptionRepo),
          addSubscription: AddSubscription(subscriptionRepo),
          deleteSubscription: DeleteSubscription(subscriptionRepo),
        )..add(SubscriptionLoadRequested()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        final bool isLoading =
            state.status == FinanceStatus.loading ||
            state.status == FinanceStatus.initial;

        final displayState = isLoading
            ? state.copyWith(
                status: FinanceStatus.loaded,
                finance: const FinanceEntity(
                  id: 0,
                  weeklyAllowance: 3500,
                  totalAmount: 2100,
                ),
              )
            : state;

        return Skeletonizer(
          enabled: isLoading,
          child: _FinanceContent(state: displayState),
        );
      },
    );
  }
}

class _FinanceContent extends StatelessWidget {
  final FinanceState state;

  const _FinanceContent({required this.state});

  static const tabs = ['Budget', 'Transactions', 'Subscriptions'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Finance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandBlue,
                  ),
                ),
                const Gap(12),
                Row(
                  children: List.generate(tabs.length, (i) {
                    final isSelected = state.selectedTabIndex == i;

                    return GestureDetector(
                      onTap: () =>
                          context.read<FinanceBloc>().add(FinanceTabChanged(i)),
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        padding: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected
                                  ? AppColors.brandBlue
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          tabs[i],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? AppColors.brandBlue
                                : AppColors.foreground,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: state.selectedTabIndex,
              children: const [
                BudgetTab(),
                TransactionsTab(),
                SubscriptionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
