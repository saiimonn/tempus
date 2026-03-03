part of 'finance_bloc.dart';

enum FinanceStatus { initial, loading, loaded, error }

class FinanceState {
  final FinanceStatus status;
  final FinanceEntity? finance;
  final int selectedTabIndex;
  final String selectedBudgetCycle;
  final String? errorMessage;

  const FinanceState({
    this.status = FinanceStatus.initial,
    this.finance,
    this.selectedTabIndex = 0,
    this.selectedBudgetCycle = 'Weekly',
    this.errorMessage,
  });

  FinanceState copyWith({
    FinanceStatus? status,
    FinanceEntity? finance,
    int? selectedTabIndex,
    String? selectedBudgetCycle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FinanceState(
      status: status ?? this.status,
      finance: finance ?? this.finance,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedBudgetCycle: selectedBudgetCycle ?? this.selectedBudgetCycle,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
