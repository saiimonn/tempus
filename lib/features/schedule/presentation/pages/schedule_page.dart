import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';
import 'package:tempus/features/schedule/presentation/blocs/schedule/schedule_bloc.dart';
import 'package:tempus/features/schedule/presentation/widgets/add_button.dart';
import 'package:tempus/features/schedule/presentation/widgets/empty_schedule.dart';
import 'package:tempus/features/schedule/presentation/widgets/time_table_grid.dart';

final _fakeScheduleState = ScheduleLoaded(
  subjects: const [],
  entries: List.generate(
    4,
    (i) => ScheduleEntryEntity(
      id: i,
      subId: 0,
      subjectName: 'Loading Subject Name',
      subjectCode: 'LOAD',
      days: ['Monday'],
      startTime: '08:00',
      endTime: '10:00',
    ),
  ),
  selectedDayIndex: 0,
);

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleInitial || state is ScheduleLoading) {
          return Skeletonizer(
            enabled: true,
            child: _ScheduleContent(state: _fakeScheduleState),
          );
        }

        if (state is ScheduleError) {
          return Center(child: Text(state.message));
        }

        if (state is ScheduleLoaded) {
          return _ScheduleContent(state: state);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ScheduleContent extends StatelessWidget {
  final ScheduleLoaded state;

  const _ScheduleContent({required this.state});

  @override
  Widget build(BuildContext context) {
    // The outer Column fills the Scaffold body.
    // Title + timetable header are fixed; only the timeline rows scroll.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page title + Add button — never scrolls away
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Class Schedule',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              AddButton(subjects: state.subjects),
            ],
          ),
        ),

        // Timetable or empty — expands to fill the rest of the screen
        Expanded(
          child: state.entries.isEmpty
              ? EmptySchedule(subjects: state.subjects)
              : TimetableGrid(state: state),
        ),
      ],
    );
  }
}