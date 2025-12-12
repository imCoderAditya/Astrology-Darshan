// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DateOfBirthSelect extends StatefulWidget {
  final Function(String iso8601DateTime)? onDateTimeSelected;
  final bool isDarkMode;

  const DateOfBirthSelect({
    super.key,
    this.onDateTimeSelected,
    this.isDarkMode = false,
  });

  @override
  State<DateOfBirthSelect> createState() => _DateOfBirthSelectState();
}

class _DateOfBirthSelectState extends State<DateOfBirthSelect> with TickerProviderStateMixin {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _buttonController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
    
    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  get primaryColor => AppColors.primaryColor;
  get accentColor => AppColors.accentColor;
  get backgroundColor => widget.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
  get surfaceColor => widget.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface;
  get textPrimary => widget.isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  get textSecondary => widget.isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  get dividerColor => widget.isDarkMode ? AppColors.darkDivider : AppColors.lightDivider;

  bool get isComplete => selectedDate != null && selectedTime != null;

  String? get formattedDate {
    if (selectedDate == null) return null;
    return DateFormat('dd MMM yyyy').format(selectedDate!);
  }

  String? get formattedTime {
    if (selectedTime == null) return null;
    final now = DateTime.now();
    final dt = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    return DateFormat('hh:mm a').format(dt);
  }

  String? get iso8601DateTime {
    if (selectedDate == null || selectedTime == null) return null;

    final dateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final offset = dateTime.timeZoneOffset;
    final offsetHours = offset.inHours.abs().toString().padLeft(2, '0');
    final offsetMinutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final offsetSign = offset.isNegative ? '-' : '+';

    return '${DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime)}$offsetSign$offsetHours:$offsetMinutes';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: AppColors.white,
              surface: surfaceColor,
              onSurface: textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: AppColors.white,
              surface: surfaceColor,
              onSurface: textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _handleContinue() {
    if (isComplete && widget.onDateTimeSelected != null) {
      _buttonController.forward().then((_) {
        _buttonController.reverse();
      });
       Navigator.of(context).pop();
      widget.onDateTimeSelected!(iso8601DateTime!);
     
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.darkBackground,
                        AppColors.darkSurface,
                      ]
                    : [
                        AppColors.lightSurface,
                        AppColors.lightBackground,
                      ],
              ),
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 15),
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: isDark ? AppColors.black.withOpacity(0.6) : AppColors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.all(28.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor,
                            accentColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.5),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.cake_outlined,
                        color: AppColors.white,
                        size: 26.sp,
                      ),
                    ),
                    SizedBox(width: 18.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date & Time of Birth',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                              fontSize: 21.sp,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Select your birth details',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                
                // Date Picker
                _buildPickerCard(
                  icon: Icons.calendar_month_rounded,
                  label: 'Date',
                  value: formattedDate,
                  placeholder: 'Select Date',
                  onTap: () => _selectDate(context),
                  isDark: isDark,
                ),
                
                SizedBox(height: 16.h),
                
                // Time Picker
                _buildPickerCard(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value: formattedTime,
                  placeholder: 'Select Time',
                  onTap: () => _selectTime(context),
                  isDark: isDark,
                ),
                
                SizedBox(height: 28.h),

                // Continue Button
                ScaleTransition(
                  scale: _buttonScale,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isComplete ? _handleContinue : null,
                        borderRadius: BorderRadius.circular(20.r),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 18.h),
                          decoration: BoxDecoration(
                            gradient: isComplete
                                ? LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      primaryColor,
                                      accentColor,
                                    ],
                                  )
                                : LinearGradient(
                                    colors: [
                                      dividerColor.withOpacity(0.3),
                                      dividerColor.withOpacity(0.2),
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: isComplete
                                ? [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                      spreadRadius: 0,
                                    ),
                                    BoxShadow(
                                      color: accentColor.withOpacity(0.3),
                                      blurRadius: 30,
                                      offset: const Offset(0, 12),
                                      spreadRadius: -5,
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: isDark
                                          ? AppColors.black.withOpacity(0.3)
                                          : AppColors.black.withOpacity(0.08),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isComplete
                                    ? Icons.check_circle_rounded
                                    : Icons.lock_rounded,
                                color: isComplete
                                    ? AppColors.white
                                    : textSecondary.withOpacity(0.5),
                                size: 22.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                isComplete ? 'Continue' : 'Select Date & Time',
                                style: TextStyle(
                                  color: isComplete
                                      ? AppColors.white
                                      : textSecondary.withOpacity(0.6),
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              if (isComplete) ...[
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: AppColors.white,
                                  size: 20.sp,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ISO Preview (Optional info)
                if (iso8601DateTime != null) ...[
                  SizedBox(height: 20.h),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 10 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  AppColors.green.withOpacity(0.15),
                                  AppColors.green.withOpacity(0.08),
                                ]
                              : [
                                  AppColors.green.withOpacity(0.08),
                                  AppColors.green.withOpacity(0.04),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.green.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: AppColors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.info_rounded,
                              color: AppColors.green,
                              size: 16.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColors.green.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  AppDateUtils.extractDate(iso8601DateTime, 15),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickerCard({
    required IconData icon,
    required String label,
    required String? value,
    required String placeholder,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final hasValue = value != null;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: isDark
                ? surfaceColor
                : AppColors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: hasValue
                  ? primaryColor.withOpacity(0.6)
                  : dividerColor.withOpacity(0.5),
              width: hasValue ? 2 : 1.5,
            ),
            boxShadow: hasValue
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: isDark
                          ? AppColors.black.withOpacity(0.3)
                          : AppColors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: isDark 
                          ? AppColors.black.withOpacity(0.2) 
                          : AppColors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  gradient: hasValue
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [primaryColor, accentColor],
                        )
                      : LinearGradient(
                          colors: [
                            dividerColor.withOpacity(0.3),
                            dividerColor.withOpacity(0.2),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: hasValue
                      ? [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  icon,
                  color: hasValue
                      ? AppColors.white
                      : textSecondary.withOpacity(0.6),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 18.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      value ?? placeholder,
                      style: TextStyle(
                        color: hasValue
                            ? textPrimary
                            : textSecondary.withOpacity(0.5),
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: hasValue
                    ? primaryColor
                    : dividerColor.withOpacity(0.6),
                size: 26.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}