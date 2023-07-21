// providers/time_tracking_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_time_tracker/models/workday.dart';

final timeTrackingProvider = StateNotifierProvider<TimeTrackingNotifier, List<WorkDay>>((ref) {
  return TimeTrackingNotifier();
});

class TimeTrackingNotifier extends StateNotifier<List<WorkDay>> {
  TimeTrackingNotifier() : super(List<WorkDay>.generate(7, (index) => _getDefaultWorkDay(index)));

  static WorkDay _getDefaultWorkDay(int index) {
    return WorkDay(
      dayOfWeek: _getDayOfWeek(index),
      clockInTime: DateTime.now(), // Provide default values for clockInTime, clockOutTime, and breakDuration
      clockOutTime: DateTime.now().add(Duration(hours: 8)), // Example: Assuming 8 hours of work per day
      breakDuration: Duration(minutes: 45), // Example: Assuming 30 minutes of break per day
    );
  }

  static String _getDayOfWeek(int index) {
    // Returns the day of the week based on the index (0 for Monday, 1 for Tuesday, and so on)
    // You can customize this based on the user's locale if needed.
    final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return daysOfWeek[index];
  }
}
