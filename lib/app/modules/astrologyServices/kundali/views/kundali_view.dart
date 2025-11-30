// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/data/models/kundali/kundali_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/kundali_controller.dart';

class KundaliView extends GetView<KundaliController> {
  const KundaliView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;

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
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return _buildLoadingState(context);
                    }

                    if (controller.kundaliModel.value == null &&
                        controller.isLoading.value) {
                      return _buildLoadingState(context);
                    }

                    final data = controller.kundaliModel.value;
                    if (data == null) {
                      return _buildEmptyState(context);
                    }

                    return Column(
                      children: [
                        // Header with name
                        if (data.name != null)
                          _buildNameHeader(context, data.name!),

                        // Nakshatra Section
                        _buildNakshatraSection(
                          context,
                          data.kundliData?.data?.nakshatraDetails,
                        ),

                        // Mangal Dosha Section
                        _buildMangalDoshaSection(
                          context,
                          data.kundliData?.data?.mangalDosha,
                        ),

                        // Yoga Section
                        _buildYogaSection(
                          context,
                          data.kundliData?.data?.yogaDetails,
                        ),

                        // Dasha Balance Section
                        _buildDashaBalanceSection(
                          context,
                          data.kundliData?.data?.dashaBalance,
                        ),

                        // Dasha Periods Section
                        _buildDashaPeriodsSection(
                          context,
                          data.kundliData?.data?.dashaPeriods,
                        ),

                        SizedBox(height: 20.h),
                      ],
                    );
                  }),
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
      expandedHeight: 180.h,
      floating: false,
      pinned: true,
      iconTheme: const IconThemeData(color: Colors.white),
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
                controller.language?.value = value;
                controller.fetchKundali();
              }
            });
          },
          icon: const Icon(Icons.language),
        ),
        IconButton(
          onPressed: () {
            controller.pickDateTime(context);
          },
          icon: const Icon(Icons.date_range),
        ),
      ],
      backgroundColor:
          isDark
              ? AppColors.primaryColor.withOpacity(0.9)
              : AppColors.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Your Kundali',
          style: AppTextStyles.headlineMedium().copyWith(
            color: Colors.white,
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
                  color: Colors.white.withOpacity(isDark ? 0.08 : 0.1),
                ),
              ),
              Positioned(
                bottom: 20.h,
                left: 20.w,
                child: Icon(
                  Icons.stars,
                  size: 80.sp,
                  color: Colors.white.withOpacity(isDark ? 0.12 : 0.15),
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

    return Container(
      height: 500.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryColor,
            strokeWidth: 3,
          ),
          SizedBox(height: 20.h),
          Text(
            'Loading your Kundali...',
            style: AppTextStyles.subtitle().copyWith(
              color: isDark ? Colors.white70 : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 500.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80.sp,
            color: isDark ? Colors.white30 : AppColors.lightTextSecondary,
          ),
          SizedBox(height: 20.h),
          Text(
            'No Kundali data available',
            style: AppTextStyles.subtitle().copyWith(
              color: isDark ? Colors.white70 : null,
            ),
          ),
          SizedBox(height: 10.h),
          MaterialButton(
            color: Colors.green,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onPressed: () => controller.pickDateTime(context),
            child: Text("Select Date", style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  // Name Header Widget
  Widget _buildNameHeader(BuildContext context, String name) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.8),
            AppColors.accentColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: Colors.white, size: 28.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kundali For',
                  style: AppTextStyles.caption().copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  name,
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Nakshatra Section
  Widget _buildNakshatraSection(
    BuildContext context,
    NakshatraDetails? nakshatraDetails,
  ) {
    if (nakshatraDetails == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.3)
                    : AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                Icon(Icons.star, color: Colors.white, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  'Nakshatra Details',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                if (nakshatraDetails.nakshatra != null)
                  _buildInfoCard(
                    context,
                    icon: Icons.auto_awesome,
                    title: 'Nakshatra',
                    value: nakshatraDetails.nakshatra!.name ?? 'N/A',
                    subtitle:
                        'Lord: ${nakshatraDetails.nakshatra!.lord?.vedicName ?? nakshatraDetails.nakshatra!.lord?.name ?? 'N/A'} • Pada: ${nakshatraDetails.nakshatra!.pada ?? 'N/A'}',
                    color: AppColors.primaryColor,
                  ),
                SizedBox(height: 12.h),
                if (nakshatraDetails.chandraRasi != null)
                  _buildInfoCard(
                    context,
                    icon: Icons.nightlight_round,
                    title: 'Chandra Rasi (Moon Sign)',
                    value: nakshatraDetails.chandraRasi!.name ?? 'N/A',
                    subtitle:
                        'Lord: ${nakshatraDetails.chandraRasi!.lord?.vedicName ?? nakshatraDetails.chandraRasi!.lord?.name ?? 'N/A'}',
                    color: Colors.blue,
                  ),
                SizedBox(height: 12.h),
                if (nakshatraDetails.sooryaRasi != null)
                  _buildInfoCard(
                    context,
                    icon: Icons.wb_sunny,
                    title: 'Soorya Rasi (Sun Sign)',
                    value: nakshatraDetails.sooryaRasi!.name ?? 'N/A',
                    subtitle:
                        'Lord: ${nakshatraDetails.sooryaRasi!.lord?.vedicName ?? nakshatraDetails.sooryaRasi!.lord?.name ?? 'N/A'}',
                    color: Colors.orange,
                  ),
                SizedBox(height: 12.h),
                if (nakshatraDetails.zodiac != null)
                  _buildInfoCard(
                    context,
                    icon: Icons.circle_outlined,
                    title: 'Zodiac Sign',
                    value: nakshatraDetails.zodiac!.name ?? 'N/A',
                    subtitle: 'Western Astrology',
                    color: Colors.purple,
                  ),
                if (nakshatraDetails.additionalInfo != null) ...[
                  SizedBox(height: 20.h),
                  _buildAdditionalInfo(
                    context,
                    nakshatraDetails.additionalInfo!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.12) : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? color.withOpacity(0.25) : color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption().copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: isDark ? Colors.white : null,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: AppTextStyles.small().copyWith(
                    color: isDark ? Colors.white60 : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(
    BuildContext context,
    AdditionalInfo additionalInfo,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> infoList = [
      {
        'label': 'Deity',
        'value': additionalInfo.deity,
        'icon': Icons.temple_hindu,
      },
      {'label': 'Ganam', 'value': additionalInfo.ganam, 'icon': Icons.people},
      {
        'label': 'Symbol',
        'value': additionalInfo.symbol,
        'icon': Icons.category,
      },
      {
        'label': 'Animal Sign',
        'value': additionalInfo.animalSign,
        'icon': Icons.pets,
      },
      {'label': 'Nadi', 'value': additionalInfo.nadi, 'icon': Icons.air},
      {'label': 'Color', 'value': additionalInfo.color, 'icon': Icons.palette},
      {
        'label': 'Direction',
        'value': additionalInfo.bestDirection,
        'icon': Icons.explore,
      },
      {
        'label': 'Birth Stone',
        'value': additionalInfo.birthStone,
        'icon': Icons.diamond,
      },
      {'label': 'Gender', 'value': additionalInfo.gender, 'icon': Icons.person},
      {
        'label': 'Syllables',
        'value': additionalInfo.syllables,
        'icon': Icons.text_fields,
      },
      {
        'label': 'Enemy Yoni',
        'value': additionalInfo.enemyYoni,
        'icon': Icons.warning,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          thickness: 1,
          color: isDark ? Colors.white12 : AppColors.lightDivider,
        ),
        SizedBox(height: 12.h),
        Text(
          'Additional Information',
          style: AppTextStyles.headlineMedium().copyWith(
            color: isDark ? Colors.white : null,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            top: 10.h,
            bottom: 10.h,
          ),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
          ),
          itemCount: infoList.length,
          itemBuilder: (context, index) {
            final item = infoList[index];
            if (item['value'] == null || item['value'].toString().isEmpty) {
              return const SizedBox.shrink();
            }
            return _buildGridItem(
              context,
              item['label'],
              item['value'].toString(),
              item['icon'],
            );
          },
        ),
      ],
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? Colors.white12 : AppColors.lightDivider,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color:
                isDark
                    ? AppColors.accentColor.withOpacity(0.8)
                    : AppColors.accentColor,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.small().copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: AppTextStyles.caption().copyWith(
                    color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mangal Dosha Section
  Widget _buildMangalDoshaSection(
    BuildContext context,
    MangalDosha? mangalDosha,
  ) {
    if (mangalDosha == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final hasDosha = mangalDosha.hasDosha ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.3)
                    : (hasDosha ? Colors.red : Colors.green).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                colors:
                    hasDosha
                        ? [Colors.red.shade400, Colors.red.shade600]
                        : [Colors.green.shade400, Colors.green.shade600],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  hasDosha ? Icons.warning_rounded : Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  'Mangal Dosha',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: (hasDosha ? Colors.red : Colors.green).withOpacity(
                      isDark ? 0.15 : 0.05,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: (hasDosha ? Colors.red : Colors.green)
                              .withOpacity(isDark ? 0.25 : 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          hasDosha ? Icons.close : Icons.check,
                          color: hasDosha ? Colors.red : Colors.green,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasDosha ? 'Dosha Present' : 'No Dosha',
                              style: AppTextStyles.headlineMedium().copyWith(
                                color: hasDosha ? Colors.red : Colors.green,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              mangalDosha.description ?? 'No description',
                              style: AppTextStyles.body().copyWith(
                                color: isDark ? Colors.white70 : null,
                              ),
                            ),
                            if (mangalDosha.hasException == true) ...[
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.blue,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Has Exceptions',
                                      style: AppTextStyles.small().copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (mangalDosha.remedies != null &&
                    mangalDosha.remedies!.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  _buildRemediesSection(context, mangalDosha.remedies!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemediesSection(BuildContext context, List<dynamic> remedies) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color:
            isDark ? const Color(0xFF2A2A2A) : Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.orange.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.healing, color: Colors.orange, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Remedies',
                style: AppTextStyles.headlineMedium().copyWith(
                  color: Colors.orange,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...remedies.map(
            (remedy) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: Colors.orange, size: 16.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      remedy.toString(),
                      style: AppTextStyles.body().copyWith(
                        color: isDark ? Colors.white70 : null,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Yoga Section
  Widget _buildYogaSection(
    BuildContext context,
    List<YogaDetail>? yogaDetails,
  ) {
    if (yogaDetails == null || yogaDetails.isEmpty) {
      return SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.3)
                    : AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                colors: [Colors.purple.shade400, Colors.purple.shade600],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.self_improvement, color: Colors.white, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  'Yoga Details',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: yogaDetails.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final yoga = yogaDetails[index];
              return _buildYogaCard(context, yoga, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildYogaCard(BuildContext context, YogaDetail yoga, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colors = [
      Colors.purple,
      Colors.indigo,
      Colors.teal,
      Colors.pink,
      Colors.deepOrange,
    ];
    final color = colors[index % colors.length];

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
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? color.withOpacity(0.25)
                          : color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.spa, color: color, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  yoga.name ?? 'Unknown Yoga',
                  style: AppTextStyles.headlineMedium().copyWith(color: color),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            yoga.description ?? 'No description available',
            style: AppTextStyles.body().copyWith(
              height: 1.5,
              color: isDark ? Colors.white70 : null,
              fontSize: 14.sp,
            ),
          ),
          if (yoga.yogaList != null && yoga.yogaList!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            ...yoga.yogaList!.map(
              (yogaItem) => _buildYogaListItem(context, yogaItem, color),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildYogaListItem(
    BuildContext context,
    YogaList yogaItem,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasYoga = yogaItem.hasYoga ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 7.w),
      decoration: BoxDecoration(
        color:
            isDark
                ? (hasYoga
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1))
                : (hasYoga
                    ? Colors.green.withOpacity(0.05)
                    : Colors.grey.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color:
              hasYoga
                  ? Colors.green.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            hasYoga ? Icons.check_circle : Icons.cancel,
            color: hasYoga ? Colors.green : Colors.grey,
            size: 18.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  yogaItem.name ?? 'Unknown',
                  style: AppTextStyles.body().copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : null,
                    fontSize: 14.sp,
                  ),
                ),
                if (yogaItem.description != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    yogaItem.description!,
                    style: AppTextStyles.small().copyWith(
                      color: isDark ? Colors.white60 : Colors.grey.shade700,
                      fontSize: 14.sp,
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

  // Dasha Balance Section
  Widget _buildDashaBalanceSection(
    BuildContext context,
    DashaBalance? dashaBalance,
  ) {
    if (dashaBalance == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.deepPurple.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                colors: [
                  Colors.deepPurple.shade400,
                  Colors.deepPurple.shade600,
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.timelapse, color: Colors.white, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  'Current Dasha Balance',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? Colors.deepPurple.withOpacity(0.12)
                        : Colors.deepPurple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color:
                      isDark
                          ? Colors.deepPurple.withOpacity(0.3)
                          : Colors.deepPurple.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? Colors.deepPurple.withOpacity(0.25)
                                  : Colors.deepPurple.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.public,
                          color: Colors.deepPurple,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lord',
                              style: AppTextStyles.caption().copyWith(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              dashaBalance.lord?.vedicName?.toString() ??
                                  dashaBalance.lord?.name?.toString() ??
                                  'N/A',
                              style: AppTextStyles.headlineMedium().copyWith(
                                color: isDark ? Colors.white : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (dashaBalance.duration != null) ...[
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.deepPurple,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Duration: ${dashaBalance.duration}',
                          style: AppTextStyles.body().copyWith(
                            color: isDark ? Colors.white70 : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (dashaBalance.description != null) ...[
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? const Color(0xFF2A2A2A)
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        dashaBalance.description!,
                        style: AppTextStyles.body().copyWith(
                          color: isDark ? Colors.white70 : null,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dasha Periods Section
  Widget _buildDashaPeriodsSection(
    BuildContext context,
    List<DashaPeriod>? dashaPeriods,
  ) {
    if (dashaPeriods == null || dashaPeriods.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.cyan.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                colors: [Colors.cyan.shade400, Colors.cyan.shade600],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.timeline, color: Colors.white, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  'Dasha Periods (Mahadasha)',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dashaPeriods.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final dasha = dashaPeriods[index];
              return _buildDashaPeriodCard(context, dasha, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashaPeriodCard(
    BuildContext context,
    DashaPeriod dasha,
    int index,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colors = [
      Colors.cyan,
      Colors.blue,
      Colors.indigo,
      Colors.teal,
      Colors.lightBlue,
    ];
    final color = colors[index % colors.length];

    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 10.w),
      // childrenPadding: EdgeInsets.only(left: 16.w, top: 8.h),
      backgroundColor:
          isDark ? color.withOpacity(0.08) : color.withOpacity(0.03),
      collapsedBackgroundColor:
          isDark ? color.withOpacity(0.08) : color.withOpacity(0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
        ),
      ),
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: isDark ? color.withOpacity(0.25) : color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(Icons.public, color: color, size: 20.sp),
      ),
      title: Text(
        dasha.name?.toString() ?? 'Unknown',
        style: AppTextStyles.body().copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
          if (dasha.start != null && dasha.end != null)
            Text(
              '${_formatDate(dasha.start!)} - ${_formatDate(dasha.end!)}',
              style: AppTextStyles.small().copyWith(
                color: isDark ? Colors.white60 : Colors.grey.shade600,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
      children: [
        if (dasha.antardasha != null && dasha.antardasha!.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.only(bottom: 8.h, left: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Antardasha Periods',
                  style: AppTextStyles.caption().copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                SizedBox(height: 8.h),
                ...dasha.antardasha!.map(
                  (antardasha) => _buildSubDashaItem(
                    context,
                    antardasha,
                    color.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubDashaItem(
    BuildContext context,
    DashaPeriod subDasha,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.1) : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.fiber_manual_record, color: color, size: 12.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subDasha.name?.toString() ?? 'Unknown',
                  style: AppTextStyles.body().copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : null,
                    fontSize: 14.sp,
                  ),
                ),
                if (subDasha.start != null && subDasha.end != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    '${_formatDate(subDasha.start!)} - ${_formatDate(subDasha.end!)}',
                    style: AppTextStyles.small().copyWith(
                      color: isDark ? Colors.white : Colors.grey.shade600,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
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

  String _formatDate(DateTime date) {
    return AppDateUtils.extractDate(
      date.toIso8601String(),
      5,
    ); //'${date.day}/${date.month}/${date.year}';
  }
}
