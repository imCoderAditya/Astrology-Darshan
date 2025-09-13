import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/modules/home/controllers/home_controller.dart';
import 'package:astrology/components/custom_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PopupView extends StatelessWidget {
  const PopupView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 210.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child:
                    controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : CustomCachedNetworkImage(imageUrl: controller.popupImageModel.value?.data?.firstOrNull?.imageUrl??""),
              ),

              Positioned(
                top: -16,
                right: -5,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 40.h,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.black.withValues(alpha: 0.8),
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.white,
                      size: 26.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
