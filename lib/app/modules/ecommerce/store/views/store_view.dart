// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:astrology/app/data/models/ecommerce/category_model.dart';
import 'package:astrology/app/data/models/ecommerce/product_model.dart'
    show ImageList, Product;
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/components/custom_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/store_controller.dart';

class StoreView extends GetView<StoreController> {
  final bool? isBack;
  StoreView({super.key, this.isBack = true});
  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
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

    return GetBuilder<StoreController>(
      init: StoreController(),
      builder: (controller) {
        return Scaffold(
          drawer: isBack == true ? AppDrawer() : SizedBox(),
          backgroundColor: backgroundColor,
          drawerScrimColor: AppColors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: AppColors.white),
            foregroundColor: AppColors.white,
            leading:
                isBack == true
                    ? null
                    : IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
                    ),
            title: Text(
              'Our Store',
              style: TextStyle(
                color: isDark ? AppColors.darkTextPrimary : AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.toNamed(Routes.CART);
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.white,
                ),
              ),
            ],
            centerTitle: true,
            backgroundColor: appBarColor,
            elevation: 0,
            flexibleSpace:
                isDark
                    ? null
                    : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.headerGradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategorySection(isDark, cardColor, textColor, accentColor),
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Featured Products',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Obx(() {
                if (controller.isLoading.value) {
                  return Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (!controller.isLoading.value &&
                    controller.productList.isEmpty) {
                  return Expanded(
                    child: _buildEmptyState(
                      title: "No Product Available",
                      textColor: textColor,
                      accentColor: accentColor,
                    ),
                  );
                }
                return Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    controller: controller.scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.65,
                        ),
                    itemCount: controller.productList.length,
                    itemBuilder: (context, index) {
                      Product product = controller.productList[index];
                      final productName = product.productName ?? "";
                      final productPrice = product.price ?? 0.0;
                      final productDescription = product.description ?? "";
                      // final productImage =
                      //     'https://picsum.photos/id/${100 + index}/200/200';
                      final productImage = product.images;
                      return _buildProductCard(
                        isDark: isDark,
                        cardColor: cardColor,
                        textColor: textColor,
                        accentColor: accentColor,
                        productName: productName,
                        productPrice: productPrice,
                        productDescription: productDescription,
                        image: productImage,
                        onAddPressed: () {
                          Get.toNamed(
                            Routes.PRODUCT_DETAILS,
                            arguments: product,
                          );
                        },
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySection(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color accentColor,
  ) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore Categories',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 12.h),

                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkSurface
                            : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border:
                        themeController.isDarkMode.value
                            ? Border.all(
                              color: AppColors.darkDivider.withOpacity(0.3),
                              width: 1,
                            )
                            : null,
                    boxShadow: [
                      BoxShadow(
                        color:
                            themeController.isDarkMode.value
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    style: AppTextStyles.subtitle().copyWith(
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary
                              : AppColors.backgroundDark,
                    ),
                    onChanged: (text) {
                      controller.searchQuery.value = text;
                      if (text.length > 2) {
                        controller.productList.clear();
                        controller.fetchProduct();
                      } else if (text.isEmpty) {
                        controller.productList.clear();
                        controller.fetchProduct();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkTextSecondary
                                : Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkTextSecondary
                                : AppColors.backgroundDark,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 16.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Enhanced Category List
          SizedBox(
            height: 60.h,
            child:
                controller.categoryEcModel.value?.categoryEc?.isEmpty ?? true
                    ? _buildEmptyState(
                      textColor: textColor,
                      accentColor: accentColor,
                    )
                    : ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                          controller
                              .categoryEcModel
                              .value
                              ?.categoryEc
                              ?.length ??
                          0,
                      separatorBuilder: (_, __) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final category =
                            controller
                                .categoryEcModel
                                .value
                                ?.categoryEc?[index];
                        return _buildCategoryChip(
                          category: category,
                          index: index,
                          isDark: isDark,
                        );
                      },
                    ),
          ),
        ],
      );
    });
  }

  Widget _buildCategoryChip({
    required CategoryEc? category,
    required int index,

    required bool isDark,
  }) {
    final isSelected = controller.selectedCategoryId == category?.categoryId;

    return GestureDetector(
      onTap: () {
        // Add haptic feedback
        HapticFeedback.lightImpact();
        // Handle category selection
        controller.onCategorySelected(category);
      },
      child: Row(
        children: [
          if (category?.categoryImage?.isNotEmpty ?? false)
            Container(
              width: 40.w,
              height: 40.h,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? AppColors.accentColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child:
                  category!.categoryImage!.startsWith('http')
                      ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: category.categoryImage!,
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: Colors.transparent.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      isSelected
                                          ? AppColors.accentColor
                                          : (isDark
                                              ? AppColors.darkBackground
                                              : AppColors.white),
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.category_rounded,
                                  color:
                                      isSelected
                                          ? AppColors.white
                                          : (isDark
                                              ? AppColors.white
                                              : AppColors.darkBackground),
                                  size: 16.w,
                                ),
                              ),
                        ),
                      )
                      : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.darkBackground),
                        ),
                        child: Icon(
                          Icons.category_rounded,
                          color:
                              isDark
                                  ? AppColors.darkBackground
                                  : AppColors.white,
                          size: 16.w,
                        ),
                      ),
            )
          else
            Container(
              width: 24.w,
              height: 24.h,
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: AppColors.backgroundDark.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                Icons.category_rounded,
                color: Colors.black,
                size: 16.w,
              ),
            ),

          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accentColor : Colors.transparent,
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: AppColors.accentColor),
            ),
            child: Text(
              category?.categoryName ?? "",
              style: TextStyle(
                color:
                    isSelected
                        ? AppColors.white
                        : (isDark ? AppColors.white : AppColors.backgroundDark),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    String? title,
    Color? textColor,
    Color? accentColor,
  }) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: accentColor?.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: accentColor!.withOpacity(0.2), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.category_outlined, color: accentColor, size: 20.w),
            SizedBox(width: 8.w),
            Text(
              title ?? 'No categories available',
              style: TextStyle(
                color: textColor?.withOpacity(0.6),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required bool isDark,
    required Color cardColor,
    required Color textColor,
    required Color accentColor,
    required String productName,
    required double productPrice,
    required String productDescription,
    List<ImageList>? image,
    required VoidCallback onAddPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider(
                items:
                    (image ?? []).map((img) {
                      return Builder(
                        builder: (context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              img.imageUrl ??
                                  "", // Assuming ImageList has a `url` property
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        },
                      );
                    }).toList(),
                options: CarouselOptions(
                  height: 400,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
              ),

              //  Image.network(
              //   imageUrl,
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              //   errorBuilder:
              //       (_, __, ___) => const Icon(
              //         Icons.broken_image,
              //         size: 60,
              //         color: Colors.red,
              //       ),
              //   loadingBuilder: (context, child, loadingProgress) {
              //     if (loadingProgress == null) return child;
              //     return Center(
              //       child: CircularProgressIndicator(color: accentColor),
              //     );
              //   },
              // ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '\u{20B9}${productPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: AppColors.secondaryPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\u{20B9}${productPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.black.withValues(alpha: 0.4),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decorationThickness: 1.0,
                          decoration: TextDecoration.lineThrough,
                          decorationColor:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.black.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    productDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAddPressed,
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Add",
                        style: AppTextStyles.button.copyWith(
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
