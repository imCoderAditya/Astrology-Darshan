import 'dart:math' as math;

/// Number utility functions for the RoinTech project

class NumberUtils {
  /// Format a number with commas (e.g. 1000000 -> "1,000,000")
  static String formatWithCommas(num number) {
    return number.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Parse a string to int safely, returns null if invalid
  static int? tryParseInt(String s) {
    return int.tryParse(s);
  }

  /// Parse a string to double safely, returns null if invalid
  static double? tryParseDouble(String s) {
    return double.tryParse(s);
  }

  /// Clamp a number between min and max
  static num clamp(num value, num min, num max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  /// Round a double to [fractionDigits] decimal places
  static double roundTo(double value, int fractionDigits) {
    final mod = math.pow(10.0, fractionDigits);
    return ((value * mod).round().toDouble() / mod);
  }
}