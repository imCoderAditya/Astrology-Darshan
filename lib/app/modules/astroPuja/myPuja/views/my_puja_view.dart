import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/my_puja_controller.dart';

class MyPujaView extends GetView<MyPujaController> {
  final bool? isBack;
  const MyPujaView({super.key,this.isBack});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyPujaController>(
      init: MyPujaController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
          appBar: _buildAppBar(),
          body: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState();
            } else if (controller.myPujaModel.value?.data?.bookings?.isEmpty ??
                true) {
              return _buildEmptyState();
            } else {
              return _buildBookingsList(controller);
            }
          }),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('My Pujas', style: AppTextStyles.headlineMedium().copyWith(color: AppColors.white)),
      centerTitle: true,
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
      iconTheme: const IconThemeData(color: Colors.white),
    );
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
          Text('Loading your pujas...', style: AppTextStyles.body()),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.temple_buddhist_outlined,
            size: 80.sp,
            color: AppColors.primaryColor.withOpacity(0.5),
          ),
          SizedBox(height: 24.h),
          Text('No Pujas Found', style: AppTextStyles.headlineMedium()),
          SizedBox(height: 8.h),
          Text(
            'You haven\'t booked any pujas yet.\nStart your spiritual journey today!',
            style: AppTextStyles.body(),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () {
              // Navigate to puja booking screen
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text('Book a Puja', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(MyPujaController controller) {
    final bookings = controller.myPujaModel.value?.data?.bookings ?? [];

    return RefreshIndicator(
      onRefresh: () async {
        controller.getPuja();
      },
      color: AppColors.primaryColor,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildPujaCard(booking);
        },
      ),
    );
  }

  Widget _buildPujaCard(booking) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color:
            Theme.of(Get.context!).brightness == Brightness.dark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Status
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: CachedNetworkImage(
                  imageUrl: booking.serviceImage ?? '',
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        height: 160.h,
                        color: AppColors.primaryColor.withOpacity(0.1),
                        child: Center(
                          child: Icon(
                            Icons.temple_buddhist,
                            size: 40.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        height: 160.h,
                        color: AppColors.primaryColor.withOpacity(0.1),
                        child: Center(
                          child: Icon(
                            Icons.temple_buddhist,
                            size: 40.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: _buildStatusChip(booking.status ?? ''),
              ),
              if (booking.liveStreamUrl != null)
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.live_tv, size: 12.sp, color: Colors.white),
                        SizedBox(width: 4.w),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Puja Name and Booking Number
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        booking.pujaServiceName ?? 'Unknown Puja',
                        style: AppTextStyles.headlineMedium(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '#${booking.bookingNumber ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Location
                if (booking.pujaLocation != null)
                  _buildInfoRow(
                    Icons.location_on,
                    booking.pujaLocation!,
                    AppColors.primaryColor,
                  ),

                // Date and Time
                if (booking.scheduledDate != null ||
                    booking.scheduledTime != null)
                  _buildInfoRow(
                    Icons.schedule,
                    '${booking.scheduledDate ?? 'TBD'} ${booking.scheduledTime != null ? 'at ${booking.scheduledTime}' : ''}',
                    AppColors.accentColor,
                  ),

                // Amount
                if (booking.amount != null)
                  _buildInfoRow(
                    Icons.currency_rupee,
                    '${booking.amount!.toStringAsFixed(2)}',
                    AppColors.green,
                  ),

                // Payment Status
                Row(
                  children: [
                    Icon(
                      Icons.payment,
                      size: 16.sp,
                      color: _getPaymentStatusColor(booking.paymentStatus),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Payment: ${booking.paymentStatus ?? 'Unknown'}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: _getPaymentStatusColor(booking.paymentStatus),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // SizedBox(height: 10.h),

                // Action Buttons
                // Row(
                //   children: [
                    // if (booking.liveStreamUrl != null)
                      // Expanded(
                      //   child: ElevatedButton.icon(
                      //     onPressed: () {
                      //       // Handle live stream
                      //     },
                      //     icon: Icon(Icons.play_circle_fill, size: 16.sp),
                      //     label: const Text('Watch Live'),
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.red,
                      //       foregroundColor: Colors.white,
                      //       padding: EdgeInsets.symmetric(vertical: 8.h),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(8.r),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                    // if (booking.canCancel == true &&
                    //     booking.liveStreamUrl != null)
                    //   SizedBox(width: 8.w),

                    // if (booking.canCancel == true)
                    //   Expanded(
                    //     child: OutlinedButton.icon(
                    //       onPressed: () {
                    //         // Handle cancel booking
                    //       },
                    //       icon: Icon(Icons.cancel_outlined, size: 16.sp),
                    //       label: const Text('Cancel'),
                    //       style: OutlinedButton.styleFrom(
                    //         foregroundColor: Colors.red,
                    //         side: const BorderSide(color: Colors.red),
                    //         padding: EdgeInsets.symmetric(vertical: 8.h),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8.r),
                    //         ),
                    //       ),
                    //     ),
                    //   ),

                    // if (booking.canReview == true &&
                    //     (booking.canCancel == true ||
                    //         booking.liveStreamUrl != null))
                    //   SizedBox(width: 8.w),

                    // if (booking.canReview == true)
                    //   Expanded(
                    //     child: OutlinedButton.icon(
                    //       onPressed: () {
                    //         // Handle review
                    //       },
                    //       icon: Icon(Icons.star_outline, size: 16.sp),
                    //       label: const Text('Review'),
                    //       style: OutlinedButton.styleFrom(
                    //         foregroundColor: AppColors.primaryColor,
                    //         side: BorderSide(color: AppColors.primaryColor),
                    //         padding: EdgeInsets.symmetric(vertical: 8.h),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8.r),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: iconColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        backgroundColor = AppColors.green;
        textColor = Colors.white;
        break;
      case 'pending':
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        break;
      case 'cancelled':
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getPaymentStatusColor(String? paymentStatus) {
    switch (paymentStatus?.toLowerCase()) {
      case 'paid':
      case 'success':
        return AppColors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'refunded':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
