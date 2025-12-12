// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/core/utils/validator_utils.dart';
import 'package:astrology/components/CustomAddressPickerWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrology/app/modules/astrologyServices/kundali/controllers/kundali_controller.dart';

class KundaliFormView extends GetView<KundaliController> {
  const KundaliFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return GetBuilder<KundaliController>(
      init: KundaliController(),
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
                        _buildInfoCard(context),
                        SizedBox(height: 20.h),
                        _buildFormCard(context),
                        SizedBox(height: 30.h),
                        _buildGenerateButton(context),
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
          'Kundali Details',
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
                  Icons.auto_awesome,
                  size: 150.sp,
                  color: AppColors.white.withOpacity(isDark ? 0.08 : 0.1),
                ),
              ),
              Positioned(
                bottom: 20.h,
                left: 20.w,
                child: Icon(
                  Icons.stars,
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

  Widget _buildInfoCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              'Enter your birth details to generate your personalized Kundali chart',
              style: AppTextStyles.body().copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
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
                Icon(Icons.person, color: AppColors.white, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  'Personal Information',
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
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  icon: Icons.person_outline,
                  color: AppColors.primaryColor,
                  controller: controller.nameController,
                ),
                SizedBox(height: 16.h),
                CustomAddressPickerWidget(
                  focusNode: controller.focusNode,
                  label: 'Birth Place',
                  hint: 'Search for your birth location',
                  icon: Icons.location_on,
                  color: AppColors.primaryColor,
                  controller: controller.addressController,
                  onLocationSelected: (lat, lng, address) {
                    controller.latController.text = lat.toString();
                    controller.lonController.text = lng.toString();
                    debugPrint('Selected: $address, Lat: $lat, Lng: $lng');
                  },
                ),
                SizedBox(height: 16.h),
                _buildDateTimePicker(
                  context,
                  label: 'Date & Time of Birth',
                  icon: Icons.calendar_today,
                  color: AppColors.primaryColor,
                  onTap: () => controller.pickDateTime(context),
                ),
                // SizedBox(height: 16.h),
                // _buildAyanamsaDropdown(context),
                SizedBox(height: 16.h),
                _buildLanguageDropdown(context),
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
            inputFormatters: [FirstLetterUpperCaseFormatter()],
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
                      controller.iso?.value != null
                          ? AppDateUtils.extractDate(controller.iso?.value, 15)
                          : 'Select date and time',
                      style: AppTextStyles.body().copyWith(
                        color:
                            controller.iso?.value != null
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

  // Widget _buildAyanamsaDropdown(BuildContext context) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;
  //   final color = AppColors.primaryColor;

  //   final ayanamsaOptions = {
  //     1: 'Lahiri',
  //     3: 'Raman',
  //     5: 'KP',
  //     27: 'True Chitrapaksha',
  //   };

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Ayanamsa',
  //         style: AppTextStyles.body().copyWith(
  //           fontWeight: FontWeight.w600,
  //           color: color,
  //         ),
  //       ),
  //       SizedBox(height: 8.h),
  //       Obx(() {
  //         return Container(
  //           decoration: BoxDecoration(
  //             color: isDark ? color.withOpacity(0.12) : color.withOpacity(0.05),
  //             borderRadius: BorderRadius.circular(12.r),
  //             border: Border.all(
  //               color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
  //             ),
  //           ),
  //           child: DropdownButtonFormField<int>(
  //             value: controller.selectedAyanamsa.value,
  //             decoration: InputDecoration(
  //               prefixIcon: Icon(Icons.language, color: color),
  //               border: InputBorder.none,
  //               contentPadding: EdgeInsets.symmetric(
  //                 horizontal: 16.w,
  //                 vertical: 16.h,
  //               ),
  //             ),
  //             dropdownColor:
  //                 isDark ? AppColors.darkSurface : AppColors.lightSurface,
  //             style: AppTextStyles.body().copyWith(
  //               color:
  //                   isDark
  //                       ? AppColors.darkTextPrimary
  //                       : AppColors.lightTextPrimary,
  //               fontSize: 16.sp,
  //               fontWeight: FontWeight.w700,
  //             ),
  //             items:
  //                 ayanamsaOptions.entries.map((entry) {
  //                   return DropdownMenuItem<int>(
  //                     value: entry.key,
  //                     child: Text(entry.value),
  //                   );
  //                 }).toList(),
  //             onChanged: (value) {
  //               if (value != null) {
  //                 controller.selectedAyanamsa.value = value;
  //               }
  //             },
  //           ),
  //         );
  //       }),
  //     ],
  //   );
  // }

  Widget _buildLanguageDropdown(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = AppColors.primaryColor;

    final languageOptions = {
      'en': 'English',
      'hi': 'हिंदी (Hindi)',
      // 'ta': 'தமிழ் (Tamil)',
      // 'te': 'తెలుగు (Telugu)',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Language',
          style: AppTextStyles.body().copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? color.withOpacity(0.12) : color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: controller.language?.value,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.translate, color: color),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
              dropdownColor:
                  isDark ? AppColors.darkSurface : AppColors.lightSurface,
              style: AppTextStyles.body().copyWith(
                color:
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              items:
                  languageOptions.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.language?.value = value;
                }
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildGenerateButton(BuildContext context) {
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
                    : () => controller.fetchKundali(),
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
                            Icons.auto_awesome,
                            color: AppColors.white,
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Generate Kundali',
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
