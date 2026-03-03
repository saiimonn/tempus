part of 'transaction_bloc.dart';

enum TransactionStatus { initial, loading, loaded, error }

class TransactionState {
  final TransactionStatus status;
  final List<TransactionEntity> transactions;
  final bool selectedIsIncome;
  final String? errorMessage;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.selectedIsIncome = false,
    this.errorMessage,
  });

  Map<String, List<TransactionEntity>> get groupedTransactions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final Map<String, List<TransactionEntity>> grouped = {};

    for (final tx in transactions) {
      final txDay = DateTime(
        tx.createdAt.year,
        tx.createdAt.month,
        tx.createdAt.day,
      );
      final diff = today.difference(txDay).inDays;
      final weeksAgo = diff < 7 ? 0 : (diff / 7).floor();
      final weekStart = today.subtract(
        Duration(days: today.weekday - 1 + (weeksAgo * 7)),
      );
      final weekEnd = weekStart.add(const Duration(days: 6));
      final label = _formatWeekRange(weekStart, weekEnd);
      grouped.putIfAbsent(label, () => []).add(tx);
    }

    return grouped;
  }

  String _formatWeekRange(DateTime start, DateTime end) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (start.month == end.month) {
      return '${months[start.month - 1]} ${start.day} - ${end.day}';
    }
    return '${months[start.month - 1]} ${start.day} - ${months[end.month - 1]}';
  }
  
  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionEntity>? transactions,
    bool? selectedIsIncome,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      selectedIsIncome: selectedIsIncome ?? this.selectedIsIncome,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
