import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/bottom_navigation_bar.dart';
import 'package:tempus/features/auth/presentation/pages/login_page.dart';
import 'package:tempus/features/finance/presentation/pages/finance_page.dart';
import 'package:tempus/features/home/presentation/blocs/home_bloc.dart';
import 'package:tempus/features/home/presentation/widgets/home_budget_card.dart';
import 'package:tempus/features/home/presentation/widgets/home_schedule_card.dart';
import 'package:tempus/features/home/presentation/widgets/home_task_card.dart';
import 'package:tempus/features/schedule/data/data_sources/schedule_local_data_source.dart';
import 'package:tempus/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:tempus/features/schedule/domain/use_cases/add_schedule_entry.dart';
import 'package:tempus/features/schedule/domain/use_cases/delete_schedule_entry.dart';
import 'package:tempus/features/schedule/domain/use_cases/load_schedule.dart';
import 'package:tempus/features/schedule/presentation/blocs/schedule/schedule_bloc.dart';
import 'package:tempus/features/schedule/presentation/pages/schedule_page.dart';
import 'package:tempus/features/subjects/data/data_source/subject_local_data_source.dart';
import 'package:tempus/features/subjects/data/repositories/subject_repository_impl.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_subject.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_subjects.dart';
import 'package:tempus/features/subjects/presentation/bloc/subject/subject_bloc.dart';
import 'package:tempus/features/subjects/presentation/pages/subjects_page.dart';
import 'package:tempus/features/tasks/data/data_sources/task_local_data_source.dart';
import 'package:tempus/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:tempus/features/tasks/domain/use_cases/add_task.dart';
import 'package:tempus/features/tasks/domain/use_cases/delete_task.dart';
import 'package:tempus/features/tasks/domain/use_cases/get_tasks.dart';
import 'package:tempus/features/tasks/domain/use_cases/update_task.dart';
import 'package:tempus/features/tasks/presentation/blocs/task/task_bloc.dart';
import 'package:tempus/features/tasks/presentation/pages/tasks_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error signing out'),
            backgroundColor: AppColors.destructive,
          ),
        );
      }
    }
  }

  void _onItemTapped(int idx) {
    if (idx == 0 && _selectedIndex != 0) {
      context.read<HomeBloc>().add(HomeLoadRequested());
    }
    setState(() => _selectedIndex = idx);
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final fullName = user?.userMetadata?['full_name'] as String? ?? 'User';
    final String name = fullName.split(' ').first;
    final DateTime now = DateTime.now();
    final date = DateFormat.yMMMMd('en_US').format(now);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.brandBlue,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "TEMPUS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 24,
              ),
            ),

            Text(
              date,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Account',
            onPressed: () {},
          ),

          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: _signOut,
          ),
        ],
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeContent(
            firstName: name,
            onNavigateToTab: _onItemTapped,
          ),

          BlocProvider<ScheduleBloc>(
            create: (_) {
              final repo = ScheduleRepositoryImpl(ScheduleLocalDataSource());
              return ScheduleBloc(
                loadSchedule: LoadSchedule(repo),
                addScheduleEntry: AddScheduleEntry(repo),
                deleteScheduleEntry: DeleteScheduleEntry(repo),
              )..add(ScheduleLoadRequested());
            },
            child: const SchedulePage(),
          ),

          BlocProvider<TaskBloc>(
            create: (_) {
              final repo = TaskRepositoryImpl(TaskLocalDataSource());
              return TaskBloc(
                getTasks: GetTasks(repo),
                addTask: AddTask(repo),
                updateTasks: UpdateTask(repo),
                deleteTasks: DeleteTask(repo),
              )..add(TaskLoadRequested());
            },
            child: const TasksPage(),
          ),


          MultiBlocProvider(
            providers: FinancePage.createProviders(),
            child: const FinancePage(),
          ),
          
          BlocProvider<SubjectBloc>(
            create: (_) {
              final repo = SubjectRepositoryImpl(SubjectLocalDataSource());
              return SubjectBloc(
                getSubjects: GetSubjects(repo),
                addSubject: AddSubject(repo),
              )..add(SubjectLoadRequested());
            },
            child: const SubjectsPage(),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavBar(
        currentIdx: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final String firstName;
  final ValueChanged<int> onNavigateToTab;

  const _HomeContent({
    required this.firstName,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState> (
      builder: (context, state) {
        return switch(state.status) {
          HomeStatus.initial || HomeStatus.loading => _LoadingContent(),
          HomeStatus.loaded => _LoadedContent(
            name: firstName,
            state: state,
            onNavigateToTasks: () => onNavigateToTab(2),
            ),
          HomeStatus.error => _ErrorContent(
            message: state.errorMessage ?? "Something went wrong",
            onRetry: () => context.read<HomeBloc>().add(HomeLoadRequested()),
          ),
        };
      },
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.brandBlue),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorContent({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: AppColors.destructive.withValues(alpha: 0.5),
            ),

            const Gap(16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.destructive,
                fontSize: 16,
              ),
            ),

            const Gap(24),

            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadedContent extends StatelessWidget {
  final String name;
  final HomeState state;
  final VoidCallback onNavigateToTasks;

  const _LoadedContent({
    required this.name,
    required this.state,
    required this.onNavigateToTasks,
  });

  @override
  Widget build(BuildContext context) {
    final summary = state.summary!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome, $name",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),

          const Gap(20),

          HomeTaskCard(
            summary: summary,
            onViewAll: onNavigateToTasks,
          ),

          const Gap(16),

          HomeBudgetCard(finance: summary.finance),

          const Gap(16),

          HomeScheduleCard(entries: summary.todaySchedule),

          const Gap(16),
        ],
      ),
    );
  }
}
