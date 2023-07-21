// views/setup_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_time_tracker/models/workday.dart';
import 'package:work_time_tracker/providers/time_tracking_provider.dart';

class SetupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setup View')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Weekly Working Hours',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _WeeklyWorkingHoursDisplay(),
            SizedBox(height: 16),
            Expanded(
              child: _WorkingDaysForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyWorkingHoursDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyWorkingHours = _calculateWeeklyWorkingHours(context, ref);
    return Text(
      'Total Hours: $weeklyWorkingHours',
      style: TextStyle(fontSize: 16),
    );
  }

  String _calculateWeeklyWorkingHours(BuildContext context, WidgetRef ref) {
    final List<WorkDay> workDays = ref.read(timeTrackingProvider);
    final Duration totalWorkingHours = workDays.fold(Duration(), (previous, workDay) {
      return previous + (workDay.clockOutTime.difference(workDay.clockInTime) - workDay.breakDuration);
    });

    final hours = totalWorkingHours.inHours;
    final minutes = totalWorkingHours.inMinutes.remainder(60);

    return '$hours hours and $minutes minutes';
  }
}

class _WorkingDaysForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<WorkDay> workDays = ref.read(timeTrackingProvider);

    return ListView.builder(
      itemCount: workDays.length,
      itemBuilder: (context, index) {
        final workDay = workDays[index];
        return _DayWorkingHoursForm(dayOfWeek: workDay.dayOfWeek);
      },
    );
  }
}

class _DayWorkingHoursForm extends ConsumerWidget {
  final String dayOfWeek;

  const _DayWorkingHoursForm({required this.dayOfWeek});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workDays = ref.read(timeTrackingProvider);
    final workDay = workDays.firstWhere((day) => day.dayOfWeek == dayOfWeek);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayOfWeek,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _TimePicker(
              label: 'Clock-in Time',
              initialTime: TimeOfDay.fromDateTime(workDay.clockInTime),
              onTimeChanged: (time) {
                final updatedWorkDays = List<WorkDay>.from(workDays);
                final index = updatedWorkDays.indexWhere((day) => day.dayOfWeek == dayOfWeek);
                updatedWorkDays[index].clockInTime = DateTime(
                  workDay.clockInTime.year,
                  workDay.clockInTime.month,
                  workDay.clockInTime.day,
                  time.hour,
                  time.minute,
                );
                ref.read(timeTrackingProvider.notifier).state = updatedWorkDays;
              },
            ),
            SizedBox(height: 8),
            _TimePicker(
              label: 'Clock-out Time',
              initialTime: TimeOfDay.fromDateTime(workDay.clockOutTime),
              onTimeChanged: (time) {
                final updatedWorkDays = List<WorkDay>.from(workDays);
                final index = updatedWorkDays.indexWhere((day) => day.dayOfWeek == dayOfWeek);
                updatedWorkDays[index].clockOutTime = DateTime(
                  workDay.clockOutTime.year,
                  workDay.clockOutTime.month,
                  workDay.clockOutTime.day,
                  time.hour,
                  time.minute,
                );
                ref.read(timeTrackingProvider.notifier).state = updatedWorkDays;
              },
            ),
            SizedBox(height: 8),
            _TimePicker(
              label: 'Break Duration',
              initialTime: TimeOfDay.fromDateTime(DateTime(0, 1, 1, 0, workDay.breakDuration.inMinutes)),
              onTimeChanged: (time) {
                final updatedWorkDays = List<WorkDay>.from(workDays);
                final index = updatedWorkDays.indexWhere((day) => day.dayOfWeek == dayOfWeek);
                updatedWorkDays[index].breakDuration = Duration(hours: time.hour, minutes: time.minute);
                ref.read(timeTrackingProvider.notifier).state = updatedWorkDays;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  final String label;
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const _TimePicker({
    required this.label,
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );
        if (selectedTime != null) {
          onTimeChanged(selectedTime);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${initialTime.hour.toString().padLeft(2, '0')}:${initialTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 16),
            ),
            Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }
}
