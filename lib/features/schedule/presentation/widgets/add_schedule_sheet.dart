// used in add_button.dart -> _showSheet()
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/logic/add_schedule_sheet_bloc.dart';
import 'package:tempus/features/schedule/logic/schedule_bloc.dart';

const dayAbbr = {
  'Monday': 'Mon',
  'Tuesday': 'Tue',
  'Wednesday': 'Wed',
  'Thursday': 'Thu',
  'Friday': 'Fri',
  'Saturday': 'Sat',
  'Sunday': 'Sun',
};

class AddScheduleSheet extends StatelessWidget {
  final List<Map<String, dynamic>> subjects;

  const AddScheduleSheet({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddScheduleBloc(),
      child: AddScheduleSheetBody(subjects: subjects),
    );
  }
}

class AddScheduleSheetBody extends StatelessWidget {
  final List<Map<String, dynamic>> subjects;

  const AddScheduleSheetBody({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    size: 22,
                    color: AppColors.text,
                  ),
                ),

                const Expanded(
                  child: Center(
                    child: Text(
                      "Add Schedule",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ),
                const Gap(22),
              ],
            ),

            const Gap(24),

            _buildLabel("Subjects"),

            const Gap(8),

            subjects.isEmpty
                ? _NoSubjectsHint()
                : _SubjectDropdown(subjects: subjects),

            const Gap(16),

            _buildLabel("Days"),
            _DayChips(),

            const Gap(16),

            _buildLabel("Time"),
            _TimeRow(),
            
            const Gap(28),
            
            _ConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),
  );
}

class _SubjectDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> subjects;

  const _SubjectDropdown({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      buildWhen: (prev, curr) => prev.selectedSubject != curr.selectedSubject,
      builder: (context, state) {
        final selected = state.selectedSubject;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected != null
                  ? AppColors.brandBlue
                  : AppColors.inputFill,
              width: selected != null ? 2 : 1,
            ),
          ),

          child: DropdownButtonHideUnderline(
            child: DropdownButton<Map<String, dynamic>>(
              value: selected,
              isExpanded: true,
              hint: const Text(
                "Select a Subject",
                style: TextStyle(color: AppColors.foreground, fontSize: 14),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.foreground,
              ),

              style: const TextStyle(color: AppColors.text, fontSize: 15),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              items: subjects.map((sub) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: sub,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.brandBlue,
                        ),
                      ),
                      const Gap(10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${sub['code']}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.text,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            Text(
                              "${sub['name']}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.text,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  context.read<AddScheduleBloc>().add(SubjectSelected(val));
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class _NoSubjectsHint extends StatelessWidget {
  const _NoSubjectsHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: const Column(
        children: [
          Icon(Icons.info_outline, size: 24, color: AppColors.foreground),

          Text(
            "No subjects yet. Add subjects first in the Subjects tab.",
            style: TextStyle(fontSize: 12, color: AppColors.foreground),
          ),
        ],
      ),
    );
  }
}

class _DayChips extends StatelessWidget {
  const _DayChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      buildWhen: (prev, curr) => prev.selectedDays != curr.selectedDays,
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ScheduleDays.map((day) {
            final isSelected = state.selectedDays.contains(day);

            return GestureDetector(
              onTap: () => context.read<AddScheduleBloc>().add(DayToggled(day)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.brandBlue
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.brandBlue
                        : AppColors.inputFill,
                    width: 1,
                  ),
                ),

                child: Text(
                  dayAbbr[day]!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.foreground,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow();

  String fmtDisplay(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final min = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$min $period";
  }

  Future<void> pickTime(
    BuildContext context, {
    required bool isStart,
    required TimeOfDay initial,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.brandBlue,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked == null || !context.mounted) return;

    context.read<AddScheduleBloc>().add(
      isStart ? StartTimeChanged(picked) : EndTimeChanged(picked),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      buildWhen: (prev, curr) =>
          prev.startTime != curr.startTime || prev.endTime != curr.endTime,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _TimeButton(
                    label: "Start",
                    displayValue: fmtDisplay(state.startTime),
                    isError: false,
                    onTap: () => pickTime(
                      context,
                      isStart: true,
                      initial: state.startTime,
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColors.text,
                  ),
                ),

                Expanded(
                  child: _TimeButton(
                    label: "End",
                    displayValue: fmtDisplay(state.endTime),
                    isError: false,
                    onTap: () => pickTime(
                      context,
                      isStart: false,
                      initial: state.endTime,
                    ),
                  ),
                ),
              ],
            ),

            if (state.timeInvalid) ...[
              
            ]
          ],
        );
      },
    );
  }
}

class _TimeButton extends StatelessWidget {
  final String label;
  final String displayValue;
  final bool isError;
  final VoidCallback onTap;

  const _TimeButton({
    required this.label,
    required this.displayValue,
    required this.isError,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isError ? AppColors.destructive : AppColors.inputFill,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
            Gap(2),
            Text(
              displayValue,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      buildWhen: (prev, curr) => prev.isValid != curr.isValid,
      builder: (context, state) {
        return Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isValid ? () => _confirm(context, state) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandBlue,
              disabledBackgroundColor: AppColors.brandBlue.withValues(
                alpha: 0.5,
              ),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirm(BuildContext context, AddScheduleState state) {
    context.read<ScheduleBloc>().add(
      AddScheduleEntry(
        subId: state.selectedSubject!['id'] as int,
        subjectName: state.selectedSubject!['name'] as String,
        subjectCode: state.selectedSubject!['code'] as String,
        days: state.selectedDays.toList(),
        startTime: state.startTimeStr,
        endTime: state.endTimeStr,
      ),
    );
  }
}
