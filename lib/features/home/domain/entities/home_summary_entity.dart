import 'package:tempus/features/finance/domain/entities/finance_entity.dart';
import 'package:tempus/features/tasks/domain/entities/task_entity.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';

class HomeSummaryEntity {
  final List<TaskEntity> todayTasks;
  final List<ScheduleEntryEntity> todaySchedule;
  final FinanceEntity? finance;

  const HomeSummaryEntity({
    required this.todayTasks,
    required this.todaySchedule,
    required this.finance,
  });

  int get totalTasks => todayTasks.length;

  int get completedTasks => todayTasks.where((t) => t.isComplete).length;

  int get remainingTasks => todayTasks.where((t) => !t.isComplete).length;

  double get completePercentage =>
      totalTasks > 0 ? (completedTasks / totalTasks) : 0;

  bool get hasFinance => finance != null && finance!.weeklyAllowance > 0;
}
