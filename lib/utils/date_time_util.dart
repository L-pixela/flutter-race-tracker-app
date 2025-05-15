import 'package:intl/intl.dart';

class DateTimeUtil {
  static String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
  ////
//// Utility class for formatting DateTime objects into human-readable strings.
////

  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == today.subtract(Duration(days: 1))) {
      return 'Yesterday';
    } else if (targetDate == today.add(Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return DateFormat('E d MMM y ').format(dateTime); // Example: Wed 12 Feb
    }
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm')
        .format(dateTime); // Example: 14:30 (24-hour format)
  }
}
