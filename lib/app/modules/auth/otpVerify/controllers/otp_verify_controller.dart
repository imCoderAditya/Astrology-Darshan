// OTP Verify Controller
import 'dart:async';
import 'dart:developer';

import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/modules/auth/login/controllers/login_controller.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/app/services/firebase/firebase_services.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
// Import your custom SnackBar class

class OtpVerifyController extends GetxController {
  final RxString otpCode = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool canResend = false.obs;
  final RxInt resendTimer = 60.obs;

  String? phoneNumber;
  String? fmcToken;

  final loginController = Get.find<LoginController>();
  @override
  void onInit() {
    super.onInit();
    getToken();
    phoneNumber = Get.arguments ?? "";
    debugPrint("Phone Number: $phoneNumber");
    startResendTimer();
  }

  void getToken() async {
    fmcToken = await FirebaseServices.firebaseToken();
  }

  Timer? _timer;

  void startResendTimer() {
    canResend.value = false;
    resendTimer.value = 60;

    _timer?.cancel(); // cancel old timer if still running
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void onOtpChanged(String otp) {
    otpCode.value = otp;
  }

  void onOtpCompleted(String otp) {
    otpCode.value = otp;
    verifyOtp();
  }

  Future<void> verifyOtp() async {
    // if (otpCode.value.length != 6) return;
    if (otpCode.value.length != 6) {
      SnackBarUiView.showError(message: 'Please Enter OTO');
      return;
    }
    isLoading.value = true;

    try {
      // Example:
      final res = await BaseClient.post(
        api: EndPoint.otpVerify,
        data: {
          "PhoneNumber": phoneNumber,
          "Otp": otpCode.value,
          "Fcm": fmcToken,
        },
      );
      if (res != null && res.statusCode == 200 && res.data["status"] == true) {
        Get.offAllNamed(Routes.NAV);
        final int userId = res.data["user"]["UserID"] ?? 0;
        final int custumerId = res.data["user"]["CustomerID"] ?? 0;
        LocalStorageService.saveLogin(userId: userId.toString());
        LocalStorageService.saveCustomerIdLogin(
          userCustomerId: custumerId.toString(),
        );
        log("UserId : $userId");
      } else {
        SnackBarUiView.showError(
          message: res.data["message"] ?? "",
          icon: Icons.check_circle,
        );
      }
    } catch (e) {
      SnackBarUiView.showError(
        message: 'Verification failed: ${e.toString()}',
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    GlobalLoader.show();

    await loginController.onLogin();
    startResendTimer();
    GlobalLoader.hide();
  }

  void clearOtp() {
    otpCode.value = '';
  }
}
