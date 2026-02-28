import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/tasks/presentation/blocs/task/task_bloc.dart';
import 'package:tempus/features/tasks/presentation/widgets/add_task_sheet.dart';
import 'package:tempus/features/tasks/presentation/widgets/task_section.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final Set<String> _expandedSections = {
    'Today',
    'Upcoming',
    'No Due',
    'Completed',
  };

  void _toggleSection(String name) {
    setState(() {
      if (_expandedSections.contains(name)) {
        _expandedSections.remove(name);
      } else {
        _expandedSections.add(name);
      }
    });
  }

  void _showAddTaskSheet(BuildContext context) {
    final taskBloc = context.read<TaskBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: taskBloc,
        child: const AddTaskSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brandBlue),
            );
          }

          if (state is TaskError) {
            return Center(child: Text(state.message));
          }

          if (state is TaskLoaded) {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                        child: Text(
                          'Tasks',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          TaskSection(
                            title: 'Today',
                            tasks: state.todayTasks,
                            isExpanded: _expandedSections.contains('Today'),
                            onToggle: () => _toggleSection('Today'),
                            showAddButton: true,
                            onAdd: () => _showAddTaskSheet(context),
                          ),
                          TaskSection(
                            title: 'Upcoming',
                            tasks: state.upcomingTasks,
                            isExpanded: _expandedSections.contains('Upcoming'),
                            onToggle: () => _toggleSection('Upcoming'),
                          ),
                          TaskSection(
                            title: 'No Due',
                            tasks: state.noDueTasks,
                            isExpanded: _expandedSections.contains('No Due'),
                            onToggle: () => _toggleSection('No Due'),
                          ),
                          TaskSection(
                            title: 'Completed',
                            tasks: state.completedTasks,
                            isExpanded: _expandedSections.contains('Completed'),
                            onToggle: () => _toggleSection('Completed'),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
                // Floating add button
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () => _showAddTaskSheet(context),
                    backgroundColor: AppColors.brandBlue,
                    elevation: 4,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}