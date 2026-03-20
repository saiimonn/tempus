import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/finance/domain/entities/finance_entity.dart';
import 'package:tempus/features/finance/domain/use_cases/get_finance.dart';
import 'package:tempus/features/finance/domain/use_cases/update_budget.dart';

part 'finance_event.dart';
part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final GetFinance _getFinance;
  final UpdateBudget _updateBudget;

  FinanceBloc({
    required GetFinance getFinance,
    required UpdateBudget updateBudget,
  })  : _getFinance = getFinance,
        _updateBudget = updateBudget,
        super(const FinanceState()) {
    on<FinanceLoadRequested>(_onLoad);
    on<FinanceBudgetUpdateRequested>(_onUpdateBudget);
    on<FinanceTabChanged>(_onTabChanged);
    on<FinanceBudgetCycleChanged>(_onBudgetCycleChanged);
  }

  Future<void> _onLoad(
    FinanceLoadRequested event,
    Emitter<FinanceState> emit,
  ) async {
    emit(state.copyWith(status: FinanceStatus.loading));

    // NOTE: the artificial Future.delayed that was here has been removed.
    // Skeletonizer shows while the real network request is in flight.

    try {
      final finance = await _getFinance();
      emit(state.copyWith(status: FinanceStatus.loaded, finance: finance));
    } catch (_) {
      emit(
        state.copyWith(
          status: FinanceStatus.error,
          errorMessage: 'Failed to load finance data',
        ),
      );
    }
  }

  Future<void> _onUpdateBudget(
    FinanceBudgetUpdateRequested event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      final updated = await _updateBudget(event.weeklyAllowance);
      emit(state.copyWith(finance: updated));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Failed to update budget'));
    }
  }

  void _onTabChanged(FinanceTabChanged event, Emitter<FinanceState> emit) {
    emit(state.copyWith(selectedTabIndex: event.tabIndex));
  }

  void _onBudgetCycleChanged(
    FinanceBudgetCycleChanged event,
    Emitter<FinanceState> emit,
  ) {
    emit(state.copyWith(selectedBudgetCycle: event.cycle));
  }
}