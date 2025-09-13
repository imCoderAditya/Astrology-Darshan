// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:astrology/app/data/models/ecommerce/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<ThemeController>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color appBarColor =
        isDark ? AppColors.darkSurface : AppColors.primaryColor;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color cardColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color accentColor = AppColors.accentColor;

    return GetBuilder<ProductDetailsController>(
      init: ProductDetailsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Obx(() {
            final product = controller.product.value;
            if (product == null) {
              return Center(
                child: Text(
                  'Product not found',
                  style: TextStyle(color: textColor, fontSize: 18.sp),
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // Custom App Bar with Product Images
                SliverAppBar(
                  expandedHeight: 300.h,
                  pinned: true,
                  backgroundColor: appBarColor,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildImageCarousel(
                      product.images ?? [],
                      isDark,
                    ),
                  ),
                  actions: [
                    Obx(
                      () => IconButton(
                        onPressed: controller.toggleFavorite,
                        icon: Icon(
                          controller.isFavorite.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              controller.isFavorite.value
                                  ? Colors.red
                                  : (isDark
                                      ? AppColors.white
                                      : AppColors.white),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.shareProduct,
                      icon: Icon(
                        Icons.share,
                        color: isDark ? AppColors.white : AppColors.white,
                      ),
                    ),
                  ],
                ),

                // Product Details
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name and Category
                          _buildProductHeader(product, textColor, isDark),

                          SizedBox(height: 16.h),

                          // Rating and Reviews
                          _buildRatingSection(product, textColor, accentColor),

                          SizedBox(height: 20.h),

                          // Price Section
                          _buildPriceSection(product, isDark),

                          SizedBox(height: 20.h),

                          // Stock Status
                          _buildStockStatus(controller, textColor, accentColor),

                          SizedBox(height: 24.h),

                          // Quantity Selector
                          _buildQuantitySelector(
                            controller,
                            cardColor,
                            textColor,
                            accentColor,
                          ),

                          SizedBox(height: 24.h),

                          // Description
                          _buildDescriptionSection(product, textColor),

                          SizedBox(height: 30.h),

                          // Action Buttons
                          _buildActionButtons(controller, accentColor),

                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildImageCarousel(List<dynamic> images, bool isDark) {
    if (images.isEmpty) {
      return Container(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: 80.w,
            color:
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
        ),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          controller: controller.pageController,
          onPageChanged: (index) {
            controller.currentImageIndex.value = index;
          },
          itemCount: images.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: images[index].imageUrl ?? '',
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    color: Colors.grey.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accentColor,
                      ),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color:
                        isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    child: Icon(
                      Icons.broken_image,
                      size: 80.w,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                    ),
                  ),
            );
          },
        ),

        // Image indicators
        if (images.length > 1)
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width:
                        controller.currentImageIndex.value == index
                            ? 12.w
                            : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color:
                          controller.currentImageIndex.value == index
                              ? AppColors.accentColor
                              : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductHeader(Product product, Color textColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productName ?? '',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
            height: 1.3,
          ),
        ),
        if (product.category?.categoryName != null) ...[
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.accentColor.withOpacity(0.3)),
            ),
            child: Text(
              product.category!.categoryName!,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.accentColor,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRatingSection(
    Product product,
    Color textColor,
    Color accentColor,
  ) {
    final rating = product.rating ?? 0.0;
    final reviewCount = product.reviewCount ?? 0;

    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < rating.floor()
                  ? Icons.star
                  : index < rating
                  ? Icons.star_half
                  : Icons.star_border,
              color: Colors.amber,
              size: 20.w,
            );
          }),
        ),
        SizedBox(width: 8.w),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '($reviewCount reviews)',
          style: TextStyle(fontSize: 14.sp, color: textColor.withOpacity(0.6)),
        ),
      ],
    );
  }

  Widget _buildPriceSection(Product product, bool isDark) {
    final price = product.price ?? 0.0;

    return Row(
      children: [
        Text(
          '\u{20B9}${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryPrimary,
          ),
        ),
        SizedBox(width: 12.w),
        // if (discountedPrice < price) ...[
        //   Text(
        //     '\u{20B9}${price.toStringAsFixed(2)}',
        //     style: TextStyle(
        //       fontSize: 18.sp,
        //       color: isDark
        //           ? AppColors.darkTextSecondary
        //           : AppColors.lightTextSecondary,
        //       decoration: TextDecoration.lineThrough,
        //       decorationColor: isDark
        //           ? AppColors.darkTextSecondary
        //           : AppColors.lightTextSecondary,
        //     ),
        //   ),
        // SizedBox(width: 8.w),
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        //   decoration: BoxDecoration(
        //     color: Colors.green,
        //     borderRadius: BorderRadius.circular(4.r),
        //   ),
        //   child: Text(
        //     '${controller.discountPercentage} OFF',
        //     style: TextStyle(
        //       fontSize: 12.sp,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildStockStatus(
    ProductDetailsController controller,
    Color textColor,
    Color accentColor,
  ) {
    return Obx(() {
      final isInStock = controller.isInStock;
      final stockStatus = controller.stockStatus;

      return Row(
        children: [
          Icon(
            isInStock ? Icons.check_circle : Icons.error,
            color: isInStock ? Colors.green : Colors.red,
            size: 20.w,
          ),
          SizedBox(width: 8.w),
          Text(
            stockStatus,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isInStock ? Colors.green : Colors.red,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildQuantitySelector(
    ProductDetailsController controller,
    Color cardColor,
    Color textColor,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: accentColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed:
                      controller.quantity.value > 1
                          ? controller.decrementQuantity
                          : null,
                  icon: Icon(
                    Icons.remove,
                    color:
                        controller.quantity.value > 1
                            ? accentColor
                            : textColor.withOpacity(0.3),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    controller.quantity.value.toString(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed:
                      controller.quantity.value <
                              (controller.product.value?.stock ?? 1)
                          ? controller.incrementQuantity
                          : null,
                  icon: Icon(
                    Icons.add,
                    color:
                        controller.quantity.value <
                                (controller.product.value?.stock ?? 1)
                            ? accentColor
                            : textColor.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(dynamic product, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 12.h),
        if (product.shortDescription?.isNotEmpty ?? false) ...[
          Text(
            product.shortDescription!,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
              height: 1.4,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        if (product.description?.isNotEmpty ?? false)
          Text(
            product.description!,
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),

        SizedBox(height: 20.h),

        // Product Details
        _buildProductSpecs(product, textColor),
      ],
    );
  }

  Widget _buildProductSpecs(dynamic product, Color textColor) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 12.h),
          _buildSpecRow('SKU', product.sku ?? 'N/A', textColor),
          _buildSpecRow('Stock', (product.stock ?? 0).toString(), textColor),
          _buildSpecRow(
            'Physical Product',
            (product.isPhysical ?? false) ? 'Yes' : 'No',
            textColor,
          ),
          _buildSpecRow(
            'Requires Shipping',
            (product.requiresShipping ?? false) ? 'Yes' : 'No',
            textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    ProductDetailsController controller,
    Color accentColor,
  ) {
    return Obx(() {
      final isInStock = controller.isInStock;

 
      return Column(
        children: [
          // Add to Cart Button
          controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton.icon(
                  onPressed: isInStock ? controller.addToCart : null,
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 20.w,
                  ),
                  label: Text(
                    isInStock ? 'Add to Cart' : 'Out of Stock',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInStock ? accentColor : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: isInStock ? 3 : 0,
                  ),
                ),
              ),

          SizedBox(height: 12.h),

          // Buy Now Button
          // SizedBox(
          //   width: double.infinity,
          //   height: 50.h,
          //   child: OutlinedButton.icon(
          //     onPressed: isInStock ? controller.buyNow : null,
          //     icon: Icon(
          //       Icons.flash_on,
          //       color: isInStock ? accentColor : Colors.grey,
          //       size: 20.w,
          //     ),
          //     label: Text(
          //       'Buy Now',
          //       style: TextStyle(
          //         fontSize: 16.sp,
          //         fontWeight: FontWeight.bold,
          //         color: isInStock ? accentColor : Colors.grey,
          //       ),
          //     ),
          //     style: OutlinedButton.styleFrom(
          //       side: BorderSide(
          //         color: isInStock ? accentColor : Colors.grey,
          //         width: 2,
          //       ),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(25.r),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      );
    });
  }
}
