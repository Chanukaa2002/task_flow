import 'package:intl/intl.dart';

/// Date and time utility functions
class DateTimeUtils {
  /// Format date as "MMM d, yyyy" (e.g., "Nov 7, 2023")
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Format date and time as "MMMM d, yyyy 'at' h:mm a" (e.g., "November 6, 2023 at 10:30 AM")
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMMM d, yyyy \'at\' h:mm a').format(dateTime);
  }

  /// Format time as "h:mm a" (e.g., "6:30 PM")
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  /// Format date and time for task display (e.g., "Tomorrow, 6:30 PM (Aug 15, 2024)")
  static String formatTaskDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dayText;
    if (dateOnly == DateTime(now.year, now.month, now.day)) {
      dayText = 'Today';
    } else if (dateOnly == tomorrow) {
      dayText = 'Tomorrow';
    } else {
      dayText = DateFormat('EEEE').format(dateTime);
    }

    final time = formatTime(dateTime);
    final date = DateFormat('MMM d, yyyy').format(dateTime);

    return '$dayText, $time ($date)';
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Get relative time string
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      // Past
      final absDiff = difference.abs();
      if (absDiff.inDays > 0) {
        return '${absDiff.inDays} day${absDiff.inDays > 1 ? 's' : ''} ago';
      } else if (absDiff.inHours > 0) {
        return '${absDiff.inHours} hour${absDiff.inHours > 1 ? 's' : ''} ago';
      } else if (absDiff.inMinutes > 0) {
        return '${absDiff.inMinutes} minute${absDiff.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } else {
      // Future
      if (difference.inDays > 0) {
        return 'in ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
      } else if (difference.inHours > 0) {
        return 'in ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
      } else if (difference.inMinutes > 0) {
        return 'in ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
      } else {
        return 'Now';
      }
    }
  }
}
