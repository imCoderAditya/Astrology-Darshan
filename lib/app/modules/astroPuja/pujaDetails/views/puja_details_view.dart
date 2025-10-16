// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart'
    show AppTextStyles;
import 'package:astrology/app/core/constant/constants.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/data/models/puja/puja_services_model.dart';
import 'package:astrology/app/modules/astroPuja/pujaDetails/views/review_view.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/custom_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/puja_details_controller.dart';

class PujaDetailsView extends GetView<PujaDetailsController> {
  final PujaService? pujaService;
  const PujaDetailsView({super.key, this.pujaService});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<PujaDetailsController>(
      init: PujaDetailsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          body:
              pujaService == null
                  ? _buildErrorState(isDark)
                  : CustomScrollView(
                    slivers: [
                      _buildSliverAppBar(context, isDark),
                      SliverToBoxAdapter(child: _buildContent(context, isDark)),
                    ],
                  ),
          bottomNavigationBar:
              pujaService != null ? _buildBottomBar(context, isDark) : null,
        );
      },
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80.w,
            color:
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
          SizedBox(height: 16.h),
          Text('Puja service not found', style: AppTextStyles.headlineMedium()),
          SizedBox(height: 8.h),
          Text('Please try again later', style: AppTextStyles.caption()),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      stretch: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // Add to favorites logic
            },
          ),
        ),
        Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Share logic
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: pujaService?.serviceImage ?? '',
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    color:
                        isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.headerGradientColors,
                      ),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      size: 80.w,
                      color: Colors.white54,
                    ),
                  ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ],
        ),
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDark),
          SizedBox(height: 20.h),
          _buildPriceSection(isDark),
          SizedBox(height: 20.h),
          _buildDescriptionSection(isDark),
          SizedBox(height: 20.h),
          _buildBenefitsSection(isDark),
          SizedBox(height: 20.h),
          _buildDurationSection(isDark),
          SizedBox(height: 20.h),

          _buildReviewsSection(isDark, reviewList: pujaService?.reviews),

          SizedBox(height: 100.h), // Bottom padding for floating button
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pujaService?.serviceName ?? '',
          style: AppTextStyles.headlineLarge(),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                'Popular',
                style: AppTextStyles.small().copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: 20.w),
                SizedBox(width: 4.w),
                Text(
                  '4.8',
                  style: AppTextStyles.caption().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(' (124 reviews)', style: AppTextStyles.caption()),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pricing', style: AppTextStyles.headlineMedium()),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${pujaService?.price ?? '0'}',
                style: AppTextStyles.headlineLarge().copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '₹${(int.tryParse(pujaService?.price?.toString() ?? '0') ?? 0) * 1.2}',
                style: AppTextStyles.caption().copyWith(
                  decoration: TextDecoration.lineThrough,
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '20% OFF',
                  style: AppTextStyles.small().copyWith(
                    color: AppColors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About this Puja', style: AppTextStyles.headlineMedium()),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Text(
            pujaService?.description ?? '',
            style: AppTextStyles.body(),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Benefits', style: AppTextStyles.headlineMedium()),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            children: [
              benifitMethod(name: pujaService?.benefits ?? ""),
              benifitMethod(name: pujaService?.requirements ?? ""),
              benifitMethod(name: pujaService?.includes ?? ""),
            ],
          ),
        ),
      ],
    );
  }

  Padding benifitMethod({String? name}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.check, color: Colors.white, size: 14.w),
          ),
          SizedBox(width: 12.w),
          Expanded(child: Text(name ?? "", style: AppTextStyles.body())),
        ],
      ),
    );
  }

  Widget _buildDurationSection(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            color: AppColors.primaryColor,
            size: 24.w,
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Duration', style: AppTextStyles.caption()),
              Text(
                '${pujaService?.duration ?? "30-45"} minutes',
                style: AppTextStyles.body().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.people_rounded, color: AppColors.accentColor, size: 24.w),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Participants', style: AppTextStyles.caption()),
              Text(
                'Family friendly',
                style: AppTextStyles.body().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Price', style: AppTextStyles.caption()),
                  Text(
                    '₹${pujaService?.price ?? '0'}',
                    style: AppTextStyles.headlineMedium().copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  // Book puja logic
                  _showBookingConfirmation(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 18.w),
                    SizedBox(width: 8.w),
                    Text('Book Now', style: AppTextStyles.button),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection(bool isDark, {List<Review>? reviewList}) {
    // Sample reviews data (in real app, this would come from your model/controller)
    final averageRating = pujaService?.averageRating?.floor();
    final userId = LocalStorageService.getUserId();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews (${pujaService?.reviewCount ?? ""})',
              style: AppTextStyles.headlineMedium(),
            ),
            TextButton.icon(
              onPressed: () => _showWriteReviewDialog(Get.context!),
              icon: Icon(
                Icons.edit_rounded,
                size: 18.w,
                color: AppColors.primaryColor,
              ),
              label: Text(
                'Write Review',
                style: AppTextStyles.caption().copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Overall Rating Card
        Container(
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        pujaService?.averageRating.toString() ?? "",
                        style: AppTextStyles.headlineLarge().copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          5,
                          (index) => Container(
                            width: 60.w,
                            height: 4.h,
                            margin: EdgeInsets.only(bottom: 2.h),
                            decoration: BoxDecoration(
                              color:
                                  index < (averageRating ?? 0)
                                      ? Colors.amber
                                      : Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Based on ${pujaService?.reviewCount ?? ""} reviews',
                    style: AppTextStyles.caption(),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star_rounded,
                    color:
                        index < (averageRating ?? 0)
                            ? Colors.amber
                            : Colors.grey.withOpacity(0.3),
                    size: 20.w,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Reviews List
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount:
              (reviewList?.length ?? 0) > 10 ? 10 : (reviewList?.length ?? 0),
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox();
          },
          itemBuilder: (context, index) {
            Review? review = reviewList?[index];
            return Container(
              padding: EdgeInsets.all(16.w),
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: AppColors.primaryColor,
                        child: CustomCachedNetworkImage(
                          imageUrl:
                              review?.reviewer?.profilePicture?.trim() ?? "",
                          child: Icon(Icons.person, color: AppColors.white),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review?.reviewer?.name ?? "",
                              style: AppTextStyles.body().copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (index) => Icon(
                                    Icons.star_rounded,
                                    color:
                                        index < (review?.rating ?? 0)
                                            ? Colors.amber
                                            : Colors.grey.withOpacity(0.3),
                                    size: 14.w,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  AppDateUtils.extractDateTimeFormate(
                                    review?.createdAt,
                                    4,
                                  ),
                                  style: AppTextStyles.small(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      userId == review?.reviewer?.userId.toString()
                          ? IconButton(
                            padding: EdgeInsets.all(1),
                            onPressed: () {},
                            icon: Icon(
                              Icons.delete_outline_outlined,
                              color: AppColors.red,
                            ),
                          )
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(review?.comment ?? "", style: AppTextStyles.body()),
                ],
              ),
            );
          },
        ),

        // View All Reviews Button
        (reviewList?.length ?? 0) > 10
            ? Center(
              child: TextButton(
                onPressed: () {
                  Get.to(ReviewView(reviewList: reviewList));
                },
                child: Text(
                  'View All Reviews',
                  style: AppTextStyles.body().copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
            : SizedBox(),
      ],
    );
  }

  void _showWriteReviewDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    int selectedRating = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor:
                  isDark ? AppColors.darkSurface : AppColors.lightSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.rate_review_rounded,
                    color: AppColors.primaryColor,
                    size: 24.w,
                  ),
                  SizedBox(width: 8.w),
                  Text('Write a Review', style: AppTextStyles.headlineMedium()),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rate your experience',
                      style: AppTextStyles.body().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRating = index + 1;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            child: Icon(
                              Icons.star_rounded,
                              color:
                                  index < selectedRating
                                      ? Colors.amber
                                      : Colors.grey.withOpacity(0.3),
                              size: 32.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Share your thoughts',
                      style: AppTextStyles.body().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: commentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Write your review here...',
                        hintStyle: AppTextStyles.body().copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color:
                                isDark
                                    ? AppColors.darkDivider
                                    : AppColors.lightDivider,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      style: AppTextStyles.body(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.button.copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (commentController.text.trim().isNotEmpty) {
                      Navigator.of(context).pop();
                      Get.snackbar(
                        'Thank You!',
                        'Your review has been submitted successfully',
                        backgroundColor: AppColors.green,
                        colorText: Colors.white,
                        icon: Icon(Icons.check_circle, color: Colors.white),
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please write a comment for your review',
                        backgroundColor: AppColors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text('Submit Review', style: AppTextStyles.button),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBookingConfirmation(BuildContext context) {
    String? locationController;
    final TextEditingController addressController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.temple_buddhist,
                color: AppColors.primaryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text('Book Puja', style: AppTextStyles.headlineMedium()),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service name info
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.primaryColor,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            pujaService?.serviceName ?? "Selected Service",
                            style: AppTextStyles.body().copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  Text(
                    'Please provide the following details:',
                    style: AppTextStyles.body(),
                  ),

                  SizedBox(height: 16.h),

                  // Puja Location Field
                  Text(
                    'Puja Location *',
                    style: AppTextStyles.body().copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<String>(
                    value: locationController,
                    decoration: InputDecoration(
                      hintText: 'Select puja location',
                      hintStyle: AppTextStyles.body().copyWith(
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: AppColors.primaryColor,
                        size:
                            20, // you can use 20.sp if using flutter_screenutil
                      ),
                      filled: true,
                      fillColor:
                          isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color:
                              isDark
                                  ? AppColors.darkDivider
                                  : AppColors.lightDivider,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color:
                              isDark
                                  ? AppColors.darkDivider
                                  : AppColors.lightDivider,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: AppTextStyles.body(),
                    items:
                        ['Temple', 'Home'].map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                    onChanged: (value) {
                      locationController = value!;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please select puja location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Address Field
                  Text(
                    'Full Address *',
                    style: AppTextStyles.body().copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: addressController,
                    maxLines: 3,
                    inputFormatters: [CapitalizeFirstLetterFormatter()],
                    decoration: InputDecoration(
                      hintText:
                          'Enter complete address with landmark, city, pincode',
                      hintStyle: AppTextStyles.body().copyWith(
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Icon(
                          Icons.home,
                          color: AppColors.primaryColor,
                          size: 20.sp,
                        ),
                      ),
                      filled: true,
                      fillColor:
                          isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color:
                              isDark
                                  ? AppColors.darkDivider
                                  : AppColors.lightDivider,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color:
                              isDark
                                  ? AppColors.darkDivider
                                  : AppColors.lightDivider,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    style: AppTextStyles.body(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter full address';
                      }
                      if (value.trim().length < 10) {
                        return 'Please enter a complete address';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Info note
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.accentColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.accentColor,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Our pandit will visit the provided location to perform the puja. Please ensure the address is accurate.',
                            style: AppTextStyles.caption().copyWith(
                              color: AppColors.accentColor,
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              child: Text(
                'Cancel',
                style: AppTextStyles.button.copyWith(
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Process booking with location and address
                  String? location = locationController;
                  final String address = addressController.text.trim();
                  controller.bookPuja(
                    pujaServiceID: pujaService?.pujaServiceId,
                    pujaLocation: location,
                    address: address,
                    pujaService:pujaService,
                    
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text('Confirm Booking', style: AppTextStyles.button),
            ),
          ],
        );
      },
    );
  }
}
