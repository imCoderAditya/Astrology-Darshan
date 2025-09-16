// login_controller.dart
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Text Controllers
  final mobileNumberController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final isSendBtnVisible = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {
    mobileNumberController.dispose();

    super.onClose();
  }

  // Toggle password visibility
  void isSendButtonVisible(String value) {
    if (value.length == 10) {
      isSendBtnVisible.value = true;
    } else {
      isSendBtnVisible.value = false;
    }
  }

  // Validate form
  bool _validateForm() {
    if (mobileNumberController.text.trim().isEmpty) {
      SnackBarUiView.showError(
        message: 'Please enter your mobile number',
        icon: Icons.email_outlined,
      );
      return false;
    }

    if (!GetUtils.isPhoneNumber(mobileNumberController.text.trim())) {
      SnackBarUiView.showError(
        message: 'Please enter a valid mobile number',
        icon: Icons.email_outlined,
      );
      return false;
    }

    return true;
  }

  // Login method
  Future<void> onLogin() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      // Example:
      final res = await BaseClient.post(
        api: EndPoint.sendOTP,
        data: {
          "PhoneNumber": mobileNumberController.text,
          "usertype": "Customer",
        },
      );
      if (res != null && res.statusCode == 200 && res.data["Status"] == true) {
        if (res.data["Type"] == "Registered") {
          Get.toNamed(
            Routes.OTP_VERIFY,
            arguments: mobileNumberController.text,
          );
          SnackBarUiView.showSuccess(
            message: res.data["Message"] ?? "",
            icon: Icons.check_circle,
          );
        } else {
          // Get.toNamed(Routes.SIGNUP, arguments: mobileNumberController.text);
          SnackBarUiView.showSuccess(
            message: res.data["Message"] ?? "",
            icon: Icons.check_circle,
          );
        }
      } else {
        SnackBarUiView.showError(
          message: res.data["Message"] ?? "",
          icon: Icons.check_circle,
        );
      }
    } catch (e) {
      SnackBarUiView.showError(
        message: 'Something went wrong',
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot password
  void onForgotPassword() {
    // Navigate to forgot password screen
    // Get.toNamed('/forgot-password');
    SnackBarUiView.showInfo(
      message: 'Forgot password feature coming soon!',
      icon: Icons.info_outline,
    );
  }

  // Social login methods
  void onGoogleLogin() {
    SnackBarUiView.showInfo(
      message: 'Google login coming soon!',
      icon: Icons.g_mobiledata,
    );
  }

  void onFacebookLogin() {
    SnackBarUiView.showInfo(
      message: 'Facebook login coming soon!',
      icon: Icons.facebook,
    );
  }

  void onAppleLogin() {
    SnackBarUiView.showInfo(
      message: 'Apple login coming soon!',
      icon: Icons.apple,
    );
  }

  // Navigate to sign up
  void onSignUp() {
    // Get.toNamed('/signup');
    SnackBarUiView.showInfo(
      message: 'Sign up feature coming soon!',
      icon: Icons.person_add,
    );
  }
}
