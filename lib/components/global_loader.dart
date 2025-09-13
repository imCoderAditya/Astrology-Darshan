
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class GlobalLoader {
  static void show() {
    showDialog(
     context: Get.overlayContext!,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingAnimationWidget.twistingDots(
                  leftDotColor: AppColors.secondaryPrimary,
                  rightDotColor: AppColors.primaryColor,
                  size: 40,
                ),
                const SizedBox(height: 20),
                Text(
                  'Loading...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide() {
    Get.back(); // 👈 this is causing the crash
  }
}
