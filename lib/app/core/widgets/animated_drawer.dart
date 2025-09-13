
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:animate_do/animate_do.dart';

import 'theme_toggle_button.dart';

class AnimatedDrawer extends StatelessWidget {
  const AnimatedDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SlideInLeft(
      duration: 500.milliseconds,
      child: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 48.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      isDark
                          ? [AppColors.darkSurface, AppColors.darkBackground]
                          : [
                            AppColors.lightSurface,
                            AppColors.primaryColor.withOpacity(0.1),
                          ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  FadeInDown(
                    duration: 600.milliseconds,
                    child: CircleAvatar(
                      radius: 40.r,
                      backgroundColor: AppColors.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 42,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),

            Divider(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              thickness: 0.5,
              height: 1,
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                children: [
                  drawerTile(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () => Get.back(),
                    isDark: isDark,
                    delay: 100,
                  ),
                  drawerTile(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () {
                      Get.back();
                    },
                    isDark: isDark,
                    delay: 200,
                  ),
                  drawerTile(
                    icon: Icons.notifications,
                    title: 'Notification',
                    onTap: () {
                      Get.back();
                    },
                    isDark: isDark,
                    delay: 300,
                  ),
                  drawerTile(
                    icon: Icons.support_agent,
                    title: 'Help Center',
                    onTap: () {
                      Get.back();
                    },
                    isDark: isDark,
                    delay: 400,
                  ),
                  drawerTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      DialogUtils.showLogoutDialog();
                    },
                    isDark: isDark,
                    delay: 500,
                  ),
                ],
              ),
            ),

            // Theme Toggle
            FadeInUp(
              delay: 400.milliseconds,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Mode',
                      style: AppTextStyles.body().copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextPrimary,
                      ),
                    ),
                    const ThemeToggleButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
    required int delay,
  }) {
    return SlideInLeft(
      delay: delay.milliseconds,
      child: ListTile(
        leading: Icon(
          icon,
          color:
              isDark ? AppColors.darkTextSecondary : AppColors.lightTextPrimary,
        ),
        title: Text(
          title,
          style: AppTextStyles.headlineMedium().copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color:
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextPrimary,
          ),
        ),
        onTap: onTap,
        hoverColor: AppColors.primaryColor.withValues(alpha: 0.05),
      ),
    );
  }
}
