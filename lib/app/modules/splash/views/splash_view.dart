// ignore_for_file: deprecated_member_use

import 'dart:math' as math;

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/modules/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1A0B2E), // Deep purple
              Color(0xFF0F0519), // Almost black
              Color(0xFF000000), // Pure black
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Stars
            _buildAnimatedStars(controller),

            // Floating Particles
            _buildFloatingParticles(controller),

            // Main Content - Fixed centering
            Center(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo Section
                    Image.asset("assets/images/logo.png", height: 220.h, width: 220.w),
                    // _buildLogoSection(controller),
                    Column(
                      children: [
                        // App Name
                        _buildAppName(controller),

                        // Tagline
                        _buildTagline(controller),
                      ],
                    ),

                    _buildLoadingSection(controller),

                    // Loading Section
                  ],
                ),
              ),
            ),

            // Shooting Stars
            _buildShootingStars(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedStars(SplashController controller) {
    return AnimatedBuilder(
      animation: controller.starsAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: StarFieldPainter(
            animationValue: controller.starsAnimation.value,
            rotationValue: controller.rotationAnimation.value,
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticles(SplashController controller) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return Stack(
          children: List.generate(20, (index) {
            final delay = index * 0.1;
            final animationValue = (controller.animationController.value - delay).clamp(0.0, 1.0);

            // Get screen size for proper positioning
            final screenSize = MediaQuery.of(Get.context!).size;

            return Positioned(
              left: (50 + (index * 15) % (screenSize.width - 100)).clamp(0.0, screenSize.width - 50),
              top: (100 + (index * 25) % (screenSize.height - 200)).clamp(0.0, screenSize.height - 100),
              child: Opacity(
                opacity: (animationValue * 0.6).clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(
                    math.sin(controller.animationController.value * 2 * math.pi + index) * 20,
                    math.cos(controller.animationController.value * 2 * math.pi + index) * 15,
                  ),
                  child: Container(
                    width: 4 + (index % 3),
                    height: 4 + (index % 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.8),
                      boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildAppName(SplashController controller) {
    return AnimatedBuilder(
      animation: controller.fadeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - controller.fadeAnimation.value) * 30),
          child: Opacity(
            opacity: controller.fadeAnimation.value.clamp(0.0, 1.0),
            child: ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [AppColors.accentColor, AppColors.primaryColor, AppColors.secondaryPrimary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
              child: const Text(
                "Astro Darshan",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 3, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline(SplashController controller) {
    return AnimatedBuilder(
      animation: controller.fadeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - controller.fadeAnimation.value) * 20),
          child: Opacity(
            opacity: (controller.fadeAnimation.value * 0.8).clamp(0.0, 1.0),
            child: const Text(
              "Tagline -AstroDarshan ho saath, toh fikr ki kya baat!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70, letterSpacing: 1, fontStyle: FontStyle.italic),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection(SplashController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Loading Text
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                controller.loadingText.value,
                key: ValueKey(controller.loadingText.value),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 1),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Progress Bar Container - Fixed width
          Container(
            width: MediaQuery.of(Get.context!).size.width * 0.7, // Fixed width
            height: 4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: Colors.white.withOpacity(0.2)),
            child: Obx(
              () => ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: (MediaQuery.of(Get.context!).size.width * 0.7) * controller.loadingProgress.value,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.accentColor, AppColors.primaryColor, AppColors.secondaryPrimary],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Progress Percentage
          Obx(
            () => Text(
              "${(controller.loadingProgress.value * 100).toInt()}%",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 12, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShootingStars(SplashController controller) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(Get.context!).size.width;

        return Stack(
          children: List.generate(3, (index) {
            final delay = index * 1.5;
            final progress = ((controller.animationController.value * 3 - delay) % 3) / 3;

            if (progress < 0 || progress > 1) return const SizedBox.shrink();

            return Positioned(
              left: -100 + (screenWidth + 200) * progress,
              top: 100 + index * 200,
              child: Opacity(
                opacity: (math.sin(progress * math.pi) * 0.8).clamp(0.0, 1.0),
                child: Container(
                  width: 100,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.white.withOpacity(0.8), Colors.transparent],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class StarFieldPainter extends CustomPainter {
  final double animationValue;
  final double rotationValue;

  StarFieldPainter({required this.animationValue, required this.rotationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent star positions

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 0.5;

      // Twinkling effect
      final twinkle = math.sin(animationValue * 4 * math.pi + i) * 0.5 + 0.5;
      paint.color = Colors.white.withOpacity((twinkle * 0.8).clamp(0.0, 1.0));

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ZodiacRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw zodiac symbols positions
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
