// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/modules/astrologyServices/kundaliMatching/controllers/kundali_matching_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KundaliMatchingDetailsView extends GetView<KundaliMatchingController> {
  const KundaliMatchingDetailsView({super.key});

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

            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingState(context);
              }

              final data = controller.matchingDataModel.value?.data;
              if (data == null) {
                return _buildEmptyState(context);
              }

              return CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildMatchScore(context, data.gunaMilan),
                        _buildMessage(context, data.message),
                        _buildPersonsInfo(context, data),
                        _buildGunaDetails(context, data.gunaMilan),
                        _buildMangalDoshaSection(context, data),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final boyName = controller.matchingDataModel.value?.boyName ?? 'Boy';
    final girlName = controller.matchingDataModel.value?.girlName ?? 'Girl';

    return SliverAppBar(
      expandedHeight: 160.h,
      floating: false,
      pinned: true,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(100, 80, 0, 0),
              items: [
                PopupMenuItem(value: 'en', child: Text("English")),
                PopupMenuItem(value: 'hi', child: Text("Hindi")),
              ],
            ).then((value) {
              if (value != null) {
                // Handle language change here
                controller.language.value = value;
                controller.checkMatching();
              }
            });
          },
          icon: const Icon(Icons.language),
        ),
      ],
      iconTheme: IconThemeData(color: AppColors.white),
      backgroundColor:
          isDark
              ? AppColors.primaryColor.withOpacity(0.9)
              : AppColors.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Compatibility Report',
          style: AppTextStyles.headlineMedium().copyWith(
            color: AppColors.white,
            fontSize: 18.sp,
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
                top: 100.h,
                right: 40.w,
                left: 40.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.face_3,
                            color: AppColors.white.withOpacity(0.9),
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            girlName,
                            style: AppTextStyles.body().copyWith(
                              color: AppColors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 30.h),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.face,
                            color: AppColors.white.withOpacity(0.9),
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            boyName,
                            style: AppTextStyles.body().copyWith(
                              color: AppColors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40.h,
                right: -30.w,
                child: Icon(
                  Icons.favorite,
                  size: 150.sp,
                  color: AppColors.white.withOpacity(isDark ? 0.08 : 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryColor,
            strokeWidth: 3,
          ),
          SizedBox(height: 20.h),
          Text(
            'Calculating compatibility...',
            style: AppTextStyles.subtitle().copyWith(
              color:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80.sp,
            color:
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
          SizedBox(height: 20.h),
          Text(
            'No matching data available',
            style: AppTextStyles.subtitle().copyWith(
              color:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchScore(BuildContext context, gunaMilan) {
    if (gunaMilan == null) return SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final totalPoints = gunaMilan.totalPoints ?? 0.0;
    final maxPoints = gunaMilan.maximumPoints ?? 36;
    final percentage = (totalPoints / maxPoints * 100).toInt();

    Color getScoreColor() {
      if (percentage >= 60) return AppColors.green;
      if (percentage >= 40) return AppColors.secondaryPrimary;
      return AppColors.red;
    }

    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? AppColors.black.withOpacity(0.3)
                    : getScoreColor().withOpacity(0.15),
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
                colors: [getScoreColor(), getScoreColor().withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.stars, color: AppColors.white, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  'Match Score',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30.w),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150.w,
                      height: 150.w,
                      child: CircularProgressIndicator(
                        value: totalPoints / maxPoints,
                        strokeWidth: 12,
                        backgroundColor:
                            isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          getScoreColor(),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${totalPoints.toStringAsFixed(1)}',
                          style: AppTextStyles.headlineMedium().copyWith(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            color: getScoreColor(),
                          ),
                        ),
                        Text(
                          'out of $maxPoints',
                          style: AppTextStyles.small().copyWith(
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: getScoreColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '$percentage% Compatible',
                    style: AppTextStyles.headlineMedium().copyWith(
                      color: getScoreColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context, message) {
    if (message == null) return SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.primaryColor, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.type != null)
                  Text(
                    message.type!,
                    style: AppTextStyles.body().copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                if (message.description != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    message.description!,
                    style: AppTextStyles.body().copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonsInfo(BuildContext context, data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final girlInfo = data.girlInfo;
    final boyInfo = data.boyInfo;
    final girlName = controller.matchingDataModel.value?.girlName ?? 'Girl';
    final boyName = controller.matchingDataModel.value?.boyName ?? 'Boy';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                Icon(Icons.people, color: AppColors.white, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  'Individual Details',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Column(
            children: [
              if (girlInfo != null)
                _buildPersonCard(context, girlName, girlInfo, true),
              SizedBox(height: 16.h),
              if (boyInfo != null)
                _buildPersonCard(context, boyName, boyInfo, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonCard(
    BuildContext context,
    String name,
    info,
    bool isGirl,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isGirl ? AppColors.primaryColor : AppColors.accentColor;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.12) : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? color.withOpacity(0.25)
                          : color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isGirl ? Icons.face_3 : Icons.face,
                  color: color,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                name,
                style: AppTextStyles.headlineMedium().copyWith(color: color),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (info.nakshatra != null) ...[
            _buildInfoRow(
              context,
              'Nakshatra',
              '${info.nakshatra!.name} (Pada ${info.nakshatra!.pada})',
              Icons.auto_awesome,
            ),
            SizedBox(height: 8.h),
          ],
          if (info.rasi != null) ...[
            _buildInfoRow(
              context,
              'Rasi',
              info.rasi!.name ?? 'N/A',
              Icons.circle_outlined,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color:
              isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
        ),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: AppTextStyles.small().copyWith(
            fontWeight: FontWeight.w600,
            color:
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.body().copyWith(
              color:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGunaDetails(BuildContext context, gunaMilan) {
    if (gunaMilan?.guna == null || gunaMilan.guna.isEmpty) {
      return SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                colors: [AppColors.accentColor, AppColors.primaryColor],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.analytics, color: AppColors.white, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  'Guna Milan (Ashtakoot)',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: gunaMilan.guna.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final guna = gunaMilan.guna[index];
              return _buildGunaCard(context, guna);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGunaCard(BuildContext context, guna) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final obtainedPoints = guna.obtainedPoints ?? 0.0;
    final maxPoints = guna.maximumPoints ?? 0;
    final percentage = maxPoints > 0 ? (obtainedPoints / maxPoints) : 0.0;

    Color getGunaColor() {
      if (percentage >= 0.8) return AppColors.green;
      if (percentage >= 0.5) return AppColors.secondaryPrimary;
      return AppColors.red;
    }

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color:
            isDark
                ? getGunaColor().withOpacity(0.12)
                : getGunaColor().withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color:
              isDark
                  ? getGunaColor().withOpacity(0.3)
                  : getGunaColor().withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  guna.name ?? 'Unknown',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: getGunaColor(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: getGunaColor(),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${obtainedPoints.toStringAsFixed(1)}/$maxPoints',
                  style: AppTextStyles.body().copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8.h,
              backgroundColor:
                  isDark ? AppColors.darkDivider : AppColors.lightDivider,
              valueColor: AlwaysStoppedAnimation<Color>(getGunaColor()),
            ),
          ),
          if (guna.description != null) ...[
            SizedBox(height: 12.h),
            Text(
              guna.description!,
              style: AppTextStyles.small().copyWith(
                color:
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMangalDoshaSection(BuildContext context, data) {
    final girlDosha = data.girlMangalDoshaDetails;
    final boyDosha = data.boyMangalDoshaDetails;
    final girlName = controller.matchingDataModel.value?.girlName ?? 'Girl';
    final boyName = controller.matchingDataModel.value?.boyName ?? 'Boy';

    if (girlDosha == null && boyDosha == null) return SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? AppColors.black.withOpacity(0.3)
                    : AppColors.red.withOpacity(0.1),
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
                colors: [AppColors.red, AppColors.red.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.white,
                  size: 24.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  'Mangal Dosha Analysis',
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
                if (girlDosha != null)
                  _buildDoshaCard(context, girlName, girlDosha, true),
                if (girlDosha != null && boyDosha != null)
                  SizedBox(height: 16.h),
                if (boyDosha != null)
                  _buildDoshaCard(context, boyName, boyDosha, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoshaCard(
    BuildContext context,
    String name,
    dosha,
    bool isGirl,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasDosha = dosha.hasDosha == true;
    final color = hasDosha ? AppColors.red : AppColors.green;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.12) : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(
                  hasDosha ? Icons.close : Icons.check,
                  color: AppColors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.body().copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      hasDosha ? 'Mangal Dosha Present' : 'No Mangal Dosha',
                      style: AppTextStyles.small().copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (dosha.description != null) ...[
            SizedBox(height: 12.h),
            Text(
              dosha.description!,
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
}
