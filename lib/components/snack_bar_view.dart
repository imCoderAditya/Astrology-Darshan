import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarUiView {
  // Success SnackBar with gradient background
  static void showSuccess({
    required String message,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      action:
          actionLabel != null
              ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed ?? () {},
              )
              : null,
    );

    // Wrap with custom background
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: snackBar.content,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        action: snackBar.action,
      ),
    );
  }

  // Error SnackBar with your app's primary color
  static void showError({
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    IconData? icon,
    VoidCallback? onActionPressed,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      action:
          actionLabel != null
              ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed ?? () {},
              )
              : null,
    );

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFDE033F), // Your primary color
                const Color(0xFFDE033F).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDE033F).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: snackBar.content,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        action: snackBar.action,
      ),
    );
  }

  // Warning SnackBar
  static void showWarning({
    required String message,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.warning_amber_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      action:
          actionLabel != null
              ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed ?? () {},
              )
              : null,
    );

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF9800).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: snackBar.content,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        action: snackBar.action,
      ),
    );
  }

  // Info SnackBar with your app's secondary color
  static void showInfo({
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    IconData? icon,
    VoidCallback? onActionPressed,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      action:
          actionLabel != null
              ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed ?? () {},
              )
              : null,
    );

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF001737), // Your secondary color
                const Color(0xFF001737).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF001737).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: snackBar.content,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        action: snackBar.action,
      ),
    );
  }

  // Custom SnackBar with your app's gradient colors
  static void showCustom({
    required String message,
    IconData? icon,
    List<Color>? gradientColors,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final defaultGradient = [
      const Color(0xFFDE033F), // Your primary color
      const Color(0xFF001737), // Your secondary color
    ];

    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      action:
          actionLabel != null
              ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed ?? () {},
              )
              : null,
    );

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors ?? defaultGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (gradientColors?.first ?? defaultGradient.first)
                    .withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: snackBar.content,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        action: snackBar.action,
      ),
    );
  }

  // Quick method using your existing cardGradiantColor
  static void showWithAppGradient({
    required String message,
    IconData? icon = Icons.notifications,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    showCustom(
      message: message,
      icon: icon,
      gradientColors: [
        const Color(0xFFDE033F), // AppColors.primaryColorLight
        const Color(0xFF001737), // AppColors.secondaryColorLight
      ],
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}
