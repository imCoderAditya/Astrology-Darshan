/// Logger utility functions for the RoinTech project
library;

import 'dart:developer';

import 'package:flutter/foundation.dart';

class LoggerUtils {
  /// Log a debug message (only in debug mode)
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      // ignore: avoid_print
      log('[DEBUG]${tag != null ? '[$tag]' : ''} $message');
    }
  }

  /// Log an error message (only in debug mode)
  static void error(String message, {String? tag}) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[ERROR]${tag != null ? '[$tag]' : ''} $message');
    }
  }

  /// Log a warning message (only in debug mode)
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[WARNING]${tag != null ? '[$tag]' : ''} $message');
    }
  }
}