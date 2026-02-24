
class ScheduleEntry {
  final int id;
  final int subId;
  final String subjectName;
  final String subjectCode;
  final List<String> days;
  final String startTime;
  final String endTime;

  const ScheduleEntry({
    required this.id,
    required this.subId,
    required this.subjectName,
    required this.subjectCode,
    required this.days,
    required this.startTime,
    required this.endTime,
  });

  ScheduleEntry copyWith({
    int? id,
    int? subId,
    String? subjectName,
    String? subjectCode,
    List<String>? days,
    String? startTime,
    String? endTime,
  }) {
    return ScheduleEntry(
      id: id ?? this.id,
      subId: subId ?? this.subId,
      subjectName: subjectName ?? this.subjectName,
      subjectCode: subjectCode ?? this.subjectCode,
      days: days ?? this.days,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}