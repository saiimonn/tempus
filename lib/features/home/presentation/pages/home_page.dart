import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/bottom_navigation_bar.dart';
import 'package:tempus/features/auth/presentation/pages/login_page.dart';
import 'package:tempus/features/finance/domain/entities/finance_entity.dart';
import 'package:tempus/features/finance/presentation/pages/finance_page.dart';
import 'package:tempus/features/home/domain/entities/home_summary_entity.dart';
import 'package:tempus/features/home/presentation/blocs/home_bloc.dart';
import 'package:tempus/features/home/presentation/widgets/home_budget_card.dart';
import 'package:tempus/features/home/presentation/widgets/home_schedule_card.dart';
import 'package:tempus/features/home/presentation/widgets/home_task_card.dart';
import 'package:tempus/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:tempus/features/profile/presentation/pages/profile_page.dart';
import 'package:tempus/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';
import 'package:tempus/features/schedule/domain/use_cases/add_schedule_entry.dart';
import 'package:tempus/features/schedule/domain/use_cases/update_schedule_entry.dart';
import 'package:tempus/features/schedule/domain/use_cases/delete_schedule_entry.dart';
import 'package:tempus/features/schedule/domain/use_cases/load_schedule.dart';
import 'package:tempus/features/schedule/presentation/blocs/schedule/schedule_bloc.dart';
import 'package:tempus/features/schedule/presentation/pages/schedule_page.dart';
import 'package:tempus/features/subjects/data/data_source/subject_remote_data_source.dart';
import 'package:tempus/features/subjects/data/repositories/subject_repository_impl.dart';
import 'package:tempus/features/subjects/domain/use_cases/add_subject.dart';
import 'package:tempus/features/subjects/domain/use_cases/get_subjects.dart';
import 'package:tempus/features/subjects/presentation/bloc/subject/subject_bloc.dart';
import 'package:tempus/features/subjects/presentation/pages/subjects_page.dart';
import 'package:tempus/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:tempus/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:tempus/features/tasks/domain/entities/task_entity.dart';
import 'package:tempus/features/tasks/domain/use_cases/add_task.dart';
import 'package:tempus/features/tasks/domain/use_cases/delete_task.dart';
import 'package:tempus/features/tasks/domain/use_cases/get_tasks.dart';
import 'package:tempus/features/tasks/domain/use_cases/update_task.dart';
import 'package:tempus/features/tasks/presentation/blocs/task/task_bloc.dart';
import 'package:tempus/features/tasks/presentation/pages/tasks_page.dart';

final _fakeSummary = HomeSummaryEntity(
  todayTasks: List.generate(
    3,
    (i) =>
        TaskEntity(id: i, title: 'Loading task title here', status: 'pending'),
  ),
  todaySchedule: List.generate(
    3,
    (i) => ScheduleEntryEntity(
      id: i,
      subId: 0,
      subjectName: 'Loading Subject Name',
      subjectCode: 'LOAD',
      days: [],
      startTime: '08:00',
      endTime: '10:00',
    ),
  ),
  finance: const FinanceEntity(id: 0, weeklyAllowance: 5000, totalAmount: 2500),
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  ScheduleBloc? _scheduleBloc;

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

    final client = Supabase.instance.client;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
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
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notifications',
            onPressed: () => print("Notification Page"),
          ),
          
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Account',
            onPressed: () {
              final profileBloc = BlocProvider.of<ProfileBloc>(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: profileBloc,
                    child: const ProfilePage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeContent(firstName: name, onNavigateToTab: _onItemTapped),

          // ── Schedule (remote) ──────────────────────────────────────────────────
          BlocProvider<ScheduleBloc>(
            create: (ctx) {
              // Store a reference so SubjectBloc can call refreshSubjects on it.
              _scheduleBloc = ScheduleBloc(
                loadSchedule: LoadSchedule(ScheduleRepositoryImpl.create()),
                addScheduleEntry: AddScheduleEntry(
                  ScheduleRepositoryImpl.create(),
                ),
                updateScheduleEntry: UpdateScheduleEntry(ScheduleRepositoryImpl.create()),
                deleteScheduleEntry: DeleteScheduleEntry(
                  ScheduleRepositoryImpl.create(),
                ),
              )..add(ScheduleLoadRequested());
              return _scheduleBloc!;
            },
            child: const SchedulePage(),
          ),

          // ── Tasks (remote) ─────────────────────────────────────────────────────
          BlocProvider<TaskBloc>(
            create: (_) {
              final repo = TaskRepositoryImpl(TaskRemoteDataSource(client));
              return TaskBloc(
                getTasks: GetTasks(repo),
                addTask: AddTask(repo),
                updateTasks: UpdateTask(repo),
                deleteTasks: DeleteTask(repo),
              )..add(TaskLoadRequested());
            },
            child: const TasksPage(),
          ),

          // ── Finance (remote) ───────────────────────────────────────────────────
          MultiBlocProvider(
            providers: FinancePage.createProviders(),
            child: const FinancePage(),
          ),

          // ── Subjects (remote) — notifies ScheduleBloc on subject add ──────────
          BlocProvider<SubjectBloc>(
            create: (_) {
              final repo = SubjectRepositoryImpl(
                SubjectRemoteDataSource(client),
              );
              return SubjectBloc(
                getSubjects: GetSubjects(repo),
                addSubject: AddSubject(repo),
                // Callback: tell ScheduleBloc its subject list is stale.
                onSubjectAdded: () {
                  _scheduleBloc?.add(ScheduleSubjectsRefreshRequested());
                },
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

  const _HomeContent({required this.firstName, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.error) {
          return _ErrorContent(
            message: state.errorMessage ?? 'Something went wrong',
            onRetry: () => context.read<HomeBloc>().add(HomeLoadRequested()),
          );
        }

        final isLoading =
            state.status == HomeStatus.initial ||
            state.status == HomeStatus.loading;

        return Skeletonizer(
          enabled: isLoading,
          child: _LoadedContent(
            name: firstName,
            state: isLoading
                ? HomeState(status: HomeStatus.loaded, summary: _fakeSummary)
                : state,
            onNavigateToTasks: () => onNavigateToTab(2),
          ),
        );
      },
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorContent({required this.message, required this.onRetry});

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
              style: const TextStyle(
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
          HomeTaskCard(summary: summary, onViewAll: onNavigateToTasks),
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
