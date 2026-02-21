import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/logic/schedule_bloc.dart';
import 'package:tempus/features/schedule/data/schedule_model.dart';
import 'package:tempus/features/schedule/presentation/widgets/add_button.dart';
import 'package:tempus/features/schedule/presentation/widgets/empty_schedule.dart';

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
        }
      )
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

        if(state.entries.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptySchedule(subject: state.subjects)
          )
      ]
    );
  }
}