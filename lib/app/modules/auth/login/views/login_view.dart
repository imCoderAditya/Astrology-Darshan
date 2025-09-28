// Enhanced login_view.dart with Light & Dark Theme Support
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [
                      AppColors.darkBackground,
                      AppColors.darkBackground.withValues(alpha: 0.8),
                      AppColors.primaryColor.withValues(alpha: 0.2),
                    ]
                    : AppColors.headerGradientColors,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                bottom: -50,
                right: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isDark
                            ? AppColors.primaryColor.withValues(alpha: 0.06)
                            : AppColors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),

              // Main content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Enhanced App Logo with animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1000),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? AppColors.darkSurface
                                        : AppColors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        isDark
                                            ? Colors.black.withValues(
                                              alpha: 0.4,
                                            )
                                            : Colors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color:
                                        isDark
                                            ? AppColors.darkSurface.withValues(
                                              alpha: 0.8,
                                            )
                                            : AppColors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                    blurRadius: 15,
                                    offset: const Offset(0, -5),
                                  ),
                                ],
                                border:
                                    isDark
                                        ? Border.all(
                                          color: AppColors.darkDivider
                                              .withValues(alpha: 0.3),
                                          width: 1,
                                        )
                                        : null,
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(
                                "assets/images/logo.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Enhanced Welcome Text with animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
                              child: Column(
                                children: [
                                  Text(
                                    'Welcome Back',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      color:
                                          isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.white,
                                      letterSpacing: -1,
                                      shadows: [
                                        Shadow(
                                          color:
                                              isDark
                                                  ? Colors.black.withValues(
                                                    alpha: 0.5,
                                                  )
                                                  : Colors.black.withValues(
                                                    alpha: 0.3,
                                                  ),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Enter your phone number to continue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 50),

                      // Enhanced Login Form Card with theme support
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color:
                                      isDark
                                          ? AppColors.darkSurface.withValues(
                                            alpha: 0.9,
                                          )
                                          : AppColors.white.withValues(
                                            alpha: 0.95,
                                          ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          isDark
                                              ? Colors.black.withValues(
                                                alpha: 0.3,
                                              )
                                              : Colors.black.withValues(
                                                alpha: 0.15,
                                              ),
                                      blurRadius: 30,
                                      offset: const Offset(0, 15),
                                    ),
                                    BoxShadow(
                                      color:
                                          isDark
                                              ? AppColors.darkSurface
                                                  .withValues(alpha: 0.8)
                                              : AppColors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                      blurRadius: 20,
                                      offset: const Offset(0, -5),
                                    ),
                                  ],
                                  border: Border.all(
                                    color:
                                        isDark
                                            ? AppColors.darkDivider.withValues(
                                              alpha: 0.3,
                                            )
                                            : AppColors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Phone number label
                                    Text(
                                      'Mobile Number',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Enhanced Phone Field with theme support
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                isDark
                                                    ? Colors.black.withValues(
                                                      alpha: 0.2,
                                                    )
                                                    : Colors.black.withValues(
                                                      alpha: 0.05,
                                                    ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: TextField(
                                        controller:
                                            controller.mobileNumberController,
                                        keyboardType: TextInputType.phone,
                                        maxLength: 10,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        onChanged: (value){
                                          controller.isSendButtonVisible(value);
                                        },
                                        buildCounter:
                                            (
                                              context, {
                                              required currentLength,
                                              required isFocused,
                                              required maxLength,
                                            }) => null,
                                        style: TextStyle(
                                          
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              isDark
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.lightTextPrimary,
                                          letterSpacing: 1.2,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Mobile Number',
                                          hintStyle: TextStyle(
                                            color:
                                                isDark
                                                    ? AppColors
                                                        .darkTextSecondary
                                                        .withValues(alpha: 0.6)
                                                    : AppColors
                                                        .lightTextSecondary
                                                        .withValues(alpha: 0.6),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.2,
                                          ),
                                          prefixIcon: Container(
                                            margin: const EdgeInsets.all(12),
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.phone_android_rounded,
                                              color: AppColors.primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor:
                                              isDark
                                                  ? AppColors.darkBackground
                                                      .withValues(alpha: 0.5)
                                                  : Colors.grey.shade50,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 20,
                                              ),
                                              
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.primaryColor,
                                              width: 2.5,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide(
                                              color:
                                                  isDark
                                                      ? AppColors.darkDivider
                                                          .withValues(
                                                            alpha: 0.3,
                                                          )
                                                      : Colors.grey.shade200,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 32),

                                    // Enhanced Login Button with theme support
                                    Obx(() {
                                 
                                      final isEnabled =
                                          controller.isSendBtnVisible.value &&
                                          !controller.isLoading.value;

                                      return Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          gradient:
                                              isEnabled
                                                  ? LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      AppColors.primaryColor,
                                                      AppColors.primaryColor
                                                          .withOpacity(0.8),
                                                    ],
                                                  )
                                                  : null,
                                          color:
                                              isEnabled
                                                  ? null
                                                  : (isDark
                                                      ? AppColors.darkDivider
                                                      : Colors.grey.shade300),
                                          boxShadow:
                                              isEnabled
                                                  ? [
                                                    BoxShadow(
                                                      color: AppColors
                                                          .primaryColor
                                                          .withOpacity(0.4),
                                                      blurRadius: 15,
                                                      offset: const Offset(
                                                        0,
                                                        8,
                                                      ),
                                                    ),
                                                  ]
                                                  : null,
                                        ),
                                        child: ElevatedButton(
                                          onPressed:
                                              isEnabled
                                                  ? controller.onLogin
                                                  : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: AppColors.white,
                                            shadowColor: Colors.transparent,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child:
                                              controller.isLoading.value
                                                  ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        height: 22,
                                                        width: 22,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2.5,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                Color
                                                              >(
                                                                AppColors.white,
                                                              ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      const Text(
                                                        'Sending...',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(
                                                        Icons.send_rounded,
                                                        size: 20,
                                                        color: AppColors.white,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Send OTP',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                        ),
                                      );
                                    }),

                                    const SizedBox(height: 24),

                                    // Security note with theme support
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color:
                                            isDark
                                                ? AppColors.primaryColor
                                                    .withValues(alpha: 0.1)
                                                : Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              isDark
                                                  ? AppColors.primaryColor
                                                      .withValues(alpha: 0.3)
                                                  : Colors.blue.shade200,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.security_rounded,
                                            color:
                                                isDark
                                                    ? AppColors.primaryColor
                                                    : Colors.blue.shade600,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'We\'ll send a verification code to this number',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    isDark
                                                        ? AppColors
                                                            .darkTextSecondary
                                                        : Colors.blue.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Enhanced OR Divider with theme support
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 400),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1.5,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            isDark
                                                ? AppColors.darkTextSecondary
                                                    .withValues(alpha: 0.6)
                                                : AppColors.white.withValues(
                                                  alpha: 0.6,
                                                ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isDark
                                              ? AppColors.darkSurface
                                                  .withValues(alpha: 0.8)
                                              : AppColors.white.withValues(
                                                alpha: 0.15,
                                              ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            isDark
                                                ? AppColors.darkDivider
                                                    .withValues(alpha: 0.3)
                                                : AppColors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        color:
                                            isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1.5,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            isDark
                                                ? AppColors.darkTextSecondary
                                                    .withValues(alpha: 0.6)
                                                : AppColors.white.withValues(
                                                  alpha: 0.6,
                                                ),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // // Enhanced Sign Up Link with theme support
                      // TweenAnimationBuilder<double>(
                      //   tween: Tween(begin: 0.0, end: 1.0),
                      //   duration: const Duration(milliseconds: 200),
                      //   builder: (context, value, child) {
                      //     return Opacity(
                      //       opacity: value,
                      //       child: Container(
                      //         padding: const EdgeInsets.all(20),
                      //         decoration: BoxDecoration(
                      //           color:
                      //               isDark
                      //                   ? AppColors.darkSurface.withValues(
                      //                     alpha: 0.6,
                      //                   )
                      //                   : AppColors.white.withValues(
                      //                     alpha: 0.1,
                      //                   ),
                      //           borderRadius: BorderRadius.circular(16),
                      //           border: Border.all(
                      //             color:
                      //                 isDark
                      //                     ? AppColors.darkDivider.withValues(
                      //                       alpha: 0.3,
                      //                     )
                      //                     : AppColors.white.withValues(
                      //                       alpha: 0.3,
                      //                     ),
                      //             width: 1,
                      //           ),
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Icon(
                      //               Icons.person_add_outlined,
                      //               color:
                      //                   isDark
                      //                       ? AppColors.darkTextSecondary
                      //                       : AppColors.white.withValues(
                      //                         alpha: 0.8,
                      //                       ),
                      //               size: 18,
                      //             ),
                      //             const SizedBox(width: 8),
                      //             Text(
                      //               "Don't have an account? ",
                      //               style: TextStyle(
                      //                 color:
                      //                     isDark
                      //                         ? AppColors.darkTextSecondary
                      //                         : AppColors.white.withValues(
                      //                           alpha: 0.8,
                      //                         ),
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w500,
                      //               ),
                      //             ),
                      //             GestureDetector(
                      //               onTap: controller.onSignUp,
                      //               child: Container(
                      //                 padding: const EdgeInsets.symmetric(
                      //                   horizontal: 12,
                      //                   vertical: 4,
                      //                 ),
                      //                 decoration: BoxDecoration(
                      //                   color:
                      //                       isDark
                      //                           ? AppColors.primaryColor
                      //                               .withValues(alpha: 0.2)
                      //                           : AppColors.white.withValues(
                      //                             alpha: 0.2,
                      //                           ),
                      //                   borderRadius: BorderRadius.circular(8),
                      //                 ),
                      //                 child: Text(
                      //                   'Sign Up',
                      //                   style: TextStyle(
                      //                     color:
                      //                         isDark
                      //                             ? AppColors.primaryColor
                      //                             : AppColors.white,
                      //                     fontSize: 14,
                      //                     fontWeight: FontWeight.w700,
                      //                     letterSpacing: 0.5,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Background floating elements
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isDark
                            ? AppColors.primaryColor.withValues(alpha: 0.08)
                            : AppColors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                top: 150,
                left: -60,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isDark
                            ? AppColors.accentColor.withValues(alpha: 0.1)
                            : AppColors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),

              // Theme toggle button
              Positioned(
                top: 16,
                right: 16,
                child: GetBuilder<ThemeController>(
                  init: ThemeController(),
                  builder: (controller) {
                    return Container(
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? AppColors.darkSurface.withValues(alpha: 0.8)
                                : AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isDark
                                  ? AppColors.darkDivider.withValues(alpha: 0.3)
                                  : AppColors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          debugPrint("xcjc");
                          controller.toggleTheme();
                        },
                        icon: Icon(
                          isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color:
                              isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.white,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
