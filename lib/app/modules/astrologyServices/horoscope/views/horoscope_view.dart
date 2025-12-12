import 'dart:developer';

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/modules/astrologyServices/components/date_of_birth_select.dart';
import 'package:astrology/app/modules/astrologyServices/horoscope/views/horoscope_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/horoscope_controller.dart';

class HoroscopeView extends GetView<HoroscopeController> {
  const HoroscopeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, String>> zodiacSigns = [
      {'name': 'Aries', 'image': 'Aries', 'hindi': 'मेष'},
      {'name': 'Taurus', 'image': 'taurus', 'hindi': 'वृष'},
      {'name': 'Gemini', 'image': 'gemini', 'hindi': 'मिथुन'},
      {'name': 'Cancer', 'image': 'Cancer', 'hindi': 'कर्क'},
      {'name': 'Leo', 'image': 'Leo', 'hindi': 'सिंह'},
      {'name': 'Virgo', 'image': 'Virgo', 'hindi': 'कन्या'},
      {'name': 'Libra', 'image': 'LIBRA', 'hindi': 'तुला'},
      {'name': 'Scorpio', 'image': 'Scorpio', 'hindi': 'वृश्चिक'},
      {'name': 'Sagittarius', 'image': 'Saggitarious', 'hindi': 'धनु'},
      {'name': 'Capricorn', 'image': 'Capricorn', 'hindi': 'मकर'},
      {'name': 'Aquarius', 'image': 'Aquarious', 'hindi': 'कुंभ'},
      {'name': 'Pisces', 'image': 'pisces', 'hindi': 'मीन'},
    ];

    return GetBuilder<HoroscopeController>(
      init: HoroscopeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: AppBar(
            backgroundColor:
                isDark ? AppColors.darkSurface : AppColors.lightSurface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color:
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
              ),
              onPressed: () => Get.back(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Horoscope", style: AppTextStyles.headlineMedium()),
                Text("Today", style: AppTextStyles.caption()),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: GridView.builder(
            padding: EdgeInsets.all(8.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemCount: zodiacSigns.length,
            itemBuilder: (context, index) {
              final sign = zodiacSigns[index];
              return _buildZodiacCard(
                context,
                sign['name']!,
                sign['image']!,
                sign['hindi']!,
                isDark,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildZodiacCard(
    BuildContext context,
    String englishName,
    String imagePath,
    String hindiName,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => DateOfBirthSelect(
                isDarkMode: isDark, // or true for dark mode

                onDateTimeSelected: (iso8601DateTime) {
                  Get.to(
                    HoroscopeDetailView(),
                    arguments: {
                      "sign": englishName,
                      "dob": AppDateUtils.extractDate(iso8601DateTime, 12),
                    },
                  );
                  log('Selected DateTime: $iso8601DateTime');
                  controller.getHoroscope(
                    sign: englishName.toString(),
                    dob: iso8601DateTime,
                  );
                },
              ),
        );
      
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border.all(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Zodiac Icon
            Container(
              height: 80.h,
              width: 80.w,
              padding: EdgeInsets.all(12.w),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  'assets/icons/$imagePath.jpg',
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback icon if image not found
                    return Icon(
                      Icons.stars,
                      size: 50.sp,
                      color: AppColors.primaryColor,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 4.h),
            // Zodiac Name in Hindi
            Text(
              hindiName,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color:
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            // English Name
            Text(
              englishName,
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
