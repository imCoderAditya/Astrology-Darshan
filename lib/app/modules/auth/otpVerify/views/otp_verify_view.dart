// OTP Verify Page - Enhanced UI
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/modules/auth/otpVerify/controllers/otp_verify_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class OtpVerifyView extends StatelessWidget {
  const OtpVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OtpVerifyController());
    final otpPinFieldController = GlobalKey<OtpPinFieldState>();

    return GetBuilder<OtpVerifyController>(
      init: OtpVerifyController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              Get.isDarkMode
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
          body: SafeArea(
            child: Stack(
              children: [
                // Background gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Get.isDarkMode
                            ? AppColors.darkBackground
                            : AppColors.lightBackground,
                        Get.isDarkMode
                            ? AppColors.darkBackground.withValues(alpha: 0.8)
                            : AppColors.primaryColor.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                ),

                // Floating circles decoration
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: -30,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentColor.withValues(alpha: 0.08),
                    ),
                  ),
                ),

                // Main content
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Custom App Bar
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    Get.isDarkMode
                                        ? AppColors.darkSurface
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color:
                                      Get.isDarkMode
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                ),
                                onPressed: () => Get.back(),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Verify OTP',
                              style: Get.theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color:
                                    Get.isDarkMode
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(
                              width: 48,
                            ), // Balance the back button
                          ],
                        ),

                        const SizedBox(height: 60),

                        // Animated Header Icon with gradient background
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 800),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primaryColor,
                                      AppColors.primaryColor.withValues(
                                        alpha: 0.8,
                                      ),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(60),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.verified_user,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 40),

                        // Title with animation
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 600),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Text(
                                  'Enter Verification Code',
                                  style: Get.theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color:
                                            Get.isDarkMode
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary,
                                        letterSpacing: -0.5,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        // Description with better styling
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                'We have sent a 6-digit verification code to',
                                style: Get.theme.textTheme.bodyLarge?.copyWith(
                                  color:
                                      Get.isDarkMode
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primaryColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  controller.phoneNumber ?? "6386407546",
                                  style: Get.theme.textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor,
                                        letterSpacing: 1.2,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Enhanced OTP Pin Field
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:
                                Get.isDarkMode
                                    ? AppColors.darkSurface.withValues(
                                      alpha: 0.5,
                                    )
                                    : Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Obx(() {
                            if (controller.otpCode.value.isEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                otpPinFieldController.currentState?.clearOtp();
                              });
                            }

                            return OtpPinField(
                              fieldHeight: 40.h,
                              fieldWidth: 40.w,
                              key: otpPinFieldController,
                              textInputAction: TextInputAction.done,
                              onSubmit: controller.onOtpCompleted,
                              onChange: controller.onOtpChanged,
                              otpPinFieldStyle: OtpPinFieldStyle(
                                fieldPadding: 8, // ✅ spacing between boxes
                                fieldBorderRadius: 8, // ✅ बॉक्स corners rounded
                                fieldBorderWidth: 2,
                                defaultFieldBorderColor: AppColors.primaryColor
                                    .withValues(alpha: 0.5),

                                activeFieldBorderColor: AppColors.primaryColor,
                                filledFieldBorderColor: AppColors.primaryColor,
                                defaultFieldBackgroundColor: AppColors
                                    .primaryColor
                                    .withValues(alpha: 0.09),
                                activeFieldBackgroundColor: AppColors.white,
                                filledFieldBackgroundColor: AppColors
                                    .primaryColor
                                    .withValues(alpha: 0.15),
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Get.isDarkMode
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                ),
                              ),
                              maxLength: 6,
                              showCursor: true,
                              cursorColor: AppColors.primaryColor,
                              upperChild: const SizedBox(height: 16),
                              otpPinFieldDecoration:
                                  OtpPinFieldDecoration
                                      .defaultPinBoxDecoration, // ✅ बॉक्स जैसा डिज़ाइन
                            );
                          }),
                        ),

                        const SizedBox(height: 50),

                        // Enhanced Verify Button
                        Obx(
                          () => Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow:
                                  controller.otpCode.value.length == 6
                                      ? [
                                        BoxShadow(
                                          color: AppColors.primaryColor
                                              .withValues(alpha: 0.4),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ]
                                      : [],
                            ),
                            child: ElevatedButton(
                              onPressed:
                                  () =>
                                      controller.isLoading.value ||
                                              controller.otpCode.value.length !=
                                                  6
                                          ? null
                                          : controller.verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.otpCode.value.length == 6
                                        ? AppColors.primaryColor
                                        : Get.isDarkMode
                                        ? AppColors.darkDivider
                                        : AppColors.lightDivider,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child:
                                  controller.isLoading.value
                                      ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Verifying...',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.verified_user_outlined,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Verify OTP',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  controller
                                                              .otpCode
                                                              .value
                                                              .length !=
                                                          6
                                                      ? AppColors.green
                                                      : AppColors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Enhanced Resend Section
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color:
                                      Get.isDarkMode
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Didn't receive the code? ",
                                  style: Get.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        color:
                                            Get.isDarkMode
                                                ? AppColors.darkTextSecondary
                                                : AppColors.lightTextSecondary,
                                      ),
                                ),
                                if (controller.canResend.value)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.primaryColor
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: controller.resendOtp,
                                      child: Text(
                                        'Resend',
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Get.isDarkMode
                                              ? AppColors.darkSurface
                                              : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.timer_outlined,
                                          size: 14,
                                          color:
                                              Get.isDarkMode
                                                  ? AppColors.darkTextSecondary
                                                  : AppColors
                                                      .lightTextSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${controller.resendTimer.value}s',
                                          style: Get.theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color:
                                                    Get.isDarkMode
                                                        ? AppColors
                                                            .darkTextSecondary
                                                        : AppColors
                                                            .lightTextSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Enhanced Footer
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:
                                Get.isDarkMode
                                    ? AppColors.darkSurface.withValues(
                                      alpha: 0.3,
                                    )
                                    : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  Get.isDarkMode
                                      ? AppColors.darkDivider.withValues(
                                        alpha: 0.3,
                                      )
                                      : AppColors.lightDivider.withValues(
                                        alpha: 0.5,
                                      ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.security,
                                size: 18,
                                color:
                                    Get.isDarkMode
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'By verifying, you agree to our Terms of Service and Privacy Policy',
                                  style: Get.theme.textTheme.bodySmall
                                      ?.copyWith(
                                        color:
                                            Get.isDarkMode
                                                ? AppColors.darkTextSecondary
                                                : AppColors.lightTextSecondary,
                                        height: 1.4,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
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
}
