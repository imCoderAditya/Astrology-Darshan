import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/data/models/puja/puja_services_model.dart';
import 'package:astrology/components/custom_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewView extends StatelessWidget {
  final List<Review>? reviewList;
  const ReviewView({super.key, this.reviewList});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text("Review"),),
      body: _buildReviewsSection(isDark,reviewList: reviewList),
    );
  }

  Widget _buildReviewsSection(bool isDark, {List<Review>? reviewList}) {
    return ListView.separated(
      
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
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
                      imageUrl: review?.reviewer?.profilePicture?.trim() ?? "",
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
                ],
              ),
              SizedBox(height: 12.h),
              Text(review?.comment ?? "", style: AppTextStyles.body()),
            ],
          ),
        );
      },
    );

 }
}
