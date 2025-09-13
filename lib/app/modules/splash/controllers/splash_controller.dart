import 'dart:math' as math;

import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/modules/liveBroadCastAstrology/controllers/live_astrology_controller.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> logoAnimation;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> rotationAnimation;
  late Animation<double> starsAnimation;

  var loadingProgress = 0.0.obs;
  var loadingText = "Initializing...".obs;

  final List<String> loadingTexts = [
    "Initializing...",
    "Reading the stars...",
    "Aligning planets...",
    "Connecting to cosmic energy...",
    "Preparing your destiny...",
    "Almost ready...",
  ];

  final liveAstrologyController = Get.put(LiveAstrologyController());
  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startSplashSequence();
    liveAstrologyController.liveAstrologerAPI();
  }

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );

    starsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  void _startSplashSequence() async {
    // Start animations
    animationController.forward();

    // Simulate loading process
    for (int i = 0; i < loadingTexts.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      loadingText.value = loadingTexts[i];
      loadingProgress.value = (i + 1) / loadingTexts.length;
    }

    // Wait for animation to complete
    await animationController.forward();

    // Add final delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Navigate to next screen
    _navigateToNext();
  }

  void _navigateToNext() async {
    bool isLogin = await BaseClient.isAuthenticated();
    // Replace with your actual navigation logic
    isLogin
        ? Get.offAllNamed(Routes.NAV)
        : Get.offAllNamed(Routes.LOGIN); // or your main screen route

    // For demo purposes, show a snackbar
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
