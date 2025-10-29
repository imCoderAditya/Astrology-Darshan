// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:developer';

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:astrology/app/data/models/astrologer/astrologer_model.dart';
import 'package:astrology/app/modules/astrologerDetails/views/astrologer_details_view.dart';
import 'package:astrology/app/modules/astrologers/controllers/astrologers_controller.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/components/confirm_dialog_box_view.dart';
import 'package:astrology/components/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AstrologersView extends GetView<AstrologersController> {
  bool? isDrawer;
  AstrologersView({super.key, this.isDrawer = false});

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeController.isDarkMode.value;
      return GetBuilder<AstrologersController>(
        init: AstrologersController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
            drawer: isDrawer == true ? AppDrawer() : null,

            appBar: AppBar(
              iconTheme: IconThemeData(
                color: AppColors.white,
                applyTextScaling: true,
              ),

              title: Text(
                'Astrologers',
                style: TextStyle(
                  color: AppColors.darkTextPrimary,

                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              backgroundColor:
                  isDark ? AppColors.darkSurface : AppColors.primaryColor,
              elevation: 0,
              flexibleSpace: Container(
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
              children: [
                searchTextField(
                  controller: controller.searchController,
                  isDark: isDark,
                  onChanged: (value) async {
                    controller.fetchAstrologerData(search: value);
                  },
                ),
                Container(
                  height: 60.h,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? AppColors.darkBackground
                            : AppColors.lightBackground,
                  ),
                  width: double.infinity,
                  child: Obx(() {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              controller.astrologerList.clear();
                              controller.selectSpecalization = "All";
                              controller.selectCategoryId = -1;
                              controller.fetchAstrologerData();
                              controller.update();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10.w),
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                color:
                                    controller.selectSpecalization == "All"
                                        ? AppColors.green
                                        : Colors.transparent,

                                border: Border.all(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              child: Text(
                                "All",
                                style: AppTextStyles.body().copyWith(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      controller.selectSpecalization == "All"
                                          ? AppColors.white
                                          : (isDark
                                              ? AppColors.white
                                              : AppColors.backgroundDark),
                                ),
                              ),
                            ),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount:
                                controller
                                    .astroCategoryModel
                                    .value
                                    ?.data
                                    ?.length ??
                                0,
                            itemBuilder: (context, index) {
                              final astroCategory =
                                  controller
                                      .astroCategoryModel
                                      .value
                                      ?.data?[index];
                              final isSelected =
                                  astroCategory?.categoryId ==
                                  controller.selectCategoryId;

                              return GestureDetector(
                                onTap: () {
                                  controller.selectCategory(astroCategory!);
                                  controller.update();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.w),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    color:
                                        isSelected
                                            ? AppColors.green
                                            : isDark
                                            ? AppColors.backgroundDark
                                            : AppColors.white,

                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  child: Text(
                                    astroCategory?.categoryName ?? "",
                                    style: AppTextStyles.body().copyWith(
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                      color:
                                          isSelected
                                              ? AppColors.white
                                              : (isDark
                                                  ? AppColors.white
                                                  : AppColors.backgroundDark),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                Expanded(
                  child:
                      controller.isLoading.value &&
                              controller.astrologerList.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : astrollerListView(isDark, controller),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget searchTextField({
    required TextEditingController controller,
    required bool isDark,
    Function(String)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          suffixIcon:
              controller.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      controller.clear();
                      if (onChanged != null) onChanged('');
                    },
                  )
                  : null,
        ),
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget astrollerListView(bool isDark, AstrologersController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDark
                  ? [AppColors.darkBackground, AppColors.darkSurface]
                  : [AppColors.lightBackground, AppColors.lightSurface],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        itemCount:
            controller.astrologerList.length +
            (controller.isLoading.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < controller.astrologerList.length) {
            final astrologer = controller.astrologerList[index];
            final hasChatDiscount =
                astrologer.consultationRate != null &&
                astrologer.consultationRate! <
                    (astrologer.chatMrpPerMinute ?? 0);
            final hasCallDiscount =
                astrologer.callDpPerMinute != null &&
                astrologer.callDpPerMinute! <
                    (astrologer.callMrpPerMinute ?? 0);
            return astrologerListView(
              astrologer,
              isDark,
              hasChatDiscount,
              hasCallDiscount,
              context,
              controller,
            );
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Widget astrologerListView(
    Astrologer astrologer,
    bool isDark,
    bool hasChatDiscount,
    bool hasCallDiscount,
    BuildContext context,
    AstrologersController controller,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(AstrologerDetailsView(astrologer: astrologer));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image with discount badge
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.primaryColor, AppColors.accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child:
                          astrologer.profilePicture != null
                              ? Image.network(
                                astrologer.profilePicture ?? "",
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (
                                      context,
                                      error,
                                      stackTrace,
                                    ) => _buildDefaultAvatar(
                                      "${astrologer.firstName?[0] ?? ""} ${astrologer.lastName?[0] ?? ""}",
                                    ),
                              )
                              : _buildDefaultAvatar(
                                "${astrologer.firstName?[0] ?? ""} ${astrologer.lastName?[0] ?? ""}",
                              ),
                    ),
                  ),

                  // Discount badge
                ],
              ),
              SizedBox(width: 16.w),
              // Astrologer Details
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${astrologer.firstName ?? ""} ${astrologer.lastName ?? ""}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      astrologer.specializations?.firstOrNull ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.secondaryPrimary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${astrologer.rating ?? ""}',
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                astrologer.isOnline == true
                                    ? AppColors.sucessPrimary.withOpacity(0.1)
                                    : AppColors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            astrologer.isOnline == true ? 'Online' : 'Offline',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  astrologer.isOnline == true
                                      ? AppColors.sucessPrimary
                                      : AppColors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Enhanced pricing section with discounts
                    Column(
                      children: [
                        // Chat pricing
                        _buildPricingRow(
                          'Chat',
                          astrologer.chatMrpPerMinute,
                          astrologer.consultationRate,
                          hasChatDiscount,
                          isDark,
                        ),
                        const SizedBox(height: 4),
                        // Call pricing
                        _buildPricingRow(
                          'Call',
                          astrologer.callMrpPerMinute,
                          astrologer.callDpPerMinute,
                          hasCallDiscount,
                          isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Action Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed:
                        () => CallChatConfirmationDialog.show(
                          context: context,
                          astrologerPhoto: astrologer.profilePicture,
                          onConfirm: (value) {
                            Get.back();
                            controller.astrologerBook(
                              endTime: value,
                              astrologerId: astrologer.astrologerId,
                              type: "Chat",
                              astrologerPhoto: astrologer.profilePicture,
                            );
                          },
                          onWalletRedirect: () {
                            Get.toNamed(Routes.WALLET);
                          },
                          rate:
                              astrologer.consultationRate ??
                              astrologer.chatMrpPerMinute,
                          type: 'Chat',
                          astrologerName:
                              "${astrologer.firstName ?? ""} ${astrologer.lastName ?? ""}",
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat, size: 16, color: AppColors.white),
                        SizedBox(width: 10),
                        const Text('Chat', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed:
                        () => CallChatConfirmationDialog.show(
                          context: context,
                          astrologerPhoto: astrologer.profilePicture,
                          onConfirm: (value) {
                            Get.back();
                            controller.astrologerBook(
                              endTime: value,
                              astrologerPhoto: astrologer.profilePicture,
                              astrologerId: astrologer.astrologerId,
                              type: "Call",
                            );
                          },
                          onWalletRedirect: () {
                            Get.toNamed(Routes.WALLET);
                          },
                          rate:
                              astrologer.callDpPerMinute ??
                              astrologer.callMrpPerMinute,
                          type: 'Call',
                          astrologerName:
                              "${astrologer.firstName ?? ""} ${astrologer.lastName ?? ""}",
                        ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentColor,
                      side: BorderSide(color: AppColors.accentColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.call, size: 16),
                        SizedBox(width: 10),
                        const Text('Call', style: TextStyle(fontSize: 12)),
                      ],
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

  // Helper method to build pricing rows with discount display
  Widget _buildPricingRow(
    String type,
    double? originalPrice,
    double? discountedPrice,
    bool hasDiscount,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(
          type == 'Chat' ? Icons.chat_bubble_outline : Icons.call,
          size: 14,
          color: AppColors.accentColor,
        ),
        const SizedBox(width: 4),
        Text(
          '$type: ',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color:
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
        ),
        if (hasDiscount && discountedPrice != null) ...[
          // Show crossed out original price
          Text(
            '₹${originalPrice?.toStringAsFixed(0)}/min',
            style: TextStyle(
              fontSize: 10.sp,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.grey,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 4),
          // Show discounted price
          Text(
            '₹${discountedPrice.toStringAsFixed(0)}/min',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 4),

          // Discount indicator
        ] else ...[
          // Show regular price when no discount
          Text(
            '₹${originalPrice?.toStringAsFixed(0) ?? ""}/min',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.accentColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultAvatar(String initial) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initial.toUpperCase(),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void showFilterDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor:
                isDark ? AppColors.darkSurface : AppColors.lightSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: FilterDialogContent(isDark: isDark),
            ),
          ),
    );
  }
}

// Filter Dialog Content Widget
class FilterDialogContent extends StatefulWidget {
  final bool isDark;

  const FilterDialogContent({super.key, required this.isDark});

  @override
  State<FilterDialogContent> createState() => _FilterDialogContentState();
}

class _FilterDialogContentState extends State<FilterDialogContent> {
  String selectedLanguage = "All";
  String selectedRating = "Rating";

  final astrologersController = Get.find<AstrologersController>();

  @override
  void initState() {
    selectedLanguage = astrologersController.selectedLanguage;
    selectedRating = astrologersController.selectedRating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter & Sort",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        widget.isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color:
                        widget.isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Content - Similar to bottom sheet but more compact
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCompactLanguageSection(),
                    SizedBox(height: 20.h),
                    _buildCompactRatingSection(),
                    SizedBox(height: 20.h),
                    _buildCompactActionButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Compact versions of the sections for dialog
  Widget _buildCompactLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Languages",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:
                widget.isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children:
              [
                "All",
                "Hindi",
                "English",
              ].map((language) => _buildCompactLanguageChip(language)).toList(),
        ),
      ],
    );
  }

  Widget _buildCompactLanguageChip(String language) {
    bool isSelected = selectedLanguage == language;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color:
              isSelected
                  ? AppColors.primaryColor
                  : (widget.isDark
                      ? AppColors.darkBackground
                      : Colors.grey.shade200),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primaryColor
                    : (widget.isDark
                        ? AppColors.darkDivider
                        : Colors.grey.shade300),
            width: 1,
          ),
        ),
        child: Text(
          language,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color:
                isSelected
                    ? AppColors.white
                    : (widget.isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sort by Rating",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color:
                widget.isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Column(
          children: [
            _buildCompactRatingOption("default", "Rating"),
            _buildCompactRatingOption("high_to_low", "High to Low"),
            _buildCompactRatingOption("low_to_high", "Low to High"),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactRatingOption(String value, String title) {
    return RadioListTile<String>(
      value: value,
      groupValue: selectedRating,
      onChanged: (String? value) {
        setState(() {
          selectedRating = value ?? "default";
        });
      },
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          color:
              widget.isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
        ),
      ),
      activeColor: AppColors.primaryColor,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildCompactActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              setState(() {
                astrologersController.selectedLanguage = "";
                astrologersController.selectedRating = "";
                Navigator.pop(context);
              });
            },
            child: Text(
              "Clear",
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              log(
                "Applied filters - Language: $selectedLanguage, Rating: $selectedRating",
              );
              astrologersController.selectedLanguage = selectedLanguage;
              astrologersController.selectedRating = selectedRating;
              astrologersController.fetchAstrologerData();
              Navigator.pop(context);
              // Apply your filters here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h),
            ),
            child: Text("Apply", style: TextStyle(fontSize: 13)),
          ),
        ),
      ],
    );
  }
}

// // Filter Bottom Sheet Widget
// class FilterBottomSheet extends StatefulWidget {
//   final bool isDark;

//   const FilterBottomSheet({super.key, required this.isDark});

//   @override
//   State<FilterBottomSheet> createState() => _FilterBottomSheetState();
// }

// class _FilterBottomSheetState extends State<FilterBottomSheet> {
//   String selectedLanguage = "All";
//   String selectedRating = "default";

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: widget.isDark ? AppColors.darkSurface : AppColors.lightSurface,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20.r),
//           topRight: Radius.circular(20.r),
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: 20.w,
//           right: 20.w,
//           top: 20.h,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with close button
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Filters",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color:
//                         widget.isDark
//                             ? AppColors.darkTextPrimary
//                             : AppColors.lightTextPrimary,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => Navigator.pop(context),
//                   icon: Icon(
//                     Icons.close,
//                     color:
//                         widget.isDark
//                             ? AppColors.darkTextSecondary
//                             : AppColors.lightTextSecondary,
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 20.h),

//             // Language Filter Section
//             _buildLanguageSection(),

//             SizedBox(height: 30.h),

//             // Rating Sort Section
//             _buildRatingSection(),

//             SizedBox(height: 30.h),

//             // Action Buttons
//             _buildActionButtons(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLanguageSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Languages",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color:
//                 widget.isDark
//                     ? AppColors.darkTextPrimary
//                     : AppColors.lightTextPrimary,
//           ),
//         ),
//         SizedBox(height: 12.h),
//         Wrap(
//           spacing: 8.w,
//           runSpacing: 8.h,
//           children:
//               [
//                 "All",
//                 "Hindi",
//                 "English",
//                 "Bengali",
//                 "Tamil",
//                 "Telugu",
//                 "Gujarati",
//                 "Marathi",
//               ].map((language) => _buildLanguageChip(language)).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildLanguageChip(String language) {
//     bool isSelected = selectedLanguage == language;
//     final astrologersController = Get.find<AstrologersController>();
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedLanguage = language;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20.r),
//           color:
//               isSelected
//                   ? AppColors.primaryColor
//                   : (widget.isDark
//                       ? AppColors.darkBackground
//                       : Colors.grey.shade200),
//           border: Border.all(
//             color:
//                 isSelected
//                     ? AppColors.primaryColor
//                     : (widget.isDark
//                         ? AppColors.darkDivider
//                         : Colors.grey.shade300),
//             width: 1,
//           ),
//         ),
//         child: Text(
//           language,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//             color:
//                 isSelected
//                     ? AppColors.white
//                     : (widget.isDark
//                         ? AppColors.darkTextSecondary
//                         : AppColors.lightTextSecondary),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRatingSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Sort by Rating",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color:
//                 widget.isDark
//                     ? AppColors.darkTextPrimary
//                     : AppColors.lightTextPrimary,
//           ),
//         ),
//         SizedBox(height: 12.h),
//         Column(
//           children: [
//             _buildRatingOption("default", "Default Order", Icons.refresh),
//             _buildRatingOption(
//               "high_to_low",
//               "High to Low",
//               Icons.arrow_downward,
//             ),
//             _buildRatingOption(
//               "low_to_high",
//               "Low to High",
//               Icons.arrow_upward,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRatingOption(String value, String title, IconData icon) {
//     bool isSelected = selectedRating == value;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedRating = value;
//         });
//       },
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         margin: EdgeInsets.only(bottom: 8.h),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8.r),
//           color:
//               isSelected
//                   ? AppColors.primaryColor.withOpacity(0.1)
//                   : Colors.transparent,
//           border: Border.all(
//             color:
//                 isSelected
//                     ? AppColors.primaryColor
//                     : (widget.isDark
//                         ? AppColors.darkDivider
//                         : Colors.grey.shade300),
//             width: 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               size: 20,
//               color:
//                   isSelected
//                       ? AppColors.primaryColor
//                       : (widget.isDark
//                           ? AppColors.darkTextSecondary
//                           : AppColors.lightTextSecondary),
//             ),
//             SizedBox(width: 12.w),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
//                 color:
//                     isSelected
//                         ? AppColors.primaryColor
//                         : (widget.isDark
//                             ? AppColors.darkTextSecondary
//                             : AppColors.lightTextSecondary),
//               ),
//             ),
//             Spacer(),
//             if (isSelected)
//               Icon(Icons.check_circle, size: 20, color: AppColors.primaryColor),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context) {
//     final astrologersController = Get.find<AstrologersController>();
//     return Row(
//       children: [
//         // Clear All Button
//         Expanded(
//           child: OutlinedButton(
//             onPressed: () {
//               setState(() {
//                 selectedLanguage = "All";
//                 selectedRating = "default";
//               });
//             },
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: AppColors.primaryColor),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               padding: EdgeInsets.symmetric(vertical: 12.h),
//             ),
//             child: Text(
//               "Clear All",
//               style: TextStyle(
//                 color: AppColors.primaryColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),

//         SizedBox(width: 16.w),

//         // Apply Filter Button
//         Expanded(
//           child: ElevatedButton(
//             onPressed: () {
//               // Add your filter apply logic here
//               (
//                 astrologersController.fetchAstrologerData(),
//                 "Applied filters - Language: $selectedLanguage, Rating: $selectedRating",
//               );

//               // Close the bottom sheet
//               Navigator.pop(context);

//               // Apply filters to controller
//               // controller.filterByLanguage(selectedLanguage);
//               // controller.sortByRating(selectedRating);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryColor,
//               foregroundColor: AppColors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               padding: EdgeInsets.symmetric(vertical: 12.h),
//             ),
//             child: Text(
//               "Apply Filters",
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
