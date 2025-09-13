/// String utility functions for the RoinTech project
library;

class StringUtils {
  /// Check if a string is null, empty, or only whitespace
  static bool isNullOrEmpty(String? s) {
    return s == null || s.trim().isEmpty;
  }

  /// Truncate a string to a maximum length, adding ellipsis if needed
  static String truncate(String s, int maxLength) {
    if (s.length <= maxLength) return s;
    return '${s.substring(0, maxLength)}...';
  }

  /// Convert a string to title case
  static String toTitleCase(String s) {
    if (s.isEmpty) return s;
    return s.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Remove all non-numeric characters from a string
  static String onlyDigits(String s) {
    return s.replaceAll(RegExp(r'[^0-9]'), '');
  }
}