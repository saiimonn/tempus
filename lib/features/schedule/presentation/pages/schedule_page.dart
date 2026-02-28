import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/presentation/blocs/schedule/schedule_bloc.dart';
import 'package:tempus/features/schedule/presentation/widgets/add_button.dart';
import 'package:tempus/features/schedule/presentation/widgets/empty_schedule.dart';
import 'package:tempus/features/schedule/presentation/widgets/schedule_entry_card.dart';
import 'package:tempus/features/schedule/presentation/widgets/time_table_grid.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        return switch (state) {
          ScheduleLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.brandBlue),
            ),
          ScheduleLoaded() => _ScheduleContent(state: state),
          ScheduleError(:final message) => Center(child: Text(message)),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _ScheduleContent extends StatelessWidget {
  final ScheduleLoaded state;

  const _ScheduleContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
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
        ),

        if (state.entries.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptySchedule(subjects: state.subjects),
          )
        else ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TimetableGrid(state: state),
            ),
          ),

          const SliverToBoxAdapter(child: Gap(24)),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Classes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: Gap(12)),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: ScheduleEntryCard(entry: state.entries[i]),
              ),
              childCount: state.entries.length,
            ),
          ),

          const SliverToBoxAdapter(child: Gap(40)),
        ],
      ],
    );
  }
}