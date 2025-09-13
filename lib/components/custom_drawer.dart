// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:astrology/app/modules/profile/controllers/profile_controller.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// --- DrawerController (unchanged, but good to include for completeness) ---
class DrawerController extends GetxController {
  var selectedIndex = 0.obs;

  final List<DrawerItem> drawerItems = [
    DrawerItem(
      icon: Icons.space_dashboard_outlined,
      title: "Dashboard",
      route: "/dashboard",
    ),
    DrawerItem(
      icon: Icons.calendar_today_outlined,
      title: "My Order",
      route: Routes.ORDER_HISTORY,
    ),
    DrawerItem(
      icon: Icons.article_outlined,
      title: "My Puja",
      route: Routes.MY_PUJA,
    ),
    DrawerItem(
      icon: Icons.groups_outlined,
      title: "Call & Chat History",
      route: Routes.USER_REQUEST,
    ),
  ];

  void selectItem(int index) {
    selectedIndex.value = index;
    // You might want to navigate here as well, or keep it in _onItemTap
  }
}

class DrawerItem {
  final IconData icon;
  final String title;
  final String route;

  DrawerItem({required this.icon, required this.title, required this.route});
}

// --- AppDrawer Widget ---
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    final drawerController = Get.put(DrawerController());

    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      final bgColor =
          isDark ? AppColors.darkBackground : AppColors.lightBackground;
      final textColor =
          isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
      final secondaryColor =
          isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

      // Adjusted highlight color logic for better contrast in both themes
      final highlightColor =
          isDark
              ? AppColors.primaryColor.withOpacity(0.35)
              : AppColors.primaryColor.withOpacity(0.18);

      final highlightTextColor =
          isDark ? AppColors.white : AppColors.primaryColor;

      return Drawer(
        clipBehavior:
            Clip.none, // Keep this if you want overflow outside the drawer boundary
        backgroundColor: bgColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        elevation: 16, // Added elevation to the drawer itself
        shadowColor: AppColors.primaryColor.withOpacity(
          0.3,
        ), // Shadow color for the drawer
        child: SingleChildScrollView(
          // <--- Main scrollable content
          child: Column(
            children: [
              // Enhanced Gradient Header
              _buildGradientHeader(isDark, highlightTextColor),

              // Branded App Name with Animation
              _buildBrandSection(highlightTextColor),

              const Divider(
                thickness: 1,
                indent: 25,
                endIndent: 25,
                height: 30,
              ),

              // Main Navigation Section
              _buildSectionHeader("Main Navigation", textColor),
              // Use List.generate to build items
              ...List.generate(
                drawerController.drawerItems.length, // Iterate over all items
                (index) {
                  final item = drawerController.drawerItems[index];
                  return _buildAnimatedNavItem(
                    item: item,
                    index: index,
                    textColor: textColor,
                    highlightColor: highlightColor,
                    highlightTextColor: highlightTextColor,
                    isSelected: drawerController.selectedIndex.value == index,
                    onTap: () => {_onItemTap(index, drawerController)},
                    isDark: isDark,
                  );
                },
              ),

              const Divider(
                thickness: 1,
                indent: 25,
                endIndent: 25,
                height: 30,
              ),

              // Theme Toggle (moved out of _buildAnimatedNavItem as it's a special case)
              _buildThemeToggle(
                themeController,
                textColor,
                highlightColor,
                highlightTextColor,
                secondaryColor,
                isDark,
              ),

              // Logout and Footer
              _buildFooterSection(context, textColor, secondaryColor, isDark),
            ],
          ),
        ),
      );
    });
  }

  // --- Helper Widgets (Refined) ---

  Widget _buildGradientHeader(bool isDark, Color highlightTextColor) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.fromLTRB(25, 80, 20, 35),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.headerGradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Enhanced Avatar with Pulse Animation
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ), // Start from 0 to avoid initial overshooting scale
                duration: const Duration(milliseconds: 1200),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  // Clamp scale value explicitly to prevent overshoot issues
                  final clampedScale = (0.8 + (value * 0.2)).clamp(0.0, 1.0);
                  return Transform.scale(
                    scale: clampedScale,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentColor.withOpacity(
                              value.clamp(0.0, 1.0),
                            ), // Clamping here
                            blurRadius: 20.0 * value,
                            spreadRadius: 4.0 * value,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          gradient: RadialGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue,
                              width: 3,
                            ), // outer border
                          ),
                          child: ClipOval(
                            child: Image.network(
                              controller
                                      .profileModel
                                      .value
                                      ?.data
                                      ?.profilePicture ??
                                  "",
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: Text(
                                    "${controller.profileModel.value?.data?.firstName?[0] ?? ""} ${controller.profileModel.value?.data?.lastName?[0] ?? ""}"
                                            .capitalize ??
                                        "",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.body().copyWith(
                                      color: AppColors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    "${controller.profileModel.value?.data?.firstName?[0] ?? ""} ${controller.profileModel.value?.data?.lastName?[0] ?? ""}"
                                            .capitalize ??
                                        "",
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.body().copyWith(
                                      color: AppColors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ), // Start from 0
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset((1 - value) * 50, 0),
                          child: Opacity(
                            opacity: value.clamp(
                              0.0,
                              1.0,
                            ), // Clamp opacity here
                            child: Text(
                              "${controller.profileModel.value?.data?.firstName ?? ""} ${controller.profileModel.value?.data?.lastName ?? ""}"
                                      .capitalize ??
                                  "",
                              style: AppTextStyles.headlineMedium().copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4.0,
                                    color: Colors.black.withOpacity(
                                      0.5,
                                    ), // No clamp needed here
                                    offset: const Offset(1, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ), // Start from 0
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset((1 - value) * 50, 0),
                          child: Opacity(
                            opacity: value.clamp(
                              0.0,
                              1.0,
                            ), // Clamp opacity here
                            child: Text(
                              controller.profileModel.value?.data?.email ?? "",
                              style: AppTextStyles.caption().copyWith(
                                color: Colors.white.withOpacity(
                                  0.9,
                                ), // No clamp needed here
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBrandSection(Color highlightTextColor) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0), // Start from 0
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0), // Clamp opacity here
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 20, 20, 15),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: highlightTextColor.withOpacity(
                        0.1,
                      ), // No clamp needed here
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: highlightTextColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Astro Darshan",
                    style: AppTextStyles.brandLogo.copyWith(
                      color: highlightTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 20, 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: AppTextStyles.caption().copyWith(
            color: textColor.withOpacity(0.7), // No clamp needed here
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedNavItem({
    required DrawerItem item,
    required int index,
    required Color textColor,
    required Color highlightColor,
    required Color highlightTextColor,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0), // Start from 0
      duration: Duration(
        milliseconds: 300 + (index * 70),
      ), // Slightly adjusted duration for cascade effect
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset((1 - value) * 100, 0),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0), // Clamp opacity here
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? highlightColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border:
                    isSelected
                        ? Border.all(
                          color: highlightTextColor.withOpacity(0.3),
                          width: 1,
                        ) // No clamp needed here
                        : null,
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color:
                                isDark
                                    ? highlightColor.withOpacity(
                                      0.6,
                                    ) // No clamp needed here
                                    : highlightColor.withOpacity(
                                      0.2,
                                    ), // No clamp needed here
                            blurRadius: 15,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                          ),
                        ]
                        : [],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(16),
                  splashColor: highlightColor.withOpacity(
                    0.3,
                  ), // No clamp needed here
                  highlightColor: highlightColor.withOpacity(
                    0.1,
                  ), // No clamp needed here
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? highlightTextColor.withOpacity(
                                      0.15,
                                    ) // No clamp needed here
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            item.icon,
                            color:
                                isSelected
                                    ? highlightTextColor
                                    : AppColors.accentColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: AppTextStyles.body().copyWith(
                              color:
                                  isSelected ? highlightTextColor : textColor,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                              fontSize: 16,
                            ),
                            child: Text(item.title),
                          ),
                        ),
                        if (isSelected)
                          AnimatedScale(
                            duration: const Duration(milliseconds: 300),
                            scale: isSelected ? 1.0 : 0.0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: highlightTextColor.withOpacity(
                                  0.2,
                                ), // No clamp needed here
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.check,
                                color: highlightTextColor,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeToggle(
    ThemeController themeController,
    Color textColor,
    Color highlightColor,
    Color highlightTextColor,
    Color secondaryColor,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => themeController.toggleTheme(),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: AppColors.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "Dark Mode",
                    style: AppTextStyles.body().copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 52,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color:
                        isDark
                            ? AppColors.accentColor
                            : secondaryColor.withOpacity(
                              0.3,
                            ), // No clamp needed here
                    border: Border.all(
                      color:
                          isDark
                              ? AppColors.accentColor
                              : secondaryColor.withOpacity(
                                0.5,
                              ), // No clamp needed here
                      width: 1,
                    ),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    alignment:
                        isDark ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.2,
                            ), // No clamp needed here
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isDark ? Icons.nightlight_round : Icons.wb_sunny,
                        size: 14,
                        color: isDark ? AppColors.accentColor : Colors.orange,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSection(
    BuildContext context,
    Color textColor,
    Color secondaryColor,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.red.withOpacity(0.3), // No clamp needed here
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap:
                    () => _confirmLogout(
                      context,
                      textColor,
                      secondaryColor,
                      isDark,
                    ),
                borderRadius: BorderRadius.circular(16),
                splashColor: AppColors.red.withOpacity(
                  0.1,
                ), // No clamp needed here
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.logout_rounded,
                          color: AppColors.red,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          "Logout",
                          style: AppTextStyles.body().copyWith(
                            color: AppColors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "v1.0.0 • © 2025 Astro Insights",
            style: AppTextStyles.small().copyWith(
              color: secondaryColor.withOpacity(0.6), // No clamp needed here
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _onItemTap(int index, DrawerController drawerController) {
    drawerController.selectItem(index);
    Get.back(); // Close drawer

    final item = drawerController.drawerItems[index];
    Get.toNamed(item.route);
    drawerController.selectedIndex.value = 0;
    // Implement your actual navigation here
    // Get.toNamed(item.route);
  }

  void _confirmLogout(
    BuildContext context,
    Color textColor,
    Color secondaryColor,
    bool isDark,
  ) {
    Get.back(); // Close drawer first
    Get.defaultDialog(
      title: "",
      middleText: "",
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      barrierDismissible: true,
      radius: 20,
      content: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(0.1), // No clamp needed here
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.logout_rounded, color: AppColors.red, size: 48),
            ),
            const SizedBox(height: 20),
            Text(
              "Confirm Logout",
              style: AppTextStyles.headlineMedium().copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Are you sure you want to securely log out from your account?",
              style: AppTextStyles.body().copyWith(color: secondaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Cancel",
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      LocalStorageService.logout().then((value) {
                        Get.offAllNamed(Routes.LOGIN);
                      });
                      // Implement your actual logout logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 8,
                    ),
                    child: Text(
                      "Logout",
                      style: AppTextStyles.button.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
