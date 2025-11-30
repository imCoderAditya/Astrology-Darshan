// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/components/CustomAddressPickerWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/kundali_matching_controller.dart';

class KundaliMatchingView extends GetView<KundaliMatchingController> {
  const KundaliMatchingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return GetBuilder<KundaliMatchingController>(
      init: KundaliMatchingController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: bgColor,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDark
                        ? [
                          AppColors.primaryColor.withOpacity(0.15),
                          AppColors.accentColor.withOpacity(0.1),
                        ]
                        : [
                          AppColors.primaryColor.withOpacity(0.1),
                          AppColors.accentColor.withOpacity(0.05),
                        ],
              ),
            ),
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        _buildGirlSection(context),
                        SizedBox(height: 20.h),
                        _buildMatchingIcon(context),
                        SizedBox(height: 20.h),
                        _buildBoySection(context),
                        SizedBox(height: 30.h),
                        _buildMatchButton(context),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 200.h,
      floating: false,
      pinned: true,
      iconTheme: IconThemeData(color: AppColors.white),
      backgroundColor:
          isDark
              ? AppColors.primaryColor.withOpacity(0.9)
              : AppColors.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Kundali Matching',
          style: AppTextStyles.headlineMedium().copyWith(
            color: AppColors.white,
            fontSize: 20.sp,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isDark
                      ? [
                        AppColors.primaryColor.withOpacity(0.9),
                        AppColors.accentColor.withOpacity(0.8),
                      ]
                      : [AppColors.primaryColor, AppColors.accentColor],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 40.h,
                right: -30.w,
                child: Icon(
                  Icons.favorite,
                  size: 150.sp,
                  color: AppColors.white.withOpacity(isDark ? 0.08 : 0.1),
                ),
              ),
              Positioned(
                bottom: 20.h,
                left: 20.w,
                child: Icon(
                  Icons.people,
                  size: 80.sp,
                  color: AppColors.white.withOpacity(isDark ? 0.12 : 0.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGirlSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? AppColors.black.withOpacity(0.3)
                    : AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.accentColor],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.face_3, color: AppColors.white, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  'Girl\'s Details',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                _buildTextField(
                  context,
                  label: 'Name',
                  hint: 'Enter girl\'s name',
                  icon: Icons.person,
                  color: AppColors.primaryColor,
                  controller: controller.girlNameController,
                ),
                SizedBox(height: 16.h),
                CustomAddressPickerWidget(
                  focusNode: controller.girlFocusNode,
                  label: 'Birth Place',
                  hint: 'Search for a location',
                  icon: Icons.location_on,
                  color: AppColors.primaryColor,
                  controller: controller.girlAddressController,
                  onLocationSelected: (lat, lng, address) {
                    controller.girlLatController.text = lat.toString();
                    controller.girlLonController.text = lng.toString();
                    debugPrint('Selected: $address, Lat: $lat, Lng: $lng');
                  },
                ),
                SizedBox(height: 16.h),
                _buildDateTimePicker(
                  context,
                  label: 'Date & Time of Birth',
                  icon: Icons.calendar_today,
                  color: AppColors.primaryColor,
                  onTap: () => controller.pickGirlDateTime(context),
                  dateTime: controller.girlDob,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoySection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? AppColors.black.withOpacity(0.3)
                    : AppColors.accentColor.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accentColor, AppColors.primaryColor],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.face, color: AppColors.white, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  'Boy\'s Details',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                _buildTextField(
                  context,
                  label: 'Name',
                  hint: 'Enter boy\'s name',
                  icon: Icons.person,
                  color: AppColors.primaryColor,
                  controller: controller.boyNameController,
                ),
                SizedBox(height: 16.h),

                CustomAddressPickerWidget(
                  focusNode: controller.boyFocusNode,
                  label: 'Birth Place',
                  hint: 'Search for a location',
                  icon: Icons.location_on,
                  color: AppColors.primaryColor,
                  controller: controller.boyAddressController,
                  onLocationSelected: (lat, lng, address) {
                    controller.boyLatController.text = lat.toString();
                    controller.boyLonController.text = lng.toString();
                    debugPrint('Selected: $address, Lat: $lat, Lng: $lng');
                  },
                ),
                SizedBox(height: 16.h),
                _buildDateTimePicker(
                  context,
                  label: 'Date & Time of Birth',
                  icon: Icons.calendar_today,
                  color: AppColors.primaryColor,
                  onTap: () => controller.pickBoyDateTime(context),
                  dateTime: controller.boyDob,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String hint,
    required IconData icon,
    required Color color,
    required TextEditingController controller,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body().copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: isDark ? color.withOpacity(0.12) : color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            style: AppTextStyles.body().copyWith(
              color:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.body().copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
              prefixIcon: Icon(icon, color: color),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required Rx<DateTime?> dateTime,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body().copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() {
          return InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color:
                    isDark ? color.withOpacity(0.12) : color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color:
                      isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, color: color),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      dateTime.value != null
                          ? AppDateUtils.extractDate(
                            dateTime.value?.toIso8601String(),
                            5,
                          )
                          : 'Select date and time',
                      style: AppTextStyles.body().copyWith(
                        color:
                            dateTime.value != null
                                ? (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary)
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16.sp, color: color),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMatchingIcon(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.pink, AppColors.pink.withValues(alpha: 0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.pink.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(Icons.favorite, color: AppColors.white, size: 40.sp),
    );
  }

  Widget _buildMatchButton(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.accentColor],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                controller.isLoading.value
                    ? null
                    : () => controller.checkMatching(),
            borderRadius: BorderRadius.circular(16.r),
            child: Center(
              child:
                  controller.isLoading.value
                      ? SizedBox(
                        height: 24.h,
                        width: 24.h,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.stars,
                            color: AppColors.white,
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Check Compatibility',
                            style: AppTextStyles.headlineMedium().copyWith(
                              color: AppColors.white,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ),
      );
    });
  }
}
