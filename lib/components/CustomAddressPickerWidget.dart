import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

class CustomAddressPickerWidget extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Color color;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(double lat, double lng, String address) onLocationSelected;

  const CustomAddressPickerWidget({
    super.key,
    this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    required this.color,
    required this.controller,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
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
            color:
                isDark
                    ? color.withValues(alpha: 0.12)
                    : color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:
                  isDark ? color.withValues(alpha: 0.3) : color
                    ..withValues(alpha: 0.2),
            ),
          ),
          child: GooglePlaceAutoCompleteTextField(
            focusNode: focusNode, // 🔥 ADDED HERE
            textEditingController: controller,
            googleAPIKey: googleApiKey,
            inputDecoration: InputDecoration(
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
            textStyle: AppTextStyles.body().copyWith(
              color:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
            debounceTime: 800,
            countries: ["in"],
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              if (prediction.lat != null && prediction.lng != null) {
                onLocationSelected(
                  double.parse(prediction.lat!),
                  double.parse(prediction.lng!),
                  prediction.description ?? '',
                );
              }
            },
            itemClick: (Prediction prediction) {
              controller.text = prediction.description ?? '';
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description?.length ?? 0),
              );
            },
            itemBuilder: (context, index, Prediction prediction) {
              return Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  border: Border(
                    bottom: BorderSide(
                      color:
                          isDark
                              ? AppColors.darkDivider
                              : AppColors.lightDivider,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: color, size: 20.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        prediction.description ?? "",
                        style: AppTextStyles.body().copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
            seperatedBuilder: Divider(
              height: 0,
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),

            isCrossBtnShown: true,
            containerHorizontalPadding: 0,
            placeType: PlaceType.geocode,
            keyboardType: TextInputType.streetAddress,
          ),
        ),
      ],
    );
  }
}
