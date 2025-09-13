import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CommonDropdownField<T> extends StatelessWidget {
  final T? value;
  final String label;
  final String hint;
  final IconData icon;
  final List<T> items;
  final String Function(T) getItemLabel;
  final void Function(T?) onChanged;
  final bool isDarkMode;
  final String? Function(T?)? validator;

  const CommonDropdownField({
    super.key,
    required this.value,
    required this.label,
    required this.hint,
    required this.icon,
    required this.items,
    required this.getItemLabel,
    required this.onChanged,
    required this.isDarkMode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Remove duplicates based on the label/display text to handle custom objects
    final Map<String, T> uniqueItemsMap = {};
    for (T item in items) {
      final label = getItemLabel(item);
      if (!uniqueItemsMap.containsKey(label)) {
        uniqueItemsMap[label] = item;
      }
    }
    final uniqueItems = uniqueItemsMap.values.toList();

    // Find a valid value that exists in the unique items list
    T? validValue;
    if (value != null) {
      final valueLabel = getItemLabel(value as T);
      final matchingItems = uniqueItems.where((item) => getItemLabel(item) == valueLabel);
      validValue = matchingItems.isNotEmpty ? matchingItems.first : null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.isEmpty
            ? SizedBox()
            : Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<T>(
          value: validValue,
          onChanged: onChanged,
          validator: validator,
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              size: 20,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            hintText: hint,
            hintStyle: TextStyle(
              color: isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDarkMode ? AppColors.darkDivider : AppColors.lightDivider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDarkMode ? AppColors.darkDivider : AppColors.lightDivider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.accentColor, width: 2),
            ),
          ),
          dropdownColor: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
          style: TextStyle(color: isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary, fontSize: 16.sp),
          items:
              uniqueItems.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    getItemLabel(item),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
