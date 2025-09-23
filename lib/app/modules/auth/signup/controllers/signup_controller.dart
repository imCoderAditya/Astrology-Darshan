// ignore_for_file: unnecessary_overrides

import 'dart:io';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class SignupController extends GetxController {
  // Text controllers
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final placeOfBirthController = TextEditingController();

  // Reactive variables
  final selectedImage = Rx<File?>(null);
  final dateOfBirth = Rx<DateTime?>(null);
  final timeOfBirth = Rx<TimeOfDay?>(null);
  final selectedGender = 'Male'.obs;
  final isLoading = false.obs;

  File? file;

  @override
  void onInit() {
    phoneController.text = Get.arguments;

    super.onInit();
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    phoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    placeOfBirthController.dispose();
    super.onClose();
  }

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85, // Compress image to reduce file size
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (pickedFile != null) {
        file = File(pickedFile.path);
        debugPrint("Image picked: ${file!.path}");
        selectedImage.value = file;
      } else {
        debugPrint("No image selected.");
      }
    } catch (e) {
      LoggerUtils.error("Error picking image: $e");
      SnackBarUiView.showError(
        message: "Failed to pick image. Please try again.",
      );
    }
  }

  void selectDate(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(
          const Duration(days: 6570),
        ), // 18 years ago
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
        helpText: 'Select your date of birth',
        cancelText: 'Cancel',
        confirmText: 'Select',
      );
      if (picked != null) {
        dateOfBirth.value = picked;
        debugPrint(
          "Date of Birth selected: ${AppDateUtils.formatToYMD(picked)}",
        );
      }
    } catch (e) {
      LoggerUtils.error("Error selecting date: $e");
      SnackBarUiView.showError(
        message: "Failed to select date. Please try again.",
      );
    }
  }

  void selectTime(BuildContext context) async {
    try {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 12, minute: 0),
        helpText: 'Select your birth time',
        cancelText: 'Cancel',
        confirmText: 'Select',
      );
      if (picked != null) {
        timeOfBirth.value = picked;
        debugPrint("Birth Time selected: ${picked.hour}:${picked.minute}");
      }
    } catch (e) {
      LoggerUtils.error("Error selecting time: $e");
      SnackBarUiView.showError(
        message: "Failed to select time. Please try again.",
      );
    }
  }

  String _formatTimeOfBirth(TimeOfDay? time) {
    if (time == null) return "";

    // Format to HH:mm:ss as expected by the API
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00";
  }

  Future<void> registerCustomer() async {
    isLoading.value = true;

    try {
      // Format data for API
      final dateOfBirthStr = AppDateUtils.formatToYMD(dateOfBirth.value!);
      final timeOfBirthStr = _formatTimeOfBirth(timeOfBirth.value);

      // Create FormData matching the curl request structure
      FormData formData = FormData.fromMap({
        "PhoneNumber": phoneController.text.trim(),
        "Otp": otpController.text,
        "Email": emailController.text.trim(),
        "FirstName": firstNameController.text.trim(),
        "LastName": lastNameController.text.trim(),
        "DateOfBirth": dateOfBirthStr,
        "TimeOfBirth": timeOfBirthStr,
        "PlaceOfBirth": placeOfBirthController.text.trim(),
        "Gender": selectedGender.value,
        "File":
            file != null
                ? await MultipartFile.fromFile(
                  file!.path,
                  filename: file!.path.split('/').last,
                )
                : null,
      });

      LoggerUtils.debug("Registering customer with data: ${formData.fields}");

      final res = await BaseClient.post(
        api: EndPoint.registerCustomer, // You'll need to add this endpoint
        formData: formData,
      );

      if (res != null && res.statusCode == 201) {
        LoggerUtils.error("Register :- ${res.data}");
        final userId = res.data["userId"].toString();
        final astrologerId = res.data["astrologerId"];
        // LocalStorageService.saveLogin(
        //   userId: userId,
        //   userAstrologerId: astrologerId,
        // );
        Get.offNamed(
          Routes.LOGIN,
          arguments: {"phoneNumber": phoneController.text.trim()},
        );
        debugPrint("UserId ===>$userId");
        debugPrint("UserId ===>$astrologerId");
      } else {
        SnackBarUiView.showError(message: res.data["message"] ?? "");
        LoggerUtils.error("Failed Register :- ${res.data}");
      }
    } catch (e) {
      LoggerUtils.error("Registration error: $e");
      SnackBarUiView.showError(
        message:
            "Something went wrong. Please check your connection and try again.",
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void validation() {
    // Profile picture validation (optional for customers, but recommended)
    if (file == null) {
      SnackBarUiView.showError(message: "Please select a profile picture");
      return;
    }

    // First name validation
    if (firstNameController.text.trim().isEmpty) {
      SnackBarUiView.showError(message: "Please enter your first name");
      return;
    }

    if (firstNameController.text.trim().length < 2) {
      SnackBarUiView.showError(
        message: "First name must be at least 2 characters",
      );
      return;
    }

    // Last name validation
    if (lastNameController.text.trim().isEmpty) {
      SnackBarUiView.showError(message: "Please enter your last name");
      return;
    }

    if (lastNameController.text.trim().length < 2) {
      SnackBarUiView.showError(
        message: "Last name must be at least 2 characters",
      );
      return;
    }

    // Email validation
    if (emailController.text.trim().isEmpty) {
      SnackBarUiView.showError(message: "Please enter your email address");
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      SnackBarUiView.showError(message: "Please enter a valid email address");
      return;
    }

    // Phone number validation
    if (phoneController.text.trim().isEmpty) {
      SnackBarUiView.showError(message: "Please enter your phone number");
      return;
    }

    if (!GetUtils.isPhoneNumber(phoneController.text.trim())) {
      SnackBarUiView.showError(message: "Please enter a valid phone number");
      return;
    }

    // Date of birth validation
    if (dateOfBirth.value == null) {
      SnackBarUiView.showError(message: "Please select your date of birth");
      return;
    }

    // Check if user is at least 13 years old (minimum age for most services)
    final now = DateTime.now();
    final age = now.difference(dateOfBirth.value!).inDays / 365;
    if (age < 13) {
      SnackBarUiView.showError(
        message: "You must be at least 13 years old to register",
      );
      return;
    }

    // Time of birth validation
    if (timeOfBirth.value == null) {
      SnackBarUiView.showError(message: "Please select your time of birth");
      return;
    }

    // Place of birth validation
    if (placeOfBirthController.text.trim().isEmpty) {
      SnackBarUiView.showError(message: "Please enter your place of birth");
      return;
    }

    if (placeOfBirthController.text.trim().length < 2) {
      SnackBarUiView.showError(
        message: "Place of birth must be at least 2 characters",
      );
      return;
    }

    // Gender validation
    if (selectedGender.value.isEmpty) {
      SnackBarUiView.showError(message: "Please select your gender");
      return;
    }

    // All validations passed, proceed with registration
    registerCustomer();
  }

  // Helper method to clear all form data
  void clearForm() {
    phoneController.clear();
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    placeOfBirthController.clear();
    selectedImage.value = null;
    dateOfBirth.value = null;
    timeOfBirth.value = null;
    selectedGender.value = 'Male';
    file = null;
  }

  // Helper method to check if form has any data
  bool get hasFormData {
    return phoneController.text.isNotEmpty ||
        firstNameController.text.isNotEmpty ||
        lastNameController.text.isNotEmpty ||
        emailController.text.isNotEmpty ||
        placeOfBirthController.text.isNotEmpty ||
        selectedImage.value != null ||
        dateOfBirth.value != null ||
        timeOfBirth.value != null;
  }
}
