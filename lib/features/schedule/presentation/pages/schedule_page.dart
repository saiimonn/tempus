import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/logic/schedule_bloc.dart';
import 'package:tempus/features/schedule/presentation/widgets/add_button.dart';
import 'package:tempus/features/schedule/presentation/widgets/empty_schedule.dart';
import 'package:tempus/features/schedule/presentation/widgets/schedule_entry_card.dart';
import 'package:tempus/features/schedule/presentation/widgets/time_table_grid.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleBloc()..add(LoadSchedule()),
      child: const ScheduleView(),
    );
  }
}

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brandBlue),
            );
          }

          if (state is ScheduleLoaded) {
            return ScheduleContent(state: state);
          }

          return const Center(child: Text("Failed to load schedule."));
        },
      ),
    );
  }
}

class ScheduleContent extends StatelessWidget {
  final ScheduleLoaded state;

  const ScheduleContent({super.key, required this.state});

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
                  "Class Schedule",
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
            child: EmptySchedule(subject: state.subjects),
          )
        else ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TimeTableGrid(entries: state.entries),
            ),
          ),

          const SliverToBoxAdapter(child: Gap(24)),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Classes",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: Gap(12)),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
              final entry = state.entries[i];
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: ScheduleEntryCard(entry: entry),
              );
            },
              childCount: state.entries.length,
            ),
          ),
          
          const SliverToBoxAdapter(child: Gap(40)),
        ],
      ],
    );
  }
}
