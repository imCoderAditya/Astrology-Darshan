// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:astrology/app/data/models/astrologer/astrologer_model.dart';
import 'package:astrology/app/data/models/astrologer/live_astrologer_model.dart';
import 'package:astrology/app/modules/astrologerDetails/views/astrologer_details_view.dart';
import 'package:astrology/app/modules/ecommerce/store/views/store_view.dart';
import 'package:astrology/app/modules/home/controllers/home_controller.dart';
import 'package:astrology/app/modules/liveBroadCastAstrology/controllers/live_astrology_controller.dart';
import 'package:astrology/app/modules/liveBroadCastAstrology/views/live_astrology_view.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/components/custom_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Obx(
          () => Scaffold(
            backgroundColor: _backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: _buildAppBar(),
            ),
            drawer: AppDrawer(),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildHeroSliderBanner(),
                        _buildAstrologyServicesSection(),
                        _buildLiveAstrologersSection(),
                        _buildAstroPujaShopSection(),
                        (controller
                                    .astrologerModel
                                    .value
                                    ?.data
                                    ?.astrologers
                                    ?.isEmpty ??
                                true)
                            ? SizedBox()
                            : _buildAstrologersSection(),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Theme getters with proper reactive updates
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

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        boxShadow: [
          BoxShadow(
            color: _cardShadowColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu, color: _textPrimary)),
        title: Text(
          'Astro Darshan',
          style: AppTextStyles.brandLogo.copyWith(
            color: _textPrimary,
            fontSize: 24.sp,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: _dividerColor, width: 1),
            ),
            child: IconButton(
              onPressed: () {
                Get.toNamed(Routes.NOTIFICATION);
              },
              icon: Icon(
                Icons.notifications_outlined,
                color: _textSecondary,
                size: 22.sp,
              ),
            ),
          ),
          // Wallet button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accentColor, AppColors.primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              onPressed: () {
                Get.toNamed(Routes.WALLET);
              },
              icon: const Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSliderBanner() {
    return Container(
      height: 180.h,
      margin: EdgeInsets.all(8.r),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
            items:
                controller.imageSliderModel.value?.data?.map((banners) {
                  return GestureDetector(
                    onTap: () {
                      debugPrint('Banner tapped: ${banners.typee}');
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: CachedNetworkImage(
                        imageUrl: banners.imageUrl ?? "",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder:
                            (context, url) => Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        errorWidget:
                            (context, url, error) => Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  );
                }).toList() ??
                [],
            options: CarouselOptions(
              clipBehavior: Clip.none,
              height: 400,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              onPageChanged: (index, item) {
                debugPrint('Page changed to $index');
                controller.currentBannerIndex.value=index;
              },
              scrollDirection: Axis.horizontal,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.imageSliderModel.value?.data?.length ?? 0,
                (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    height: 8.h,
                    width:
                        controller.currentBannerIndex.value == index
                            ? 20.w
                            : 8.w,
                    decoration: BoxDecoration(
                      color:
                          controller.currentBannerIndex.value == index
                              ? AppColors.primaryColor
                              : AppColors.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologyServicesSection() {
    final services = [
      {
        'icon': Icons.auto_awesome,
        'title': 'Horoscope',
        'color': AppColors.accentColor,
        "root": null,
      },
      {
        'icon': Icons.account_circle,
        'title': 'Kundali',
        'color': Colors.pink,
        "root": Routes.KUNDALIFORM,
      },
      {
        'icon': Icons.favorite,
        'title': 'Matchmaking',
        'color': Colors.lightBlue,
        "root": Routes.KUNDALI_MATCHING,
      },
      {'icon': Icons.casino, 'title': 'Numerology', 'color': Colors.orange},
      {'icon': Icons.style, 'title': 'Tarot', 'color': Colors.purple},
      // {'icon': Icons.schedule, 'title': 'Muhurat', 'color': Colors.blueGrey},
      {'icon': Icons.healing, 'title': 'Remedies', 'color': Colors.deepOrange},
      // {
      //   'icon': Icons.more_horiz,
      //   'title': 'More',
      //   'color': AppColors.primaryColor,
      // },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Astrology Services',
            style: AppTextStyles.headlineMedium().copyWith(color: _textPrimary),
          ),
          SizedBox(height: 15.h),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              mainAxisExtent: 90.h,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildServiceCard(
                onTap: () {
                  Get.toNamed(service["root"].toString());
                },
                service['icon'] as IconData,
                service['title'] as String,
                service['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    IconData icon,
    String title,
    Color color, {
    void Function()? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _dividerColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: _cardShadowColor,
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 28.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                style: AppTextStyles.small().copyWith(
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAstrologersSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Astrologers',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: _textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.ASTROLOGERS),
                  child: Text(
                    'View All',
                    style: AppTextStyles.caption().copyWith(
                      fontWeight: FontWeight.w500,
                      color: _textPrimary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              itemCount:
                  controller.astrologerModel.value?.data?.astrologers?.length,
              itemBuilder: (context, index) {
                final astrologer =
                    controller.astrologerModel.value?.data?.astrologers?[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(AstrologerDetailsView(astrologer: astrologer));
                  },
                  child: _buildAstrologerCard(astrologer),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstrologerCard(Astrologer? astrologer) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _dividerColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: _cardShadowColor,
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(2.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topCenter,
                  colors: [AppColors.primaryColor, AppColors.accentColor],
                ),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: CircleAvatar(
                radius: 30.r,
                backgroundColor: _surfaceColor,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: astrologer?.profilePicture ?? "",
                    fit: BoxFit.cover,
                    width: 60.r,
                    height: 60.r,
                    placeholder:
                        (context, url) => Icon(
                          Icons.person,
                          color: AppColors.accentColor,
                          size: 35.sp,
                        ),
                    errorWidget:
                        (context, url, error) => Icon(
                          Icons.person,
                          color: AppColors.accentColor,
                          size: 35.sp,
                        ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "${astrologer?.firstName ?? ""} ${astrologer?.lastName ?? ""}",
              style: AppTextStyles.caption().copyWith(
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14.sp),
                Text(
                  ' ${astrologer?.rating ?? ""}',
                  style: AppTextStyles.small().copyWith(
                    fontWeight: FontWeight.w500,
                    color: _textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              astrologer?.specializations?.firstOrNull ?? "",
              style: AppTextStyles.small().copyWith(color: _textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topCenter,
                  colors: [AppColors.primaryColor, AppColors.accentColor],
                ),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Text(
                'Talk Now',
                style: AppTextStyles.small().copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveAstrologersSection() {
    return GetBuilder<LiveAstrologyController>(
      init: LiveAstrologyController(),
      builder: (controller) {
        return (controller.liveAstrologerModel.value?.liveAstrologer?.isEmpty ??
                false)
            ? SizedBox()
            : Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Live Astrologers',
                              style: AppTextStyles.headlineMedium().copyWith(
                                color: _textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.LIVE_ASTROLOGY);
                              },
                              child: Text(
                                "View More",
                                style: AppTextStyles.body().copyWith(
                                  color: _textPrimary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 120.h,
                    child: ListView.builder(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      itemCount: min(
                        controller
                                .liveAstrologerModel
                                .value
                                ?.liveAstrologer
                                ?.length ??
                            0,
                        10,
                      ),
                      itemBuilder: (context, index) {
                        final astrologer =
                            controller
                                .liveAstrologerModel
                                .value
                                ?.liveAstrologer?[index];

                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              LiveAstrologyView(
                                liveAstrologer:
                                    controller
                                        .liveAstrologerModel
                                        .value
                                        ?.liveAstrologer?[index],
                              ),
                            );
                          },
                          child: _buildLiveAstrologerCard(
                            index,
                            liveAstrologer: astrologer,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
      },
    );
  }

  Widget _buildLiveAstrologerCard(int index, {LiveAstrologer? liveAstrologer}) {
    final colors = [
      AppColors.accentColor,
      Colors.pink,
      Colors.blue,
      AppColors.primaryColor,
    ];

    return Container(
      width: 100.w,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.red.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.red.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  color: colors[index].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: CircleAvatar(
                  radius: 22.r,
                  backgroundColor: colors[index].withOpacity(0.2),
                  child:
                      liveAstrologer != null &&
                              (liveAstrologer.profilePicture?.isNotEmpty ??
                                  false)
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(22.r),
                            child: Image.network(
                              liveAstrologer.profilePicture ?? "",
                              width: 44.r,
                              height: 44.r,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // fallback to default design if image fails to load
                                return Icon(
                                  Icons.person,
                                  color: colors[index],
                                  size: 28.sp,
                                );
                              },
                            ),
                          )
                          : Icon(
                            Icons.person,
                            color: colors[index],
                            size: 28.sp,
                          ),
                ),
              ),

              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.all(4.r),
                child: Text(
                  "${liveAstrologer?.firstName ?? ""} ${liveAstrologer?.lastName ?? ""}",
                  style: AppTextStyles.small().copyWith(
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'LIVE',
                style: AppTextStyles.small().copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 8.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAstroPujaShopSection() {
    final shopItems = [
      {
        'icon': Icons.temple_buddhist,
        'title': 'Book Puja/Spell',
        'gradient': [AppColors.accentColor, Colors.purple],
      },
      // {
      //   'icon': Icons.auto_awesome,
      //   'title': 'Buy Yantras',
      //   'gradient': [Colors.blue, Colors.lightBlue],
      // },
      // {
      //   'icon': Icons.healing,
      //   'title': 'Remedies',
      //   'gradient': [Colors.pink, Colors.orange],
      // },
      {
        'icon': Icons.shopping_bag,
        'title': 'Astro Store',
        'gradient': [Colors.orange, AppColors.primaryColor],
      },
    ];

    return Container(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Astro Puja & Shop',
            style: AppTextStyles.headlineMedium().copyWith(color: _textPrimary),
          ),
          SizedBox(height: 15.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: 2.2,
            ),
            itemCount: shopItems.length,
            itemBuilder: (context, index) {
              final item = shopItems[index];
              return _buildShopCard(
                index,
                item['icon'] as IconData,
                item['title'] as String,
                item['gradient'] as List<Color>,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(
    int index,
    IconData icon,
    String title,
    List<Color> gradient,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (index == 0) {
              Get.toNamed(Routes.PUJA);
            } else {
              Get.to(StoreView(isBack: false));
            }
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.caption().copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
