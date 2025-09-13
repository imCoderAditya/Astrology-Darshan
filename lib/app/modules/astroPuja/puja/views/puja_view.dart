// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/modules/astroPuja/pujaDetails/views/puja_details_view.dart';
import 'package:astrology/components/custom_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/puja_controller.dart';

class PujaView extends GetView<PujaController> {
  const PujaView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<PujaController>(
      init: PujaController(),
      builder: (controller) {
        final category = controller.pujaCategoryModel.value;
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          body: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              // Enhanced App Bar with gradient
              SliverAppBar(
                expandedHeight: 260.h,
                backgroundColor: Colors.transparent,
                pinned: true,
                elevation: 0,
                title: Text("Puja Booking", style: AppTextStyles.body()),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  onPressed: () => Get.back(),
                ),
                actions: [
                  // You can add a filter or profile icon here if needed
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.headerGradientColors,
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Space from top
                          SizedBox(height: 50.h),

                          // 🟦 Search Bar
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: controller.searchController,
                              onChanged: (value) {
                                controller.pujaServicesList.clear();
                                controller.query.value = value;
                                controller.pujaServicesAPI();
                              },
                              style: AppTextStyles.body().copyWith(
                                color: AppColors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search puja, category...',
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.darkBackground,
                                ),
                                border: InputBorder.none,
                                icon: const Icon(
                                  Icons.search,
                                  color: AppColors.darkBackground,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // 🟨 Enhanced Horizontal Category List with Selection State
                          SizedBox(
                            height: 120.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              itemCount: category?.pujaCategory?.length ?? 0,
                              itemBuilder: (context, index) {
                                final data = category?.pujaCategory?[index];
                                final isSelected =
                                    controller.selectIndex.value == index;

                                return GestureDetector(
                                  onTap: () {
                                    controller.setSelectIndex(
                                      index: index,
                                      id:
                                          category
                                              ?.pujaCategory?[index]
                                              .pujaCategoryId
                                              .toString() ??
                                          "",
                                    );
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    width: 90.w,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? Colors.white.withOpacity(0.9)
                                              : Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border:
                                          isSelected
                                              ? Border.all(
                                                color: AppColors.primaryColor,
                                                width: 2,
                                              )
                                              : null,
                                      boxShadow:
                                          isSelected
                                              ? [
                                                BoxShadow(
                                                  color: AppColors.primaryColor
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ]
                                              : null,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Category Image with selection indicator
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  isSelected
                                                      ? AppColors.primaryColor
                                                      : Colors.white
                                                          .withOpacity(0.4),
                                              width: isSelected ? 3 : 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    isSelected
                                                        ? AppColors.primaryColor
                                                            .withOpacity(0.4)
                                                        : Colors.black26,
                                                blurRadius: isSelected ? 8 : 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              35.r,
                                            ),
                                            child: CustomCachedNetworkImage(
                                              imageUrl:
                                                  data?.categoryImage ?? "",
                                              height: 70.h,
                                              width: 70.w,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),

                                        // Category Name with selection color
                                        Text(
                                          data?.categoryName ?? "",
                                          style: AppTextStyles.caption()
                                              .copyWith(
                                                color:
                                                    isSelected
                                                        ? AppColors.primaryColor
                                                        : Colors.white,
                                                fontWeight:
                                                    isSelected
                                                        ? FontWeight.w700
                                                        : FontWeight.w600,
                                                fontSize: 12.sp,
                                              ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Services List with Loading State
              SliverPadding(
                padding: EdgeInsets.all(16.w),
                sliver:
                    controller.isLoading.value &&
                            controller.pujaServicesList.isEmpty
                        ? SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Loading services...',
                                    style: AppTextStyles.body(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        : controller.pujaServicesList.isEmpty
                        ? SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64.sp,
                                    color:
                                        isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'No services found',
                                    style: AppTextStyles.headlineMedium(),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Try selecting a different category or search term',
                                    style: AppTextStyles.caption(),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index >= controller.pujaServicesList.length) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                );
                              } else {
                                final service =
                                    controller.pujaServicesList[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  decoration: BoxDecoration(
                                    color:
                                        isDark
                                            ? AppColors.darkSurface
                                            : AppColors.lightSurface,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            isDark
                                                ? Colors.black.withOpacity(0.3)
                                                : Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(
                                        PujaDetailsView(pujaService: service),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.w),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Service Image
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primaryColor
                                                      .withOpacity(0.2),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: CustomCachedNetworkImage(
                                              borderRadius: 12.r,
                                              imageUrl:
                                                  service.serviceImage ?? "",
                                              height: 80.h,
                                              width: 80.w,
                                            ),
                                          ),
                                          SizedBox(width: 16.w),

                                          // Service Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Service Name
                                                Text(
                                                  service.serviceName ?? "",
                                                  style:
                                                      AppTextStyles.headlineMedium()
                                                          .copyWith(
                                                            fontSize: 16.sp,
                                                          ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4.h),

                                                // Description
                                                Text(
                                                  service.description ?? "",
                                                  style: AppTextStyles.caption()
                                                      .copyWith(
                                                        fontSize: 13.sp,
                                                      ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 8.h),

                                                // Price and Rating Row
                                                Row(
                                                  children: [
                                                    // Price
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8.w,
                                                            vertical: 4.h,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .primaryColor
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6.r,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        '₹${service.price?.toStringAsFixed(0) ?? "0"}',
                                                        style: AppTextStyles.caption()
                                                            .copyWith(
                                                              color:
                                                                  AppColors
                                                                      .primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 13.sp,
                                                            ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),

                                                    // Rating
                                                    if (service.averageRating !=
                                                            null &&
                                                        service.averageRating! >
                                                            0)
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8.w,
                                                              vertical: 4.h,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .sucessPrimary
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6.r,
                                                              ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.star,
                                                              color:
                                                                  AppColors
                                                                      .sucessPrimary,
                                                              size: 12.sp,
                                                            ),
                                                            SizedBox(
                                                              width: 2.w,
                                                            ),
                                                            Text(
                                                              service
                                                                  .averageRating!
                                                                  .toStringAsFixed(
                                                                    1,
                                                                  ),
                                                              style: AppTextStyles.caption()
                                                                  .copyWith(
                                                                    color:
                                                                        AppColors
                                                                            .sucessPrimary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        12.sp,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                    const Spacer(),

                                                    // Duration
                                                    if (service.duration !=
                                                        null)
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.access_time,
                                                            color:
                                                                isDark
                                                                    ? AppColors
                                                                        .darkTextSecondary
                                                                    : AppColors
                                                                        .lightTextSecondary,
                                                            size: 14.sp,
                                                          ),
                                                          SizedBox(width: 4.w),
                                                          Text(
                                                            '${service.duration} min',
                                                            style:
                                                                AppTextStyles.caption()
                                                                    .copyWith(
                                                                      fontSize:
                                                                          12.sp,
                                                                    ),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),

                                                // Booking Count
                                                if (service.bookingCount !=
                                                        null &&
                                                    service.bookingCount! > 0)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 8.h,
                                                    ),
                                                    child: Text(
                                                      '${service.bookingCount} people booked',
                                                      style: AppTextStyles.small()
                                                          .copyWith(
                                                            color:
                                                                AppColors
                                                                    .primaryColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            childCount:
                                controller.isLoading.value
                                    ? controller.pujaServicesList.length + 1
                                    : controller.pujaServicesList.length,
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
