// models/work_day.dart
class WorkDay {
  final String dayOfWeek;
  DateTime clockInTime;
  DateTime clockOutTime;
  Duration breakDuration;

  WorkDay({
    required this.dayOfWeek,
    required this.clockInTime,
    required this.clockOutTime,
    required this.breakDuration,
  });
}
