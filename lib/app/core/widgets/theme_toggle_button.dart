// Example toggle widget

import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();
    debugPrint(controller.isDarkMode.value.toString());
    return Obx(
      () => Transform.scale(
        scale: 0.8,
        child: Switch(
          value: controller.isDarkMode.value,
          onChanged: (value) => controller.toggleTheme(),
          activeColor: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
