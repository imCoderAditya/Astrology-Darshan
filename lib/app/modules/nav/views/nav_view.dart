// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:astrology/app/modules/astrologers/views/astrologers_view.dart';
import 'package:astrology/app/modules/ecommerce/store/views/store_view.dart';
import 'package:astrology/app/modules/home/views/home_view.dart';
import 'package:astrology/app/modules/nav/controllers/nav_controller.dart';
import 'package:astrology/app/modules/profile/views/profile_view.dart';
import 'package:astrology/app/modules/reels/controllers/reels_controller.dart';
import 'package:astrology/app/modules/reels/views/reels_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NavView extends StatelessWidget {
  NavView({super.key});

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final NavController navController = Get.put(NavController());
    final isDark = themeController.isDarkMode.value;
    final pages = [
      HomeView(),
      AstrologersView(isDrawer: true),
      ReelsView(),
      StoreView(),
      const ProfileView(),
    ];

    return GetBuilder<NavController>(
      init: NavController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          body: Obx(
            () => IndexedStack(
              index: navController.currentIndex.value,
              children: pages,
            ),
          ),
          bottomNavigationBar: Obx(
            () => _buildBottomNavigationBar(navController),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(NavController controller) {
    final isDark = themeController.isDarkMode.value;
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBottomNavItem(Icons.home, 'Home', 0, controller),
          _buildBottomNavItem(Icons.people, 'Astrologers', 1, controller),
          _buildBottomNavItem(null, image: Image.asset("assets/icons/instagram_reels.png",height: 20.h,width: 20.w,
          color:isDark?AppColors.white: controller.currentIndex.value==2? AppColors.white:AppColors.darkBackground,
          
          ), 'Reels', 2, controller),
          _buildBottomNavItem(Icons.store, 'Store', 3, controller),
          _buildBottomNavItem(Icons.account_circle, 'Profile', 4, controller),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    IconData? icon,
 
    String label,
    int index,
    NavController controller,
      { Widget? image,}
  ) {
    bool isActive = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () {
        controller.changeTab(index);
        debugPrint("=======>${index.toString()}");
        if (index == 2) {
          Get.find<ReelsController>().playVideo();
        } else {
          Get.find<ReelsController>().pauseVideo();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient:
                  isActive
                      ? LinearGradient(
                        colors: [AppColors.primaryColor, AppColors.accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                      : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: image?? Icon(
              icon,
              color: isActive ? AppColors.white : AppColors.textSecondaryLight,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.small().copyWith(
              color:
                  isActive
                      ? AppColors.accentColor
                      : (themeController.isDarkMode.value
                          ? AppColors.white
                          : AppColors.darkSurface),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
