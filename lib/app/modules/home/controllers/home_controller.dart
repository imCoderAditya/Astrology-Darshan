import 'dart:async';
import 'dart:convert';

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/astrologer/astrologer_model.dart';
import 'package:astrology/app/data/models/home/image_popup_model.dart';
import 'package:astrology/app/data/models/home/image_slider_model.dart';
import 'package:astrology/app/modules/home/components/popup_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  // Observable variables
  final currentBannerIndex = 0.obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final isDarkTheme = false.obs;

  // Controllers
  late PageController bannerController;
  late AnimationController fadeController;
  late AnimationController slideController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  final Rxn<AstrologerModel> _astrologerModel = Rxn<AstrologerModel>();
  Rxn<AstrologerModel> get astrologerModel => _astrologerModel;
  final Rxn<ImageSliderModel> _imageSliderModel = Rxn<ImageSliderModel>();
  Rxn<ImageSliderModel> get imageSliderModel => _imageSliderModel;
  final Rxn<PopupImageModel> _popupImageModel = Rxn<PopupImageModel>();
  Rxn<PopupImageModel> get popupImageModel => _popupImageModel;

  // Auto-scroll timer
  Timer? _bannerTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _startBannerAutoScroll();
    fetchImageSliderData();
    fetchAstrologerData();

    // Initialize theme based on system
    isDarkTheme.value = Get.isDarkMode;
  }

  void _initializeControllers() {
    bannerController = PageController();

    // Animation controllers
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Animations
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeInOut));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: slideController, curve: Curves.easeOutCubic),
    );

    // Start animations
    fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      slideController.forward();
    });
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (bannerController.hasClients) {
        int nextPage = (currentBannerIndex.value + 1) % 3;
        bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void onBannerChanged(int index) {
    currentBannerIndex.value = index;
  }

  void toggleTheme() {
    isDarkTheme.value = !isDarkTheme.value;
    Get.changeThemeMode(isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
  }

  void onServiceTap(String serviceName) {
    Get.snackbar(
      '🌟 Service Selected',
      'You selected $serviceName service',
      backgroundColor: AppColors.primaryColor.withOpacity(0.95),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 800),
      forwardAnimationCurve: Curves.easeOutBack,
      icon: const Icon(Icons.star, color: Colors.white),
    );
  }

  void onAstrologerTap(String astrologerName) {
    Get.snackbar(
      '📞 Connecting...',
      'Initiating call with $astrologerName',
      backgroundColor: AppColors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 600),
      icon: const Icon(Icons.phone, color: Colors.white),
    );
  }

  void onSearch(String query) {
    searchQuery.value = query;
    if (query.isNotEmpty) {
      Get.snackbar(
        '🔍 Searching',
        'Looking for "$query"...',
        backgroundColor: AppColors.accentColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> fetchAstrologerData() async {
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.astrologers}?page=1&limit=10",
      );
      if (res != null && res.statusCode == 200) {
        // Process the response here
        _astrologerModel.value = astrologerModelFromJson(json.encode(res.data));
      } else {
        LoggerUtils.error("Failed Astrologer List API: $res");
      }
    } catch (e) {
      LoggerUtils.error("Error fetching astrologer data: $e");
    } finally {
      update();
    }
  }

  Future<void> fetchImageSliderData() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(api: EndPoint.getSliders);
      if (res != null && res.statusCode == 200) {
        // Process the response here
        _imageSliderModel.value = imageSliderModelFromJson(
          json.encode(res.data),
        );
      } else {
        LoggerUtils.error("Failed Image Slider API: $res");
      }
    } catch (e) {
      LoggerUtils.error("Error fetching image slider data: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> fetchPopopData() async {
    try {
      final res = await BaseClient.get(api: EndPoint.getPopups);
      if (res != null && res.statusCode == 200) {
        // Process the response here
        popupImageModel.value = popupImageModelFromJson(json.encode(res.data));
      } else {
        LoggerUtils.error("Failed Image Slider API: $res");
      }
    } catch (e) {
      LoggerUtils.error("Error fetching image slider data: $e");
    } finally {
      update();
    }
  }

  @override
  void onReady() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchPopopData();
      await showPopupDialogBox();
    });
 

    super.onReady();
  }

  showPopupDialogBox() {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (context) => PopupView(),
    );
  }

  @override
  void onClose() {
    bannerController.dispose();
    fadeController.dispose();
    slideController.dispose();
    _bannerTimer?.cancel();
    super.onClose();
  }
}
