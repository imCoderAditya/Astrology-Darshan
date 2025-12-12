// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/data/models/kundali/horoscope_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/horoscope_controller.dart';

class HoroscopeDetailView extends GetView<HoroscopeController> {
  const HoroscopeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final map = Get.arguments ?? 'Aries';
    final String sign = map["sign"] ?? '';
    final String dob = map["dob"] ?? '';

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: _buildAppBar(context, isDark, sign, dob),
      body: GetBuilder<HoroscopeController>(
        builder: (controller) {
          final horoscope = controller.horoscopeModel.value;

          if (horoscope == null) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (horoscope.data == null ||
              horoscope.data!.dailyPredictions == null ||
              horoscope.data!.dailyPredictions!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60.sp,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                  ),
                  SizedBox(height: 16.h),
                  Text('No data available', style: AppTextStyles.body()),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () => controller.getHoroscope(sign: sign),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: Text('Retry', style: AppTextStyles.button),
                  ),
                ],
              ),
            );
          }

          return _buildContent(context, isDark, horoscope.data!);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isDark,
    String sign,
    String dob,
  ) {
    return AppBar(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      elevation: 2,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color:
              isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sign, style: AppTextStyles.headlineMedium()),
          Text("Today", style: AppTextStyles.caption()),
        ],
      ),
      actions: [
        Text(
          AppDateUtils.extractDate(controller.getCurrentIsoDateTime(), 5),
          style: AppTextStyles.caption().copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.backgroundDark,
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildContent(BuildContext context, bool isDark, Data data) {
    final dailyPrediction = data.dailyPredictions!.first;

    return RefreshIndicator(
      onRefresh: () async {
        final sign = Get.arguments ?? 'Aries';
        await controller.getHoroscope(sign: sign);
      },
      color: AppColors.primaryColor,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Sign Info Card
            _buildSignInfoCard(dailyPrediction, isDark),

            // Predictions Section
            if (dailyPrediction.predictions != null &&
                dailyPrediction.predictions!.isNotEmpty)
              _buildPredictionsSection(dailyPrediction.predictions!, isDark),

            // Transits Section
            if (dailyPrediction.transits != null &&
                dailyPrediction.transits!.isNotEmpty)
              _buildTransitsSection(dailyPrediction.transits!, isDark),

            // Aspects Section
            if (dailyPrediction.aspects != null &&
                dailyPrediction.aspects!.isNotEmpty)
              _buildAspectsSection(dailyPrediction.aspects!, isDark),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInfoCard(DailyPrediction dailyPrediction, bool isDark) {
    final signInfo = dailyPrediction.signInfo;
    final sign = dailyPrediction.sign;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.headerGradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Unicode Symbol
          if (signInfo?.unicodeSymbol != null)
            Text(signInfo!.unicodeSymbol!, style: TextStyle(fontSize: 60.sp)),
          SizedBox(height: 12.h),

          // Sign Name
          Text(
            sign?.name ?? '',
            style: GoogleFonts.poppins(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),

          // Lord
          if (sign?.lord?.name != null)
            Text(
              'Ruled by ${sign!.lord!.name}',
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          SizedBox(height: 16.h),

          // Sign Properties
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (signInfo?.triplicity != null)
                _buildPropertyChip(signInfo!.triplicity!, Icons.whatshot),
              if (signInfo?.modality != null)
                _buildPropertyChip(signInfo!.modality!, Icons.sync),
              if (signInfo?.quadruplicity != null)
                _buildPropertyChip(signInfo!.quadruplicity!, Icons.star),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: Colors.white),
          SizedBox(width: 4.w),
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsSection(List<Prediction> predictions, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Predictions', style: AppTextStyles.headlineMedium()),
          SizedBox(height: 12.h),
          ...predictions
              .map((pred) => _buildPredictionCard(pred, isDark))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPredictionCard(Prediction prediction, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Badge
          if (prediction.type != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                prediction.type!.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          SizedBox(height: 10.h),

          // Prediction
          if (prediction.prediction != null)
            _buildInfoRow(
              Icons.lightbulb_outline,
              'Prediction',
              prediction.prediction!,
              isDark,
            ),

          // Seek
          if (prediction.seek != null)
            _buildInfoRow(Icons.search, 'Seek', prediction.seek!, isDark),

          // Challenge
          if (prediction.challenge != null)
            _buildInfoRow(
              Icons.warning_amber,
              'Challenge',
              prediction.challenge!,
              isDark,
            ),

          // Insight
          if (prediction.insight != null)
            _buildInfoRow(
              Icons.psychology,
              'Insight',
              prediction.insight!,
              isDark,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String content,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: AppColors.primaryColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  content,
                  style: GoogleFonts.openSans(
                    fontSize: 14.sp,
                    color:
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransitsSection(List<Transit> transits, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Planetary Transits', style: AppTextStyles.headlineMedium()),
          SizedBox(height: 12.h),
          ...transits
              .map((transit) => _buildTransitCard(transit, isDark))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTransitCard(Transit transit, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Row(
        children: [
          // Planet Icon
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.public,
              color: AppColors.accentColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      transit.name ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color:
                            isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                      ),
                    ),
                    if (transit.isRetrograde == true) ...[
                      SizedBox(width: 6.w),
                      Icon(Icons.replay, size: 14.sp, color: AppColors.red),
                      Text(
                        'R',
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'in ${transit.zodiac?.name ?? ''} • House ${transit.houseNumber ?? ''}',
                  style: GoogleFonts.openSans(
                    fontSize: 13.sp,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAspectsSection(List<Aspect> aspects, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Planetary Aspects', style: AppTextStyles.headlineMedium()),
          SizedBox(height: 12.h),
          ...aspects.map((aspect) => _buildAspectCard(aspect, isDark)).toList(),
        ],
      ),
    );
  }

  Widget _buildAspectCard(Aspect aspect, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                aspect.planetOne?.name ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.sync_alt,
                size: 16.sp,
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
              SizedBox(width: 8.w),
              Text(
                aspect.planetTwo?.name ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentColor,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.secondaryPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  aspect.aspect?.name ?? '',
                  style: GoogleFonts.openSans(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (aspect.effect != null) ...[
            SizedBox(height: 8.h),
            Text(
              aspect.effect!,
              style: GoogleFonts.openSans(
                fontSize: 13.sp,
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
