/// Date utility functions for the RoinTech project
library;

import 'package:intl/intl.dart';

class AppDateUtils {
  /// Format a DateTime to yyyy-MM-dd
  static String formatToYMD(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  /// Format a DateTime to dd/MM/yyyy
  static String formatToDMY(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  /// Format a DateTime to dd-MM-yyyy hh:mm a
  static String formatToDMYWithTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return "$day-$month-$year $hour:$minute $period";
  }

  /// Parse a string to DateTime (yyyy-MM-dd)
  static DateTime? parseYMD(String date) {
    try {
      final parts = date.split('-');
      if (parts.length != 3) return null;
      return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    } catch (_) {
      return null;
    }
  }

  /// Get the difference in days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    return to.difference(from).inDays;
  }

  static String extractDate(dynamic datetimeString, int formatOption) {
    if (datetimeString.isNotEmpty) {
      DateTime parsed = DateTime.parse(datetimeString).toLocal();

      switch (formatOption) {
        case 1:
          // 12-hour format with AM/PM
          return DateFormat('h:mm a').format(parsed);
        case 2:
          // 24-hour format
          return DateFormat('HH:mm:ss').format(parsed);
        case 3:
          // Short Date (06/19/2025)
          return DateFormat('MM/dd/yyyy').format(parsed);
        case 4:
          // Medium Date (June 19, 2025)
          return DateFormat('MMMM d, y').format(parsed);
        case 5:
          // Long Date (Thursday, June 19, 2025)
          return DateFormat('EEEE, MMMM d, y').format(parsed);
        case 6:
          // ISO 8601
          return parsed.toIso8601String();
        case 7:
          // Day of Week
          return DateFormat('EEEE').format(parsed);
        case 8:
          // Month
          return DateFormat('MMMM').format(parsed);
        case 9:
          // Year
          return DateFormat('y').format(parsed);
        case 10:
          // Time only (with minutes)
          return DateFormat('h:mm a').format(parsed);

        case 11:
          // Short Date (06/19/2025)
          return DateFormat('yyyy/MM/dd').format(parsed);
        case 12:
          // Short Date (06/19/2025) Time
          return DateFormat('yyyy-MM-dd h:mm a').format(parsed);
        case 13:
          // Short Date (06-19-2025)
          return DateFormat('yyyy-MM-dd').format(parsed);

        case 15:
          // Long Date (Thursday, June 19, 2025)
          return DateFormat('EEEE, MMMM d, y h:mm a').format(parsed);
        default:
          return "Unknown format option.";
      }
    } else {
      return "Invalid datetime.";
    }
  }

  static String extractDateTimeFormate(DateTime? dateTime, int formatOption) {
    if (dateTime == null) return "Invalid datetime.";

    switch (formatOption) {
      case 1:
        return DateFormat('h:mm a').format(dateTime); // 12-hour with AM/PM
      case 2:
        return DateFormat('HH:mm:ss').format(dateTime); // 24-hour format
      case 3:
        return DateFormat('MM/dd/yyyy').format(dateTime); // Short date
      case 4:
        return DateFormat('MMMM d, y').format(dateTime); // Medium date
      case 5:
        return DateFormat('EEEE, MMMM d, y').format(dateTime); // Long date
      case 6:
        return dateTime.toIso8601String(); // ISO
      case 7:
        return DateFormat('EEEE').format(dateTime); // Day of week
      case 8:
        return DateFormat('MMMM').format(dateTime); // Month
      case 9:
        return DateFormat('y').format(dateTime); // Year
      case 10:
        return DateFormat('h:mm a').format(dateTime); // Time
      case 11:
        return DateFormat('yyyy/MM/dd').format(dateTime); // yyyy/MM/dd
      case 12:
        return DateFormat('yyyy-MM-dd h:mm a').format(dateTime); // date + time
      case 13:
        return DateFormat('yyyy-MM-dd').format(dateTime); // yyyy-MM-dd
      case 15:
        return DateFormat('EEEE, MMMM d, y h:mm a').format(dateTime); // long date+time
      default:
        return "Unknown format option.";
    }
  }
}
