/// Dialog utility functions for the RoinTech project
library;
import 'package:astrology/app/services/storage/local_storage_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtils {
  /// Show a simple info dialog
  static void showInfoDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  /// Show a confirmation dialog with Yes/No
  static Future<bool> showConfirmDialog(String title, String message) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show a loading dialog
  static void showLoading([String? message]) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message ?? 'Loading...'),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hide any open dialog
  static void hideDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static Future<void> showLogoutDialog() async {
    final theme = Theme.of(Get.context!);
    final isDark = theme.brightness == Brightness.dark;

    return showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            title: Text(
              'Logout',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            content: Text(
              'Are you sure you want to logout?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color:
                        isDark ? Colors.blue[200] : theme.colorScheme.primary,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                onPressed: () {
                  LocalStorageService.logout().then((value) {
                    // Get.offAll(LoginView());
                  });
                },
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }
}
