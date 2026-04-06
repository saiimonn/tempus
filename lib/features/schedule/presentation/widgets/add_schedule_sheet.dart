import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/underline_text_field.dart';
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

class AddScheduleSheet extends StatelessWidget {
  final List<ScheduleSubjectEntity> subjects;

  const AddScheduleSheet({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return _AddScheduleSheetBody(subjects: subjects);
  }
}

class _AddScheduleSheetBody extends StatelessWidget {
  final List<ScheduleSubjectEntity> subjects;

  const _AddScheduleSheetBody({required this.subjects});

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
                      'Add Schedule',
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

            _buildLabel('Subjects'),
            const Gap(8),
            subjects.isEmpty
                ? const _NoSubjectsHint()
                : _SubjectDropdown(subjects: subjects),

            const Gap(16),

            _buildLabel('Days'),
            _DayChips(),

            const Gap(16),

            _buildLabel('Time'),
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
  final List<ScheduleSubjectEntity> subjects;

  const _SubjectDropdown({required this.subjects});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      buildWhen: (prev, curr) => prev.selectedSubject != curr.selectedSubject,
      builder: (context, state) {
        final selected = state.selectedSubject;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subjects',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
                letterSpacing: 0.5,
              ),
            ),

            DropdownButtonFormField<ScheduleSubjectEntity>(
              value: selected,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.foreground,
                size: 20,
              ),

              decoration: InputDecoration(
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                isDense: true,
                border: _underlineBorder(Colors.grey.shade300),
                enabledBorder: _underlineBorder(Colors.grey.shade300),
                focusedBorder: _underlineBorder(
                  AppColors.brandBlue,
                  width: 1.5,
                ),
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
              items: subjects.map((subject) {
                return DropdownMenuItem<ScheduleSubjectEntity>(
                  value: subject,
                  child: Text(
                    '${subject.code} - ${subject.name}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis,
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
          ],
        );
      },
    );
  }

  UnderlineInputBorder _underlineBorder(Color color, {double width = 1.0}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _NoSubjectsHint extends StatelessWidget {
  const _NoSubjectsHint();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(
        children: [
          Icon(Icons.info_outline, size: 24, color: AppColors.foreground),
          Text(
            'No subjects yet. Add subjects first in the Subjects tab.',
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddScheduleBloc, AddScheduleState>(
      buildWhen: (prev, curr) =>
          prev.startTime != curr.startTime || prev.endTime != curr.startTime,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: _TimeTextField(
                label: 'Start',
                initialValue: state.startTimeStr,
                onChanged: (time) => context
                  .read<AddScheduleBloc>()
                  .add(AddScheduleStartTimeChanged(time)),
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
              child: _TimeTextField(
                label: 'End',
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

class _TimeTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final void Function(TimeOfDay) onChanged;
  
  const _TimeTextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });
  
  @override
  State<_TimeTextField> createState() => _TimeTextFieldState();
}

class _TimeTextFieldState extends State<_TimeTextField> {
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
      _controller.selection = TextSelection.collapsed(offset: 3);
      value = _controller.text;
    }
    
    TimeOfDay? _parseTime(String value) {
      final parts = value.split(':');
      if(parts.length != 2) return null;
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h == null || m == null) return null;
      if (h < 0 || h > 23 || m < 0 || m > 59) return null;
      return TimeOfDay(hour: h, minute: m);
    }
    
    final parsed = _parseTime(value);
    if(parsed != null) {
      setState(() => _hasError = false);
      widget.onChanged(parsed);
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
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
        
        const Gap(4),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hasError
                ? AppColors.destructive
                : AppColors.inputFill,
            ),
          ),
          
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d:]')),
              LengthLimitingTextInputFormatter(5),
            ],
            
            onChanged: _onChanged,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: '00:00',
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.foreground,
              ),
            ),
          ),
        ),
      ],
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
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isValid ? () => _confirm(context) : null,
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
              'Confirm',
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

  void _confirm(BuildContext context) {
    final bloc = context.read<AddScheduleBloc>();
    final state = bloc.state;

    final subject = state.selectedSubject!;

    context.read<ScheduleBloc>().add(
      ScheduleEntryAddRequested(
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
