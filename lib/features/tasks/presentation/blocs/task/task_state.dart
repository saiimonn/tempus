part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final Set<String> expandedSections;

  TaskLoaded(this.tasks, {Set<String>? expandedSections})
    : expandedSections =
          expandedSections ?? {'Today', 'Upcoming', 'No Due', 'Completed'};

  @override
  List<Object?> get props => [tasks, expandedSections];

  List<TaskEntity> get pastDueTasks =>
      tasks.where((t) => !t.isComplete && t.isPastDue).toList();

  List<TaskEntity> get todayTasks =>
      tasks.where((t) => !t.isComplete && t.isToday).toList();

  List<TaskEntity> get upcomingTasks =>
      tasks.where((t) => !t.isComplete && t.isUpcoming).toList();

  List<TaskEntity> get noDueTasks =>
      tasks.where((t) => !t.isComplete && t.hasNoDue).toList();

  List<TaskEntity> get completedTasks =>
      tasks.where((t) => t.isComplete).toList();

  int get pendingCount => tasks.where((t) => !t.isComplete).length;

  bool isSectionExpanded(String sectionName) =>
      expandedSections.contains(sectionName);

  TaskLoaded copyWith({
    List<TaskEntity>? tasks,
    Set<String>? expandedSections,
  }) {
    return TaskLoaded(
      tasks ?? this.tasks,
      expandedSections: expandedSections ?? this.expandedSections,
    );
  }
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}
