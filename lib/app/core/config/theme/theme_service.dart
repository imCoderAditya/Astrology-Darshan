
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/app/services/storage/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService {
  ThemeMode getThemeMode() {
    final isDark = LocalStorageService.read(StorageKeys.isDarkMode) ?? false;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool isDarkMode() {
    return getThemeMode() == ThemeMode.dark;
  }

  void switchTheme() {
    final isDark = isDarkMode();
    final newTheme = isDark ? ThemeMode.light : ThemeMode.dark;

    LocalStorageService.write(StorageKeys.isDarkMode, !isDark);
    Get.changeThemeMode(newTheme);
  }
}
