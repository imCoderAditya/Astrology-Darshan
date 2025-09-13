// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:astrology/app/data/models/ecommerce/cart_model.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  CartView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: CartController(),
      builder: (controller) {
        return Obx(
          () => Scaffold(
            backgroundColor: _backgroundColor,
            appBar: _buildAppBar(),
            body:
                controller.isLoading.value
                    ? _buildLoadingState()
                    : controller.cartEcModel.value?.data?.cartItems?.isEmpty ??
                        true
                    ? _buildEmptyCartState()
                    : _buildCartContent(controller),
            bottomNavigationBar:
                controller.cartEcModel.value?.data?.cartItems?.isNotEmpty ??
                        false
                    ? _buildBottomCheckout(controller)
                    : null,
          ),
        );
      },
    );
  }

  // Theme getters
  Color get _backgroundColor =>
      themeController.isDarkMode.value
          ? AppColors.darkBackground
          : AppColors.lightBackground;
  Color get _surfaceColor =>
      themeController.isDarkMode.value
          ? AppColors.darkSurface
          : AppColors.lightSurface;
  Color get _textPrimary =>
      themeController.isDarkMode.value
          ? AppColors.darkTextPrimary
          : AppColors.lightTextPrimary;
  Color get _textSecondary =>
      themeController.isDarkMode.value
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary;
  Color get _dividerColor =>
      themeController.isDarkMode.value
          ? AppColors.darkDivider
          : AppColors.lightDivider;
  Color get _cardShadowColor =>
      themeController.isDarkMode.value
          ? Colors.black.withOpacity(0.3)
          : Colors.black.withOpacity(0.05);

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _surfaceColor,
      elevation: 0,
      title: Text(
        'My Cart',
        style: AppTextStyles.headlineMedium().copyWith(color: _textPrimary),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_ios, color: _textPrimary),
      ),

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Container(height: 1, color: _dividerColor.withOpacity(0.3)),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.1),
                  AppColors.accentColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Loading your cart...',
            style: AppTextStyles.caption().copyWith(color: _textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(40.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor.withOpacity(0.1),
                  AppColors.accentColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 80.sp,
              color: AppColors.primaryColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            'Your Cart is Empty',
            style: AppTextStyles.headlineMedium().copyWith(color: _textPrimary),
          ),
          SizedBox(height: 10.h),
          Text(
            'Add some spiritual products to your cart\nand start your journey to enlightenment',
            style: AppTextStyles.caption().copyWith(color: _textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30.h),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(25.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 15.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Start Shopping',
                        style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartController controller) {
    final cartData = controller.cartEcModel.value!.data!;

    return Column(
      children: [
        // Cart header with item count
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: _surfaceColor,
            border: Border(
              bottom: BorderSide(color: _dividerColor.withOpacity(0.3)),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withOpacity(0.1),
                      AppColors.accentColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: AppColors.primaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cartData.summary?.itemCount ?? 0} Items in Cart',
                    style: AppTextStyles.caption().copyWith(
                      color: _textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tap delete to remove items',
                    style: AppTextStyles.small().copyWith(
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Cart items list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemCount: cartData.cartItems?.length ?? 0,
            itemBuilder: (context, index) {
              final item = cartData.cartItems![index];
              return _buildCartItemCard(item, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemCard(CartItem item, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _dividerColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: _cardShadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            // Product image
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.2),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child:
                    item.productImage?.isNotEmpty ?? false
                        ? Image.network(
                          item.productImage!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  _buildImagePlaceholder(),
                        )
                        : _buildImagePlaceholder(),
              ),
            ),

            SizedBox(width: 16.w),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.productName ?? 'Unknown Product',
                          style: AppTextStyles.caption().copyWith(
                            color: _textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Delete button
                      Container(
                        margin: EdgeInsets.only(left: 8.w),
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _showDeleteConfirmation(item),
                            borderRadius: BorderRadius.circular(8.r),
                            child: Padding(
                              padding: EdgeInsets.all(8.r),
                              child: Icon(
                                Icons.delete_outline,
                                color: AppColors.red,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Stock status
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color:
                              item.isInStock ?? false
                                  ? AppColors.sucessPrimary
                                  : AppColors.red,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        item.isInStock ?? false ? 'In Stock' : 'Out of Stock',
                        style: AppTextStyles.small().copyWith(
                          color:
                              item.isInStock ?? false
                                  ? AppColors.sucessPrimary
                                  : AppColors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Price and quantity controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${item.price?.toStringAsFixed(0) ?? '0'}',
                            style: AppTextStyles.small().copyWith(
                              color: _textSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            '₹${item.totalPrice?.toStringAsFixed(0) ?? '0'}',
                            style: AppTextStyles.caption().copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // Quantity controls
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildQuantityButton(Icons.remove, () {
                              if ((item.quantity ?? 0) > 1) {
                                controller.updateCartAPI(
                                  quantity: -1,
                                  cartId: item.cartId ?? 0,
                                );
                              } else {
                                SnackBarUiView.showInfo(
                                  message:
                                      'Cannot decrease the quantity further',
                                );
                              }
                            }, enabled: true),
                            Container(
                              width: 40.w,
                              alignment: Alignment.center,
                              child: Text(
                                '${item.quantity ?? 0}',
                                style: AppTextStyles.caption().copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildQuantityButton(
                              Icons.add,
                              () {
                                if ((item.quantity ?? 0) <
                                    (item.maxQuantity ?? 999)) {
                                  controller.updateCartAPI(
                                    quantity: 1,
                                    cartId: item.cartId ?? 0,
                                  );
                                } else {
                                  SnackBarUiView.showInfo(
                                    message: "Item exceeds maximum quantity",
                                  );
                                }
                              },
                              enabled: true,
                              // (item.quantity ?? 0) <
                              // (item.maxQuantity ?? 999),
                            ),
                          ],
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
    );
  }

  void _showDeleteConfirmation(CartItem item) {
    Get.dialog(
      Dialog(
        backgroundColor: _surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.red,
                  size: 32.sp,
                ),
              ),

              SizedBox(height: 20.h),

              // Title
              Text(
                'Remove Item',
                style: AppTextStyles.headlineMedium().copyWith(
                  color: _textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 12.h),

              // Message
              Text(
                'Are you sure you want to remove "${item.productName}" from your cart?',
                style: AppTextStyles.caption().copyWith(color: _textSecondary),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              // Buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: _dividerColor),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Get.back(),
                          borderRadius: BorderRadius.circular(12.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.button.copyWith(
                                color: _textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  // Delete button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.red.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            controller.deleteProductCartAPI(
                              cartId: item.cartId ?? 0,
                            );
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Text(
                              'Remove',
                              style: AppTextStyles.button.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
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
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.accentColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.temple_buddhist,
        color: AppColors.primaryColor.withOpacity(0.5),
        size: 40.sp,
      ),
    );
  }

  Widget _buildQuantityButton(
    IconData icon,
    VoidCallback onTap, {
    bool enabled = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 32.w,
          height: 32.h,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color:
                enabled
                    ? AppColors.primaryColor
                    : _textSecondary.withOpacity(0.5),
            size: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCheckout(CartController controller) {
    final summary = controller.cartEcModel.value!.data!.summary!;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
        boxShadow: [
          BoxShadow(
            color: _cardShadowColor,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price breakdown
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: _dividerColor.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  _buildPriceRow(
                    'Subtotal',
                    '₹${summary.subtotal?.toStringAsFixed(0) ?? '0'}',
                  ),
                  SizedBox(height: 8.h),
                  _buildPriceRow(
                    'Shipping',
                    summary.shipping == 0
                        ? 'Free'
                        : '₹${summary.shipping?.toStringAsFixed(0) ?? '0'}',
                  ),
                  SizedBox(height: 8.h),
                  Divider(color: _dividerColor, thickness: 1),
                  SizedBox(height: 8.h),
                  _buildPriceRow(
                    'Total',
                    '₹${summary.total?.toStringAsFixed(0) ?? '0'}',
                    isTotal: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Checkout button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.ADDRESS);
                   
                  },
                  borderRadius: BorderRadius.circular(25.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Proceed to Checkout',
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.caption().copyWith(
            color: isTotal ? _textPrimary : _textSecondary,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption().copyWith(
            color: isTotal ? AppColors.primaryColor : _textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 16.sp : 14.sp,
          ),
        ),
      ],
    );
  }
}
