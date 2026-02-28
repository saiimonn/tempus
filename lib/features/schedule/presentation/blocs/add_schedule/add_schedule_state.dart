part of 'add_schedule_bloc.dart';

class AddScheduleState {
  final ScheduleSubjectEntity? selectedSubject;
  final Set<String> selectedDays;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const AddScheduleState({
    this.selectedSubject,
    this.selectedDays = const {},
    this.startTime = const TimeOfDay(hour: 7, minute: 30),
    this.endTime = const TimeOfDay(hour: 9, minute: 0),
  });

  bool get timeInvalid {
    final s = startTime.hour * 60 + startTime.minute;
    final e = endTime.hour * 60 + endTime.minute;
    return e <= s;
  }

  bool get isValid =>
      selectedSubject != null && selectedDays.isNotEmpty && !timeInvalid;

  String get startTimeStr {
    final h = startTime.hour.toString().padLeft(2, '0');
    final m = startTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get endTimeStr {
    final h = endTime.hour.toString().padLeft(2, '0');
    final m = endTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  AddScheduleState copyWith({
    ScheduleSubjectEntity? selectedSubject,
    Set<String>? selectedDays,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool clearSubject = false,
  }) {
    return AddScheduleState(
      selectedSubject:
          clearSubject ? null : (selectedSubject ?? this.selectedSubject),
      selectedDays: selectedDays ?? this.selectedDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}