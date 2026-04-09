import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  ScheduleSubjectEntity _findSubject() {
    for (final s in subjects) {
      if (s.id == entry.subId) return s;
    }
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

class _EditScheduleSheetBody extends StatelessWidget {
  final ScheduleEntryEntity entry;
  final List<ScheduleSubjectEntity> subjects;

  const _EditScheduleSheetBody({
    required this.entry,
    required this.subjects,
  });

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
                  child: const Icon(Icons.close, size: 22, color: AppColors.text),
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

            const Text(
              'Subject',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const Gap(8),
            subjects.isEmpty
                ? const _NoSubjectsHint()
                : _SubjectDropdown(subjects: subjects),

            const Gap(20),

            const Text(
              'Days',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const Gap(8),
            const _DayChips(),

            const Gap(20),

            const Text(
              'Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const Gap(8),
            const _TimeRow(),

            const Gap(28),

            _ConfirmButton(entryId: entry.id),
          ],
        ),
      ),
    );
  }
}

class _SubjectDropdown extends StatelessWidget {
  final List<ScheduleSubjectEntity> subjects;

  const _SubjectDropdown({required this.subjects});

  UnderlineInputBorder _border(Color color, {double width = 1.0}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      builder: (context, state) {
        return DropdownButtonFormField<ScheduleSubjectEntity>(
          value: state.selectedSubject,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.foreground,
            size: 20,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            isDense: true,
            border: _border(Colors.grey.shade300),
            enabledBorder: _border(Colors.grey.shade300),
            focusedBorder: _border(AppColors.brandBlue, width: 1.5),
          ),
          hint: const Text(
            'Select a Subject',
            style: TextStyle(
              color: AppColors.foreground,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: subjects.map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(
                '${s.code} - ${s.name}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (s) {
            if (s != null) {
              context
                  .read<AddScheduleBloc>()
                  .add(AddScheduleSubjectSelected(s));
            }
          },
        );
      },
    );
  }
}

class _NoSubjectsHint extends StatelessWidget {
  const _NoSubjectsHint();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: AppColors.foreground),
          Gap(8),
          Expanded(
            child: Text(
              'No subjects available',
              style: TextStyle(fontSize: 12, color: AppColors.foreground),
            ),
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: scheduleDays.map((day) {
            final isSelected = state.selectedDays.contains(day);
            final abbr = _dayAbbr[day]!;

            return GestureDetector(
              onTap: () => context
                  .read<AddScheduleBloc>()
                  .add(AddScheduleDayToggled(day)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.brandBlue : Colors.grey.shade100,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.brandBlue
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    abbr,
                    style: TextStyle(
                      fontSize: abbr.length > 1 ? 10 : 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.foreground,
                    ),
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      buildWhen: (prev, curr) =>
          prev.startTime != curr.startTime || prev.endTime != curr.endTime,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: _UnderlineTimeField(
                label: 'START',
                initialValue: state.startTimeStr,
                onChanged: (time) => context
                    .read<AddScheduleBloc>()
                    .add(AddScheduleStartTimeChanged(time)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.arrow_forward, size: 16, color: AppColors.foreground),
            ),
            Expanded(
              child: _UnderlineTimeField(
                label: 'END',
                initialValue: state.endTimeStr,
                onChanged: (time) => context
                    .read<AddScheduleBloc>()
                    .add(AddScheduleEndTimeChanged(time)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UnderlineTimeField extends StatefulWidget {
  final String label;
  final String initialValue;
  final void Function(TimeOfDay) onChanged;

  const _UnderlineTimeField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_UnderlineTimeField> createState() => _UnderlineTimeFieldState();
}

class _UnderlineTimeFieldState extends State<_UnderlineTimeField> {
  late final TextEditingController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (value.length == 2 && !value.contains(':')) {
      _controller.text = '$value:';
      _controller.selection = const TextSelection.collapsed(offset: 3);
      value = _controller.text;
    }

    TimeOfDay? parsed;
    final parts = value.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h != null && m != null && h >= 0 && h <= 23 && m >= 0 && m <= 59) {
        parsed = TimeOfDay(hour: h, minute: m);
      }
    }

    if (parsed != null) {
      setState(() => _hasError = false);
      widget.onChanged(parsed!);
    } else {
      setState(() => _hasError = value.length >= 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.foreground,
            letterSpacing: 0.5,
          ),
        ),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d:]')),
            LengthLimitingTextInputFormatter(5),
          ],
          onChanged: _onChanged,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText: '00:00',
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.foreground,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            isDense: true,
            border: _border(Colors.grey.shade300),
            enabledBorder: _border(
                _hasError ? AppColors.destructive : Colors.grey.shade300),
            focusedBorder: _border(
                _hasError ? AppColors.destructive : AppColors.brandBlue,
                width: 1.5),
          ),
        ),
        if (_hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Invalid time',
              style: TextStyle(fontSize: 11, color: AppColors.destructive),
            ),
          ),
      ],
    );
  }

  UnderlineInputBorder _border(Color color, {double width = 1.0}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
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
          height: 48,
          child: ElevatedButton(
            onPressed: state.isValid
                ? () {
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
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandBlue,
              disabledBackgroundColor:
                  AppColors.brandBlue.withValues(alpha: 0.4),
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
}