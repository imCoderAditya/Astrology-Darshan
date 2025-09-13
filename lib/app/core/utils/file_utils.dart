/// File utility functions for the RoinTech project
library;

import 'dart:io';
import 'package:path/path.dart' as p;

class FileUtils {
  /// Get the file extension from a file path or name
  static String getFileExtension(String filePath) {
    return p.extension(filePath).replaceFirst('.', '');
  }

  /// Check if a file exists at the given path
  static Future<bool> fileExists(String filePath) async {
    return await File(filePath).exists();
  }

  /// Delete a file at the given path
  static Future<bool> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      return true;
    }
    return false;
  }

  /// Read the contents of a file as a string
  static Future<String?> readFileAsString(String filePath) async {
    try {
      final file = File(filePath);
      return await file.readAsString();
    } catch (_) {
      return null;
    }
  }
}