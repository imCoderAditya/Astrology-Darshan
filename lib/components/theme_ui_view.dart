import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';


class ThemeUiView extends StatelessWidget {
  const ThemeUiView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color:
                  isDarkMode ? AppColors.darkDivider : AppColors.lightDivider,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isDarkMode
                        ? Colors.black.withValues(alpha: 0.2)
                        : AppColors.lightTextSecondary.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  controller.toggleTheme();
                },
                icon: Icon(
                  Icons.light_mode,
                  color:
                      !isDarkMode
                          ? AppColors.primaryColor
                          : AppColors.darkTextSecondary,
                  size: 20,
                ),
                tooltip: 'Light Mode',
              ),
              Container(
                width: 1,
                height: 20,
                color:
                    isDarkMode ? AppColors.darkDivider : AppColors.lightDivider,
              ),
              IconButton(
                onPressed: () {
                  controller.toggleTheme();
                },
                icon: Icon(
                  Icons.dark_mode,
                  color:
                      isDarkMode
                          ? AppColors.primaryColor
                          : AppColors.lightTextSecondary,
                  size: 20,
                ),
                tooltip: 'Dark Mode',
              ),
            ],
          ),
        );
      },
    );
  }
}
