import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary,),
      titleTextStyle: TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
    ),
    cardColor: AppColors.lightSurface,
    dividerColor: AppColors.lightDivider,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.accentColor,
      surface: AppColors.lightSurface,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
    ),
    cardColor: AppColors.darkSurface,
    dividerColor: AppColors.darkDivider,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.accentColor,
      surface: AppColors.darkSurface,
    ),
  );
}
