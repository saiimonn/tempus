import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/features/finance/domain/entities/transaction_entity.dart';
import 'package:tempus/features/finance/domain/use_cases/add_transaction.dart';
import 'package:tempus/features/finance/domain/use_cases/delete_transaction.dart';
import 'package:tempus/features/finance/domain/use_cases/get_transactions.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactions _getTransactions;
  final AddTransaction _addTransaction;
  final DeleteTransaction _deleteTransaction;

  TransactionBloc({
    required GetTransactions getTransactions,
    required AddTransaction addTransaction,
    required DeleteTransaction deleteTransaction,
  }) : _getTransactions = getTransactions,
       _addTransaction = addTransaction,
       _deleteTransaction = deleteTransaction,
       super(const TransactionState()) {
    on<TransactionLoadRequested>(_onLoad);
    on<TransactionAddRequested>(_onAdd);
    on<TransactionDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(
    TransactionLoadRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      final transactions = await _getTransactions();
      emit(
        state.copyWith(
          status: TransactionStatus.loaded,
          transactions: transactions,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: 'Failed to load transactions',
        ),
      );
    }
  }

  Future<void> _onAdd(
    TransactionAddRequested event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final newTx = await _addTransaction(
        title: event.title,
        amount: event.amount,
        isIncome: event.isIncome,
      );
      emit(state.copyWith(transactions: [newTx, ...state.transactions]));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Failed to add transaction'));
    }
  }

  Future<void> _onDelete(
    TransactionDeleteRequested event,
    Emitter<TransactionState> emit,
  ) async {
    try{
      await _deleteTransaction(event.id);
      emit(
        state.copyWith(
          transactions: state.transactions
              .where((t) => t.id != event.id)
              .toList(),
        ),
      );
    } catch(_) {
      emit(state.copyWith(errorMessage: 'Failed to delete transaction'));
    }
  }
}
