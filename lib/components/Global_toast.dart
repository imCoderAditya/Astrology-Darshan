
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GlobalToast {
  static void showSucess({
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    Get.closeAllSnackbars(); // Optional: avoid stacking
    Get.snackbar(
      'Success',
      '',
      snackStyle: SnackStyle.FLOATING,
      colorText: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      messageText: Text(
        message.capitalize.toString(),
        style: TextStyle(
          color:
              textColor ??
              (isDark ? AppColors.darkBackground : AppColors.lightBackground),
          fontSize: 16,
        ),
      ),
      backgroundColor:
          backgroundColor ??
          (isDark ? AppColors.lightBackground : AppColors.darkBackground),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
      duration: duration,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static void showError({
    required String message,
    Color? backgroundColor,
    String? title,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.closeAllSnackbars(); // Optional: avoid stacking
    Get.snackbar(
      title ?? 'Error',
      '',
      colorText: AppColors.lightBackground,
      messageText: Text(
        message.capitalize.toString(),
        style: TextStyle(color: textColor ?? Colors.white, fontSize: 16),
      ),
      backgroundColor: backgroundColor ?? Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
      duration: duration,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static void montrerSucces({
    // showSuccess -> montrerSucces
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    Get.closeAllSnackbars();
    Get.rawSnackbar(
      messageText: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.sucessPrimary, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message.capitalize.toString(),
              style: TextStyle(
                color:
                    textColor ??
                    (isDark
                        ? AppColors.lightTextPrimary
                        : AppColors.lightBackground),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      backgroundColor:
          backgroundColor ??
          (isDark ? AppColors.lightBackground : AppColors.darkBackground),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
      duration: duration,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static void montrerErreur({
    // showError -> montrerErreur
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.closeAllSnackbars();
    Get.rawSnackbar(
      messageText: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message.capitalize.toString(),
              style: TextStyle(
                color: textColor ?? (Colors.white),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? AppColors.primaryColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
      borderRadius: 12,
      duration: duration,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}
