import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/home/domain/entities/home_summary_entity.dart';
import 'package:tempus/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:tempus/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:tempus/features/tasks/domain/use_cases/get_tasks.dart';
import 'package:tempus/features/schedule/data/data_sources/schedule_local_data_source.dart';
import 'package:tempus/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:tempus/features/schedule/domain/use_cases/load_schedule.dart';
import 'package:tempus/features/finance/data/data_sources/finance_remote_data_source.dart';
import 'package:tempus/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:tempus/features/finance/domain/use_cases/get_finance.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTasks _getTasks;
  final LoadSchedule _loadSchedule;
  final GetFinance _getFinance;

  HomeBloc({
    required GetTasks getTasks,
    required LoadSchedule loadSchedule,
    required GetFinance getFinance,
  })  : _getTasks = getTasks,
        _loadSchedule = loadSchedule,
        _getFinance = getFinance,
        super(const HomeState.initial()) {
    on<HomeLoadRequested>(_onLoad);
  }

  factory HomeBloc.create() {
    final client = Supabase.instance.client;

    final taskRepo =
        TaskRepositoryImpl(TaskRemoteDataSource(client));
    final scheduleRepo =
        ScheduleRepositoryImpl(ScheduleLocalDataSource()); // still local
    final financeRepo =
        FinanceRepositoryImpl(FinanceRemoteDataSource(client));

    return HomeBloc(
      getTasks: GetTasks(taskRepo),
      loadSchedule: LoadSchedule(scheduleRepo),
      getFinance: GetFinance(financeRepo),
    );
  }

  Future<void> _onLoad(HomeLoadRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final now = DateTime.now();
      final todayDayName = _dayName(now.weekday);

      final tasks = await _getTasks();
      final schedule = await _loadSchedule();
      final finance = await _getFinance();

      final todayTasks = tasks
          .where((t) => !t.isComplete && _isToday(t.dueDate, now))
          .toList();

      final todaySchedule =
          schedule.entries.where((e) => e.days.contains(todayDayName)).toList()
            ..sort((a, b) => a.startTime.compareTo(b.startTime));

      final summary = HomeSummaryEntity(
        todayTasks: todayTasks,
        todaySchedule: todaySchedule,
        finance: finance,
      );

      emit(state.copyWith(status: HomeStatus.loaded, summary: summary));
    } catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.error,
          errorMessage: 'Failed to load home data',
        ),
      );
    }
  }

  bool _isToday(DateTime? date, DateTime now) {
    if (date == null) return false;
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _dayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }
}