import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ⬅ Add this
import 'app_colors.dart';

class AppTextStyles {       
  static bool _isDark() =>
      Theme.of(Get.context!).brightness == Brightness.dark;

  static TextStyle headlineLarge() => GoogleFonts.poppins(
    fontSize: 24.sp, // ⬅ Responsive
    fontWeight: FontWeight.bold,
    color: _isDark()
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary,
  );

  static TextStyle headlineMedium() => GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: _isDark()
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary,
  );

  static TextStyle subtitle() => GoogleFonts.openSans(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: _isDark()
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary,
  );

  static TextStyle body() => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: _isDark()
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary,
  );

  static TextStyle caption() => GoogleFonts.openSans(
    fontSize: 14.sp,
    color: _isDark()
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary,
  );

  static TextStyle small() => GoogleFonts.openSans(
    fontSize: 10.sp,
    color: _isDark()
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary,
  );

  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle brandLogo = GoogleFonts.playfairDisplay(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    letterSpacing: 1.2,
  );
}
