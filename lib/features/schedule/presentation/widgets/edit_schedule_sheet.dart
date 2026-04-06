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

// ─────────────────────────────────────────────

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
                  child: const Icon(Icons.close, size: 22),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Edit Schedule',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Gap(8),

            subjects.isEmpty
                ? const _NoSubjectsHint()
                : _SubjectDropdown(subjects: subjects),

            const Gap(16),

            const Text(
              'Days',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Gap(8),

            const _DayChips(),

            const Gap(16),

            const Text(
              'Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

// ─────────────────────────────────────────────
// SUBJECT DROPDOWN (UNDERLINE STYLE)

class _SubjectDropdown extends StatelessWidget {
  final List<ScheduleSubjectEntity> subjects;

  const _SubjectDropdown({required this.subjects});

  UnderlineInputBorder _border(Color color, {double width = 1}) {
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
          decoration: InputDecoration(
            border: _border(Colors.grey.shade300),
            enabledBorder: _border(Colors.grey.shade300),
            focusedBorder: _border(AppColors.brandBlue, width: 1.5),
          ),
          hint: const Text('Select subject'),
          items: subjects.map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text('${s.code} - ${s.name}'),
            );
          }).toList(),
          onChanged: (s) {
            if (s != null) {
              context.read<AddScheduleBloc>().add(
                    AddScheduleSubjectSelected(s),
                  );
            }
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// DAYS

class _DayChips extends StatelessWidget {
  const _DayChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          children: scheduleDays.map((day) {
            final selected = state.selectedDays.contains(day);

            return GestureDetector(
              onTap: () => context.read<AddScheduleBloc>().add(
                    AddScheduleDayToggled(day),
                  ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      selected ? AppColors.brandBlue : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _dayAbbr[day]!,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
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

// ─────────────────────────────────────────────
// TIME INPUT (MANUAL)

class _TimeRow extends StatelessWidget {
  const _TimeRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: _TimeTextField(
                label: 'Start',
                initialValue: state.startTimeStr,
                onChanged: (t) => context.read<AddScheduleBloc>().add(
                      AddScheduleStartTimeChanged(t),
                    ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.arrow_forward),
            ),
            Expanded(
              child: _TimeTextField(
                label: 'End',
                initialValue: state.endTimeStr,
                onChanged: (t) => context.read<AddScheduleBloc>().add(
                      AddScheduleEndTimeChanged(t),
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TimeTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final Function(TimeOfDay) onChanged;

  const _TimeTextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_TimeTextField> createState() => _TimeTextFieldState();
}

class _TimeTextFieldState extends State<_TimeTextField> {
  late TextEditingController controller;
  bool error = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  void onChange(String val) {
    if (val.length == 2 && !val.contains(':')) {
      controller.text = '$val:';
      controller.selection =
          const TextSelection.collapsed(offset: 3);
    }

    final parts = val.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);

      if (h != null && m != null && h < 24 && m < 60) {
        error = false;
        widget.onChanged(TimeOfDay(hour: h, minute: m));
        setState(() {});
        return;
      }
    }

    error = val.length >= 4;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d:]')),
            LengthLimitingTextInputFormatter(5),
          ],
          onChanged: onChange,
          decoration: InputDecoration(
            errorText: error ? 'Invalid' : null,
            hintText: '00:00',
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// CONFIRM

class _ConfirmButton extends StatelessWidget {
  final int entryId;

  const _ConfirmButton({required this.entryId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      builder: (context, state) {
        return ElevatedButton(
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
          child: const Text('Save Changes'),
        );
      },
    );
  }
}

class _NoSubjectsHint extends StatelessWidget {
  const _NoSubjectsHint();

  @override
  Widget build(BuildContext context) {
    return const Text('No subjects available');
  }
}