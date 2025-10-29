// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart' show AppColors;
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/order_history_controller.dart';

class OrderHistoryView extends GetView<OrderHistoryController> {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<OrderHistoryController>(
      init: OrderHistoryController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
            
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: AppColors.white
            ),
            title: Text(
              'Order History',
              style: AppTextStyles.headlineMedium().copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.headerGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              // Enhanced Status Filter Section
              _buildEnhancedStatusFilterSection(isDark),
              SizedBox(height: 20.h),

              // Orders List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.orderList.isEmpty) {
                    return _buildLoadingState();
                  }

                  final filteredOrders = controller.orderList;

                  if (!controller.isLoading.value && filteredOrders.isEmpty) {
                    return _buildEmptyState(isDark);
                  }

                  return _buildOrdersList(filteredOrders, isDark);
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnhancedStatusFilterSection(bool isDark) {
    final statusList = [
      'All',
      'Pending',
      'Confirmed',
      'Processing',
      'Shipped',
      'Delivered',
      'Cancelled',
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,

        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.filter_list_rounded,
                    color: AppColors.primaryColor,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Filter by Status',
                  style: AppTextStyles.subtitle().copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color:
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            height: 60.h,
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 10.h, left: 10.w),
              scrollDirection: Axis.horizontal,
              itemCount: statusList.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final status = statusList[index];
                return Obx(() {
                  final isSelected = controller.selectedStatus.value == status;
                  return GestureDetector(
                    onTap: () => controller.filterByStatus(status),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        gradient:
                            isSelected
                                ? LinearGradient(
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.primaryColor.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        color:
                            isSelected
                                ? null
                                : (isDark
                                    ? AppColors.darkBackground.withOpacity(0.6)
                                    : Colors.white.withOpacity(0.8)),
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.primaryColor
                                  : (isDark
                                      ? AppColors.darkDivider
                                      : AppColors.lightDivider),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                                : [
                                  BoxShadow(
                                    color:
                                        isDark
                                            ? Colors.black.withOpacity(0.1)
                                            : Colors.grey.withOpacity(0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                      ),
                      child: Center(
                        child: Text(
                          status,
                          style: AppTextStyles.caption().copyWith(
                            color:
                                isSelected
                                    ? AppColors.white
                                    : (isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary),
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List orders, bool isDark) {
    return ListView.separated(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: controller.isLoading.value ? orders.length + 1 : orders.length,
      separatorBuilder: (_, __) => SizedBox(height: 20.h),
      itemBuilder: (context, index) {
        if (index < orders.length) {
          final order = orders[index];
          return _buildEnhancedOrderCard(order, isDark);
        } else {
          return _buildLoadingState();
        }
      },
    );
  }

  Widget _buildEnhancedOrderCard(order, bool isDark) {
    final statusColor = _getStatusColor(order.status ?? '');

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color:
              isDark
                  ? AppColors.darkDivider.withOpacity(0.5)
                  : AppColors.lightDivider.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Header Section
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  statusColor.withOpacity(0.15),
                  statusColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.receipt_long_rounded,
                              color: AppColors.primaryColor,
                              size: 16.w,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Order #${order.orderNumber ?? 'N/A'}',
                              style: AppTextStyles.subtitle().copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                color:
                                    isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14.w,
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _formatDate(order.createdAt),
                            style: AppTextStyles.caption().copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor, statusColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    order.status ?? 'Unknown',
                    style: AppTextStyles.caption().copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Enhanced Order Items Section
          if (order.orderItems != null && order.orderItems!.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_rounded,
                        size: 18.w,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Items (${order.orderItems!.length})',
                        style: AppTextStyles.subtitle().copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color:
                              isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ...order.orderItems!
                      .take(2)
                      .map<Widget>(
                        (item) => Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? AppColors.darkBackground.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color:
                                  isDark
                                      ? AppColors.darkDivider.withOpacity(0.3)
                                      : AppColors.lightDivider.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Enhanced Product Image
                              Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color:
                                      isDark
                                          ? AppColors.darkDivider
                                          : AppColors.lightDivider,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child:
                                    item.mainImage != null
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: item.mainImage!,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                (context, url) => Container(
                                                  color: AppColors.lightDivider,
                                                  child: Icon(
                                                    Icons.image_rounded,
                                                    color:
                                                        AppColors
                                                            .lightTextSecondary,
                                                    size: 24.w,
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                                  Icons.broken_image_rounded,
                                                  color:
                                                      AppColors
                                                          .lightTextSecondary,
                                                  size: 24.w,
                                                ),
                                          ),
                                        )
                                        : Icon(
                                          Icons.shopping_bag_rounded,
                                          color: AppColors.lightTextSecondary,
                                          size: 28.w,
                                        ),
                              ),
                              SizedBox(width: 16.w),

                              // Enhanced Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName ?? 'Unknown Product',
                                      style: AppTextStyles.body().copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color:
                                            isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 6.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.accentColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Text(
                                        'Qty: ${item.quantity ?? 0} × ₹${item.price?.toStringAsFixed(2) ?? '0.00'}',
                                        style: AppTextStyles.caption().copyWith(
                                          color: AppColors.accentColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Enhanced Item Total
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primaryColor.withOpacity(0.1),
                                      AppColors.primaryColor.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  '₹${item.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                                  style: AppTextStyles.subtitle().copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryColor,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),

                  if (order.orderItems!.length > 2)
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.accentColor.withOpacity(0.3),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.more_horiz_rounded,
                            color: AppColors.accentColor,
                            size: 16.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '+${order.orderItems!.length - 2} more items',
                            style: AppTextStyles.caption().copyWith(
                              color: AppColors.accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

          // Enhanced Footer Section
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  isDark
                      ? AppColors.darkBackground.withOpacity(0.7)
                      : AppColors.lightBackground.withOpacity(0.8),
                  isDark
                      ? AppColors.darkBackground.withOpacity(0.3)
                      : AppColors.lightBackground.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: AppTextStyles.caption().copyWith(
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '₹${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                      style: AppTextStyles.headlineMedium().copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    if (order.status == 'Shipped' &&
                        order.trackingNumber != null)
                      Container(
                        margin: EdgeInsets.only(right: 12.w),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Handle tracking
                          },
                          icon: Icon(Icons.track_changes_rounded, size: 16.w),
                          label: Text(
                            'Track',
                            style: AppTextStyles.caption().copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentColor,
                            foregroundColor: AppColors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            elevation: 4,
                            shadowColor: AppColors.accentColor.withOpacity(0.3),
                          ),
                        ),
                      ),

                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle view details
                      },
                      icon: Icon(Icons.visibility_rounded, size: 16.w),
                      label: Text(
                        'Details',
                        style: AppTextStyles.caption().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.primaryColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Loading your orders...',
            style: AppTextStyles.subtitle().copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(40.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.1),
                    AppColors.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 80.w,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'No Orders Found',
              style: AppTextStyles.headlineMedium().copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'You haven\'t placed any orders yet.\nStart shopping to see your orders here!',
              textAlign: TextAlign.center,
              style: AppTextStyles.body().copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                fontSize: 16.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () {
                Get.back(); // Navigate back to store
              },
              icon: Icon(Icons.shopping_cart_rounded, size: 20.w),
              label: Text(
                'Start Shopping',
                style: AppTextStyles.body().copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                elevation: 8,
                shadowColor: AppColors.primaryColor.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'shipped':
        return AppColors.accentColor;
      case 'delivered':
        return AppColors.sucessPrimary;
      case 'cancelled':
        return AppColors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
