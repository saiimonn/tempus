part of 'finance_bloc.dart';

sealed class FinanceEvent {}

class FinanceLoadRequested extends FinanceEvent {}

class FinanceBudgetUpdateRequested extends FinanceEvent {
  final double weeklyAllowance;
  FinanceBudgetUpdateRequested(this.weeklyAllowance);
}

class FinanceTabChanged extends FinanceEvent {
  final int tabIndex;
  FinanceTabChanged(this.tabIndex);
}

class FinanceBudgetCycleChanged extends FinanceEvent {
  final String cycle;

  FinanceBudgetCycleChanged(this.cycle);
}
