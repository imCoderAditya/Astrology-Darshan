// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:astrology/app/data/models/astrologer/astrologer_model.dart';
import 'package:astrology/app/modules/astrologers/controllers/astrologers_controller.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/components/confirm_dialog_box_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/astrologer_details_controller.dart';

class AstrologerDetailsView extends GetView<AstrologerDetailsController> {
  Astrologer? astrologer;
  AstrologerDetailsView({super.key, this.astrologer});

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      debugPrint(astrologer?.astrologerId.toString());
      final isDark = themeController.isDarkMode.value;
      return GetBuilder<AstrologerDetailsController>(
        init: AstrologerDetailsController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Astrologer Profile',
                style: AppTextStyles.headlineMedium().copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              backgroundColor:
                  isDark ? AppColors.darkSurface : AppColors.primaryColor,
              elevation: 0,
              iconTheme: IconThemeData(
                color: isDark ? AppColors.darkTextPrimary : AppColors.white,
              ),
            ),
            body:
                astrologer == null
                    ? _buildErrorState(isDark)
                    : SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          _buildProfileCard(isDark),
                          SizedBox(height: 16.h),
                          _buildDetailsCard(isDark),
                          SizedBox(height: 16.h),
                          _buildSpecializationsCard(isDark),
                          SizedBox(height: 16.h),
                          _buildStatsCard(isDark),
                          SizedBox(height: 20.h),
                          _buildActionButtons(isDark),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
          );
        },
      );
    });
  }

  Widget _buildErrorState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 64.w,
            color:
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
          SizedBox(height: 16.h),
          Text('Profile not found', style: AppTextStyles.headlineMedium()),
        ],
      ),
    );
  }

  Widget _buildProfileCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 3.w),
            ),
            child: ClipOval(
              child:
                  astrologer!.profilePicture != null
                      ? Image.network(
                        astrologer!.profilePicture!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                _buildDefaultAvatar(),
                      )
                      : _buildDefaultAvatar(),
            ),
          ),
          SizedBox(height: 16.h),

          // Name
          Text(
            "${astrologer?.firstName ?? ""} ${astrologer?.lastName ?? ""}"
                .trim(),
            style: AppTextStyles.headlineLarge().copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),

          // Rating & Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rating
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: AppColors.white, size: 16.w),
                    SizedBox(width: 4.w),
                    Text(
                      '${astrologer!.rating ?? "N/A"}',
                      style: AppTextStyles.caption().copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),

              // Online Status
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color:
                      astrologer!.isOnline == true
                          ? AppColors.sucessPrimary
                          : AppColors.red,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      astrologer!.isOnline == true ? 'Online' : 'Offline',
                      style: AppTextStyles.small().copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About', style: AppTextStyles.headlineMedium()),
          SizedBox(height: 12.h),

          if (astrologer!.bio?.isNotEmpty == true)
            Text(
              astrologer!.bio!,
              style: AppTextStyles.body().copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            )
          else
            Text(
              'Welcome! I am here to guide you through life\'s journey.',
              style: AppTextStyles.body().copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),

          SizedBox(height: 20.h),

          // Experience & Rate Row
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.work_outline,
                      color: AppColors.primaryColor,
                      size: 24.w,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${astrologer!.experience ?? 0} Years',
                      style: AppTextStyles.body().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('Experience', style: AppTextStyles.caption()),
                  ],
                ),
              ),
              Container(
                width: 1.w,
                height: 40.h,
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      color: AppColors.accentColor,
                      size: 24.w,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '₹${astrologer!.consultationRate ?? 0}/min',
                      style: AppTextStyles.body().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('Consultation', style: AppTextStyles.caption()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationsCard(bool isDark) {
    if (astrologer!.specializations?.isEmpty ?? true) return SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Specializations', style: AppTextStyles.headlineMedium()),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children:
                astrologer!.specializations!
                    .map(
                      (spec) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: AppColors.primaryColor),
                        ),
                        child: Text(
                          spec,
                          style: AppTextStyles.body().copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),

          // Languages if available
          if (astrologer!.languages?.isNotEmpty == true) ...[
            SizedBox(height: 20.h),
            Text(
              'Languages',
              style: AppTextStyles.body().copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Text(
              astrologer!.languages!.join(', '),
              style: AppTextStyles.body().copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '${astrologer!.totalConsultations ?? 0}',
                  style: AppTextStyles.headlineLarge().copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Consultations', style: AppTextStyles.caption()),
              ],
            ),
          ),
          Container(
            width: 1.w,
            height: 40.h,
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${astrologer!.totalRatings ?? 0}',
                  style: AppTextStyles.headlineLarge().copyWith(
                    color: AppColors.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Reviews', style: AppTextStyles.caption()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    final astrologersController =
        Get.isRegistered()
            ? Get.find<AstrologersController>()
            : Get.put(AstrologersController());
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
                () =>
                    astrologer?.isAvailableForChat == false
                        ? null
                        : CallChatConfirmationDialog.show(
                          consultationType:  astrologer?.consultationType ??"",
                          context: Get.context!,
                          astrologerPhoto: astrologer?.profilePicture,

                          onConfirm: (value) {
                            Get.back();
                            astrologersController.astrologerBook(
                              endTime: value,
                              astrologerId: astrologer?.astrologerId,
                              type: "Chat",
                              astrologerPhoto: astrologer?.profilePicture,
                            );
                          },
                          onWalletRedirect: () {
                            Get.toNamed(Routes.WALLET);
                          },
                          rate: astrologer?.consultationRate,
                          type: 'Chat',
                          astrologerName:
                              "${astrologer?.firstName ?? ""} ${astrologer?.lastName ?? ""}",
                        ),
            icon: Icon(
              Icons.chat_bubble_outline,
              size: 20.w,
              color: AppColors.white,
            ),
            label: Text(
              'Chat Now',
              style: AppTextStyles.button.copyWith(color: AppColors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  astrologer?.isAvailableForChat == false
                      ? AppColors.white.withValues(alpha: 0.4)
                      : AppColors.primaryColor,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              elevation: 3,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed:
                () =>
                    astrologer?.isAvailableForCall == false
                        ? null
                        : CallChatConfirmationDialog.show(
                          context: Get.context!,
                          consultationType: astrologer?.consultationType ?? "",
                          astrologerPhoto: astrologer?.profilePicture,
                          onConfirm: (value) {
                            Get.back();
                            astrologersController.astrologerBook(
                              endTime: value,
                              astrologerId: astrologer?.astrologerId,
                              astrologerPhoto: astrologer?.profilePicture,
                              type: "Call",
                            );
                          },
                          onWalletRedirect: () {
                            Get.toNamed(Routes.WALLET);
                          },
                          rate: astrologer?.callDpPerMinute ?? 0,
                          type: 'Call',
                          astrologerName:
                              "${astrologer?.firstName ?? ""} ${astrologer?.lastName ?? ""}",
                        ),
            icon: Icon(Icons.videocam, size: 20.w, color: AppColors.white),
            label: Text(
              'Voice Call',
              style: AppTextStyles.button.copyWith(color: AppColors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  astrologer?.isAvailableForCall == false
                      ? AppColors.white.withValues(alpha: 0.5)
                      : AppColors.accentColor,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              elevation: 3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    String initials =
        "${astrologer!.firstName?[0] ?? ""}${astrologer!.lastName?[0] ?? ""}";
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.8),
            AppColors.accentColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: AppTextStyles.brandLogo.copyWith(
            fontSize: 28.sp,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
