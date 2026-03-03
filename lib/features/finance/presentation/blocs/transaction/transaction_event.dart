part of 'transaction_bloc.dart';

sealed class TransactionEvent {}

class TransactionLoadRequested extends TransactionEvent {}

class TransactionAddRequested extends TransactionEvent {
  final String title;
  final double amount;
  final bool isIncome;

  TransactionAddRequested({
    required this.title,
    required this.amount,
    required this.isIncome,
  });
}

class TransactionDeleteRequested extends TransactionEvent {
  final int id;
  TransactionDeleteRequested(this.id);
}

class TransactionTypeChanged extends TransactionEvent {
  final bool isIncome;

  TransactionTypeChanged(this.isIncome);
}
