import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/constant/constants.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/data/models/review/review_model.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/review_controller.dart';

class ReviewView extends GetView<ReviewController> {
  const ReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(
      init: ReviewController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
          appBar: _buildAppBar(context),
          body: _buildBody(controller),
          floatingActionButton:(controller.reviewModel.value?.reviews?.isEmpty??true)? FloatingActionButton(
            onPressed: () {
              _showUpdateReviewDialog(controller: controller);
            },

            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.reviews, color: AppColors.white),
          ):SizedBox(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.headerGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        'Reviews & Ratings',
        style: AppTextStyles.headlineMedium().copyWith(
          color: Colors.white,
          fontSize: 20.sp,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildBody(ReviewController controller) {
    return Obx(() {
      final reviews = controller.reviewModel.value?.reviews;
      if (reviews == null) {
        return _buildLoadingState();
      }

      if (reviews.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: () async {
          await controller.fetchReview();
        },
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final review = reviews[index];
                return _buildReviewCard(review, index, controller);
              }, childCount: reviews.length),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 80.h)),
          ],
        ),
      );
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
          SizedBox(height: 16.h),
          Text('Loading reviews...', style: AppTextStyles.body()),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rate_review_outlined, size: 80.w, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            'No Reviews Yet',
            style: AppTextStyles.headlineMedium().copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Reviews will appear here',
            style: AppTextStyles.body().copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    ReviewData review,
    int index,
    ReviewController controller,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color:
            Theme.of(Get.context!).brightness == Brightness.dark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReviewHeader(review),
            SizedBox(height: 12.h),
            _buildRatingStars(review.rating ?? 0),
            if (review.reviewText != null && review.reviewText!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                review.reviewText!,
                style: AppTextStyles.body().copyWith(
                  color:
                      Theme.of(Get.context!).brightness == Brightness.dark
                          ? Colors.grey[300]
                          : Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
            SizedBox(height: 12.h),
            _buildReviewFooter(review),
            SizedBox(height: 12.h),
            _buildActionButtons(review, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(dynamic review, ReviewController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            _showUpdateReviewDialog(controller: controller, review: review);
          },
          icon: Icon(Icons.edit, size: 16.w, color: AppColors.white),
          label: Text('Update', style: AppTextStyles.button),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        // ElevatedButton.icon(
        //   onPressed: () {
        //     _showDeleteConfirmationDialog(controller, review);
        //   },
        //   icon: Icon(Icons.delete, size: 16.w, color: AppColors.white),
        //   label: Text(
        //     'Delete',
        //     style: AppTextStyles.button.copyWith(color: AppColors.white),
        //   ),
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: AppColors.red,
        //     foregroundColor: Colors.white,
        //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8.r),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildReviewHeader(ReviewData review) {
    return Row(
      children: [
        _buildAvatar(review.customerProfilePic),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.customerName ?? 'Anonymous',
                style: AppTextStyles.headlineMedium().copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Session #${review.sessionId ?? "N/A"}',
                style: AppTextStyles.caption().copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.secondaryPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: AppColors.secondaryPrimary, size: 16.w),
              SizedBox(width: 4.w),
              Text(
                (review.rating ?? 0).toString(),
                style: AppTextStyles.caption().copyWith(
                  color: AppColors.secondaryPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String? photoUrl) {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: AppColors.headerGradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child:
          photoUrl != null && photoUrl.isNotEmpty
              ? ClipOval(
                child: Image.network(
                  photoUrl,
                  width: 50.w,
                  height: 50.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.person, color: Colors.white, size: 24.w);
                  },
                ),
              )
              : Icon(Icons.person, color: Colors.white, size: 24.w),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: AppColors.secondaryPrimary,
          size: 20.w,
        );
      }),
    );
  }

  Widget _buildReviewFooter(ReviewData review) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 14.w, color: AppColors.primaryColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              AppDateUtils.extractDate(review.createdAt, 5),
              style: AppTextStyles.caption().copyWith(
                color: AppColors.primaryColor,
                fontSize: 12.sp,
              ),
            ),
          ),
          if (review.astrologerName != null) ...[
            Icon(Icons.person_outline, size: 14.w, color: Colors.grey[600]),
            SizedBox(width: 4.w),
            Text(
              review.astrologerName!,
              style: AppTextStyles.caption().copyWith(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Update Review Dialog
  void _showUpdateReviewDialog({
    ReviewController? controller,
    ReviewData? review,
  }) {
    controller?.reviewTextController = TextEditingController(
      text: review?.reviewText ?? "",
    );

    int selectedRating = review?.rating ?? 0;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(Get.context!).brightness == Brightness.dark
                    ? AppColors.darkSurface
                    : Colors.white,
                Theme.of(Get.context!).brightness == Brightness.dark
                    ? AppColors.darkSurface.withOpacity(0.8)
                    : Colors.grey[50]!,
              ],
            ),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.headerGradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.edit_note_rounded,
                          color: Colors.white,
                          size: 28.w,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Update Review',
                              style: AppTextStyles.headlineMedium().copyWith(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // SizedBox(height: 4.h),
                            // Text(
                            //   'Session #${review?.sessionId ?? "N/A"}',
                            //   style: AppTextStyles.caption().copyWith(
                            //     color: Colors.white.withOpacity(0.9),
                            //     fontSize: 13.sp,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating Section
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: AppColors.secondaryPrimary,
                                  size: 20.w,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Your Rating',
                                  style: AppTextStyles.body().copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Center(
                                  child: Wrap(
                                    spacing: 4.w,
                                    children: List.generate(5, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedRating = index + 1;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          child: Icon(
                                            index < selectedRating
                                                ? Icons.star_rounded
                                                : Icons.star_outline_rounded,
                                            color:
                                                index < selectedRating
                                                    ? AppColors.secondaryPrimary
                                                    : Colors.grey[400],
                                            size: 40.w,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Review Text Section
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(Get.context!).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[900]
                                  : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: controller?.reviewTextController,
                          maxLines: 5,
                          style: AppTextStyles.body(),
                          inputFormatters: [CapitalizeFirstLetterFormatter()],
                          decoration: InputDecoration(
                            labelText: 'Your Feedback',
                            labelStyle: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                            hintText: 'Share your experience...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.all(16.w),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                left: 12.w,
                                right: 8.w,
                                top: 12.h,
                              ),
                              child: Icon(
                                Icons.rate_review_rounded,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                side: BorderSide(
                                  color: Colors.grey[400]!,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: AppColors.headerGradientColors,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (selectedRating == 0) {
                                    SnackBarUiView.showError(
                                      message: "Please Select Rating",
                                    );
                                  } else if (controller
                                          ?.reviewTextController
                                          .text
                                          .isEmpty ??
                                      true) {
                                    SnackBarUiView.showError(
                                      message: "Please enter your feedback",
                                    );
                                  } else {
                                    controller?.addUpdateReview(
                                      sessionId: controller.sessionId ?? 0,
                                      rating: selectedRating,
                                      reviewText:
                                          controller.reviewTextController.text,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Obx(
                                  () =>
                                      controller?.isLoading.value ?? false
                                          ? CircularProgressIndicator(
                                            color: AppColors.white,
                                          )
                                          : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle_outline,
                                                size: 20.w,
                                                color: AppColors.white,
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                'Update Review',
                                                style: AppTextStyles.button,
                                              ),
                                            ],
                                          ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Delete Confirmation Dialog
  // void _showDeleteConfirmationDialog(
  //   ReviewController controller,
  //   ReviewData review,
  // ) {
  //   Get.dialog(
  //     AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16.r),
  //       ),
  //       title: Row(
  //         children: [
  //           Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28.w),
  //           SizedBox(width: 8.w),
  //           Text(
  //             'Delete Review',
  //             style: AppTextStyles.headlineMedium().copyWith(fontSize: 18.sp),
  //           ),
  //         ],
  //       ),
  //       content: Text(
  //         'Are you sure you want to delete this review? This action cannot be undone.',
  //         style: AppTextStyles.body(),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: Text(
  //             'Cancel',
  //             style: AppTextStyles.button.copyWith(
  //               color: AppColors.lightTextSecondary,
  //             ),
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Call controller method to delete review
  //             controller.deleteReview(review.reviewId ?? 0);
  //           },
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  //           child: Text(
  //             'Delete',
  //             style: AppTextStyles.button.copyWith(color: AppColors.white),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
