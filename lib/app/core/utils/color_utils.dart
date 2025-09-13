

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ColorUtils {
  /// Convert a hex string (e.g. "#FF5733" or "FF5733") to a Color
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Convert a Color to a hex string (e.g. "#FF5733")
  static String toHex(Color color, {bool leadingHashSign = true}) {
    return '${leadingHashSign ? '#' : ''}'
        '${color.alpha.toRadixString(16).padLeft(2, '0')}'
        '${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}';
  }

  /// Get a color with a given opacity (0.0 to 1.0)
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}