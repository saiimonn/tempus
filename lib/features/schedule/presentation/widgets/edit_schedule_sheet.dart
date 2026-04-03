import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_entry_entity.dart';
import 'package:tempus/features/schedule/domain/entities/schedule_subject_entity.dart';
import 'package:tempus/features/schedule/presentation/blocs/add_schedule/add_schedule_bloc.dart';
import 'package:tempus/features/schedule/presentation/blocs/schedule/schedule_bloc.dart';

const _dayAbbr = {
  'Monday': 'Mon',
  'Tuesday': 'Tue',
  'Wednesday': 'Wed',
  'Thursday': 'Thu',
  'Friday': 'Fri',
  'Saturday': 'Sat',
  'Sunday': 'Sun',
};

class EditScheduleSheet extends StatelessWidget {
  final ScheduleEntryEntity entry;
  final List<ScheduleSubjectEntity> subjects;

  const EditScheduleSheet({
    super.key,
    required this.entry,
    required this.subjects,
  });

  /// Looks up the subject by id. Uses an explicit cast so the compiler always
  /// sees [ScheduleSubjectEntity] as the return type, avoiding the runtime
  /// "is not a subtype of ScheduleSubjectModel" error that arises when the
  /// list contains concrete [ScheduleSubjectModel] objects.
  ScheduleSubjectEntity _findSubject() {
    final List<ScheduleSubjectEntity> typed = subjects
        .cast<ScheduleSubjectEntity>();
    for (final s in typed) {
      if (s.id == entry.subId) return s;
    }
    // Fallback: synthesise a pure-entity so the sheet still opens.
    return ScheduleSubjectEntity(
      id: entry.subId,
      name: entry.subjectName,
      code: entry.subjectCode,
    );
  }

  AddScheduleState _buildInitialState() {
    final subject = _findSubject();

    final startParts = entry.startTime.split(':');
    final endParts = entry.endTime.split(':');

    return AddScheduleState(
      selectedSubject: subject,
      selectedDays: Set<String>.from(entry.days),
      startTime: TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddScheduleBloc(initialState: _buildInitialState()),
      child: _EditScheduleSheetBody(entry: entry, subjects: subjects),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _EditScheduleSheetBody extends StatelessWidget {
  final ScheduleEntryEntity entry;
  final List<ScheduleSubjectEntity> subjects;

  const _EditScheduleSheetBody({required this.entry, required this.subjects});

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
            // Handle bar
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

            // Header
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
                      'Edit Schedule',
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

            _buildLabel('Subject'),
            const Gap(8),
            subjects.isEmpty
                ? const _NoSubjectsHint()
                : _SubjectDropdown(subjects: subjects),

            const Gap(16),

            _buildLabel('Days'),
            const Gap(8),
            const _DayChips(),

            const Gap(16),

            _buildLabel('Time'),
            const Gap(8),
            const _TimeRow(),

            const Gap(28),

            _ConfirmButton(entryId: entry.id),
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

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _NoSubjectsHint extends StatelessWidget {
  const _NoSubjectsHint();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: AppColors.foreground),
          Gap(8),
          Expanded(
            child: Text(
              'No subjects yet. Add subjects first in the Subjects tab.',
              style: TextStyle(fontSize: 12, color: AppColors.foreground),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectDropdown extends StatelessWidget {
  final List<ScheduleSubjectEntity> subjects;

  const _SubjectDropdown({required this.subjects});

  /// Same safe lookup used in the sheet root — avoids the ScheduleSubjectModel
  /// subtype mismatch at runtime.
  ScheduleSubjectEntity? _resolve(ScheduleSubjectEntity? selected) {
    if (selected == null) return null;
    final typed = subjects.cast<ScheduleSubjectEntity>();
    for (final s in typed) {
      if (s.id == selected.id) return s;
    }
    return selected;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      buildWhen: (prev, curr) => prev.selectedSubject != curr.selectedSubject,
      builder: (context, state) {
        final resolvedValue = _resolve(state.selectedSubject);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: resolvedValue != null
                  ? AppColors.brandBlue
                  : AppColors.inputFill,
              width: resolvedValue != null ? 2 : 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ScheduleSubjectEntity>(
              // Ensure the Dropdown's `value` is either null or one of the items.
              // If `resolvedValue` isn't present in `subjects` (e.g. a synthesized
              // subject for an entry that references a deleted subject), set the
              // value to null to avoid the DropdownButton "Bad state" error.
              value:
                  resolvedValue != null &&
                      subjects.cast<ScheduleSubjectEntity>().any(
                        (s) => s.id == resolvedValue.id,
                      )
                  ? resolvedValue
                  : null,
              isExpanded: true,
              hint: const Text(
                'Select a Subject',
                style: TextStyle(color: AppColors.foreground, fontSize: 14),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.foreground,
              ),
              style: const TextStyle(color: AppColors.text, fontSize: 15),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              // Cast each item so the DropdownMenuItem type parameter is
              // ScheduleSubjectEntity, not ScheduleSubjectModel.
              items: subjects.cast<ScheduleSubjectEntity>().map((subject) {
                return DropdownMenuItem<ScheduleSubjectEntity>(
                  value: subject,
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
                              subject.code,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.text,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              subject.name,
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
              onChanged: (subject) {
                if (subject != null) {
                  context.read<AddScheduleBloc>().add(
                    AddScheduleSubjectSelected(subject),
                  );
                }
              },
            ),
          ),
        );
      },
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
          children: scheduleDays.map((day) {
            final isSelected = state.selectedDays.contains(day);
            return GestureDetector(
              onTap: () => context.read<AddScheduleBloc>().add(
                AddScheduleDayToggled(day),
              ),
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
                  ),
                ),
                child: Text(
                  _dayAbbr[day]!,
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

  String _fmtDisplay(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final min = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$min $period';
  }

  Future<void> _pickTime(
    BuildContext context, {
    required bool isStart,
    required TimeOfDay initial,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
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
      isStart
          ? AddScheduleStartTimeChanged(picked)
          : AddScheduleEndTimeChanged(picked),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      buildWhen: (prev, curr) =>
          prev.startTime != curr.startTime || prev.endTime != curr.endTime,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: _TimeButton(
                label: 'Start',
                displayValue: _fmtDisplay(state.startTime),
                onTap: () =>
                    _pickTime(context, isStart: true, initial: state.startTime),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.arrow_forward, size: 16, color: AppColors.text),
            ),
            Expanded(
              child: _TimeButton(
                label: 'End',
                displayValue: _fmtDisplay(state.endTime),
                onTap: () =>
                    _pickTime(context, isStart: false, initial: state.endTime),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TimeButton extends StatelessWidget {
  final String label;
  final String displayValue;
  final VoidCallback onTap;

  const _TimeButton({
    required this.label,
    required this.displayValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputFill),
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
            const Gap(2),
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
  final int entryId;
  const _ConfirmButton({required this.entryId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      buildWhen: (prev, curr) => prev.isValid != curr.isValid,
      builder: (context, state) {
        return SizedBox(
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
              'Save Changes',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  void _confirm(BuildContext context, AddScheduleState state) {
    final subject = state.selectedSubject!;

    context.read<ScheduleBloc>().add(
      ScheduleEntryUpdateRequested(
        entryId: entryId,
        subId: subject.id,
        subjectName: subject.name,
        subjectCode: subject.code,
        days: state.selectedDays.toList(),
        startTime: state.startTimeStr,
        endTime: state.endTimeStr,
      ),
    );

    Navigator.of(context).pop();
  }
}
