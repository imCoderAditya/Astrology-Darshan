// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppColors {
  // Branding Colors
  static Color primaryColor = hexToColor("#57a43e");
  static Color accentColor = hexToColor("#28785b");
  // static const Color primaryColor = Color(0xFF1976D2); // Doctor Blue
  // static const Color accentColor = Color(0xFF00ACC1); // Cyan
  // Success & Alerts
  static Color secondaryPrimary = hexToColor("#57a43e"); // Golden Yellow
  static const Color sucessPrimary = Color(0xFF4CAF50); // Medical Green
  static const Color green = Color(0xFF4CAF50); // Medical Green

  // Light Theme
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // Dark Theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  static const Color darkDivider = Color(0xFF2C2C2C);
  static const Color red = Color.fromARGB(255, 252, 2, 2);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);
  static const Color dividerDark = Color(0xFF2C2C2C);

  // Light Mode Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color dividerLight = Color(0xFFE0E0E0);

  static List<Color> get headerGradientColors => [AppColors.primaryColor, AppColors.accentColor];
}

Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

Future<Color> getDominantColorFromUrl(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Image load failed with status: ${response.statusCode}');
    }

    final Uint8List bytes = response.bodyBytes;
    final ui.Image image = await decodeImageFromList(bytes);

    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return Colors.grey;

    final Uint8List pixels = byteData.buffer.asUint8List();

    // Ensure we have enough pixels
    if (pixels.length < 4) return Colors.grey;

    // Use a map to count color frequency for true dominant color
    Map<int, int> colorCount = {};

    // Sample every 16th pixel (4 bytes per pixel × 4) for better performance
    final sampleRate = 16;

    for (int i = 0; i < pixels.length - 3; i += sampleRate) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];

      // Skip nearly transparent pixels
      if (pixels[i + 3] < 128) continue;

      // Group similar colors (reduce precision to avoid too many unique colors)
      final simplifiedColor = ((r ~/ 16) << 16) | ((g ~/ 16) << 8) | (b ~/ 16);
      colorCount[simplifiedColor] = (colorCount[simplifiedColor] ?? 0) + 1;
    }

    if (colorCount.isEmpty) return Colors.grey;

    // Find the most frequent color
    final dominantColor = colorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Convert back to full RGB values
    final r = ((dominantColor >> 16) & 0xFF) * 16;
    final g = ((dominantColor >> 8) & 0xFF) * 16;
    final b = (dominantColor & 0xFF) * 16;

    return Color.fromARGB(255, r, g, b);
  } catch (e) {
    debugPrint('Error in getDominantColorFromUrl: $e');
    return Colors.grey;
  }
}

// Alternative: Simple average method (your original approach, improved)
Future<Color> getAverageColorFromUrl(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Image load failed with status: ${response.statusCode}');
    }

    final Uint8List bytes = response.bodyBytes;
    final ui.Image image = await decodeImageFromList(bytes);

    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return Colors.grey;

    final Uint8List pixels = byteData.buffer.asUint8List();

    if (pixels.length < 4) return Colors.grey;

    int r = 0, g = 0, b = 0, count = 0;

    // Sample every 16th pixel for better performance
    for (int i = 0; i < pixels.length - 3; i += 16) {
      // Skip nearly transparent pixels
      if (pixels[i + 3] < 128) continue;

      r += pixels[i];
      g += pixels[i + 1];
      b += pixels[i + 2];
      count++;
    }

    if (count == 0) return Colors.grey;

    return Color.fromARGB(255, r ~/ count, g ~/ count, b ~/ count);
  } catch (e) {
    debugPrint('Error in getAverageColorFromUrl: $e');
    return Colors.grey;
  }
}
