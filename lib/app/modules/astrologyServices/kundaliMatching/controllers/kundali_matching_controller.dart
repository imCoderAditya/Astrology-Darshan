// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/kundali/kundali_matching_model.dart';

import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/components/Global_toast.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class KundaliMatchingController extends GetxController {
  Rxn<KundaliMatchingModel?> matchingDataModel = Rxn<KundaliMatchingModel?>();
  final FocusNode girlFocusNode = FocusNode();
  final FocusNode boyFocusNode = FocusNode();
  // Text Controllers for Girl
  final girlNameController = TextEditingController();
  final girlLatController = TextEditingController();
  final girlLonController = TextEditingController();
  final girlAddressController = TextEditingController();

  // Text Controllers for Boy
  final boyNameController = TextEditingController();
  final boyLatController = TextEditingController();
  final boyLonController = TextEditingController();
  final boyAddressController = TextEditingController();

  // DateTime for Girl and Boy
  final Rx<DateTime?> girlDob = Rx<DateTime?>(null);
  final Rx<DateTime?> boyDob = Rx<DateTime?>(null);

  // Loading state
  final RxBool isLoading = false.obs;

  // Ayanamsa (default 1)
  final RxInt ayanamsa = 1.obs;

  // Language (default 'en')
  final RxString language = 'en'.obs;

  @override
  void onClose() {
    girlNameController.dispose();
    girlLatController.dispose();
    girlLonController.dispose();
    boyNameController.dispose();
    boyLatController.dispose();
    boyLonController.dispose();
    super.onClose();
  }

  // Pick Girl's Date and Time
  Future<void> pickGirlDateTime(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: girlDob.value ?? DateTime(2004, 2, 12),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                isDark
                    ? ColorScheme.dark(
                      primary: AppColors.primaryColor, // accent color in dark
                      onPrimary: AppColors.white, // text on primary
                      surface: AppColors.darkSurface, // picker bg
                      onSurface: AppColors.white, // text color
                    )
                    : ColorScheme.light(
                      primary: AppColors.primaryColor, // accent in light theme
                      onPrimary: AppColors.white, // text on primary
                      surface: AppColors.white, // picker bg
                      onSurface: AppColors.black, // text color
                    ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(
          girlDob.value ?? DateTime(2004, 2, 12, 15, 19),
        ),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme:
                  isDark
                      ? ColorScheme.dark(
                        primary: AppColors.primaryColor, // accent color in dark
                        onPrimary: AppColors.white, // text on primary
                        surface: AppColors.darkSurface, // picker bg
                        onSurface: AppColors.white, // text color
                      )
                      : ColorScheme.light(
                        primary:
                            AppColors.primaryColor, // accent in light theme
                        onPrimary: AppColors.white, // text on primary
                        surface: AppColors.white, // picker bg
                        onSurface: AppColors.black, // text color
                      ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        girlDob.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }

  // Pick Boy's Date and Time
  Future<void> pickBoyDateTime(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: boyDob.value ?? DateTime(2000, 8, 20),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                isDark
                    ? ColorScheme.dark(
                      primary: AppColors.primaryColor, // accent color in dark
                      onPrimary: AppColors.white, // text on primary
                      surface: AppColors.darkSurface, // picker bg
                      onSurface: AppColors.white, // text color
                    )
                    : ColorScheme.light(
                      primary: AppColors.primaryColor, // accent in light theme
                      onPrimary: AppColors.white, // text on primary
                      surface: AppColors.white, // picker bg
                      onSurface: AppColors.black, // text color
                    ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(
          boyDob.value ?? DateTime(2000, 8, 20, 9, 30),
        ),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme:
                  isDark
                      ? ColorScheme.dark(
                        primary: AppColors.primaryColor, // accent color in dark
                        onPrimary: AppColors.white, // text on primary
                        surface: AppColors.darkSurface, // picker bg
                        onSurface: AppColors.white, // text color
                      )
                      : ColorScheme.light(
                        primary:
                            AppColors.primaryColor, // accent in light theme
                        onPrimary: AppColors.white, // text on primary
                        surface: AppColors.white, // picker bg
                        onSurface: AppColors.black, // text color
                      ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        boyDob.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }

  // Format DateTime to ISO 8601 with timezone
  String formatDateTime(DateTime dateTime) {
    // Format: 2004-02-12T15:19:21+05:30
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    return '${formatter.format(dateTime)}+05:30';
  }

  // Validate inputs
  bool validateInputs() {
    if (girlNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter girl\'s name',
        backgroundColor: AppColors.red.withOpacity(0.1),
        colorText: AppColors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (girlLatController.text.trim().isEmpty ||
        girlLonController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter girl\'s birth place coordinates',
        backgroundColor: AppColors.red.withOpacity(0.1),
        colorText: AppColors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (girlDob.value == null) {
      Get.snackbar(
        'Error',
        'Please select girl\'s date and time of birth',
        backgroundColor: AppColors.red.withOpacity(0.1),
        colorText: AppColors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (boyNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter boy\'s name',
        backgroundColor: AppColors.red.withOpacity(0.1),
        colorText: AppColors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (boyLatController.text.trim().isEmpty ||
        boyLonController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter boy\'s birth place coordinates',
        backgroundColor: AppColors.red.withOpacity(0.1),
        colorText: AppColors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (boyDob.value == null) {
      Get.snackbar(
        'Error',
        'Please select boy\'s date and time of birth',
        backgroundColor: AppColors.red.withOpacity(0.1),
        colorText: AppColors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Validate latitude and longitude
    try {
      double girlLat = double.parse(girlLatController.text);
      double girlLon = double.parse(girlLonController.text);
      double boyLat = double.parse(boyLatController.text);
      double boyLon = double.parse(boyLonController.text);

      if (girlLat < -90 || girlLat > 90) {
        GlobalToast.montrerErreur(
          message: 'Girl\'s latitude must be between -90 and 90',
        );
        return false;
      }

      if (girlLon < -180 || girlLon > 180) {
        GlobalToast.montrerErreur(
          message: 'Girl\'s longitude must be between -180 and 180',
        );
        return false;
      }

      if (boyLat < -90 || boyLat > 90) {
        GlobalToast.montrerErreur(
          message: 'Boy\'s latitude must be between -90 and 90',
        );
        return false;
      }

      if (boyLon < -180 || boyLon > 180) {
        GlobalToast.montrerErreur(
          message: 'Boy\'s longitude must be between -180 and 180',
        );
        return false;
      }
    } catch (e) {
      GlobalToast.montrerErreur(
        message: 'Please enter valid coordinates (numbers only)',
      );
      return false;
    }

    return true;
  }

  // Build request body
  Map<String, dynamic> buildRequestBody() {
    return {
      "ayanamsa": ayanamsa.value,
      "girlLat": double.parse(girlLatController.text),
      "girlLon": double.parse(girlLonController.text),
      "girlDob": formatDateTime(girlDob.value!),
      "girlName": girlNameController.text.trim(),
      "boyLat": double.parse(boyLatController.text),
      "boyLon": double.parse(boyLonController.text),
      "boyDob": formatDateTime(boyDob.value!),
      "boyName": boyNameController.text.trim(),
      "la": language.value,
    };
  }

  // Check Matching - API Call
  Future<void> checkMatching() async {
    if (!validateInputs()) return;

    try {
      // isLoading.value = true;
      GlobalLoader.show();

      final requestBody = buildRequestBody();

      // Print for debugging
      log('Request Body: $requestBody');

      // Example:
      final response = await BaseClient.post(
        api: EndPoint.detailsMatchingKundali,

        data: json.encode(requestBody),
      );

      if (response != null && response.statusCode == 200) {
        matchingDataModel.value = kundaliMatchingModelFromJson(
          json.encode(response.data),
        );
        GlobalLoader.hide();
        // Navigate to result page or show result
        Get.toNamed(
          Routes.KUNDALI_MATCHING_DETAILS,
          arguments: matchingDataModel.value,
        );
      } else {
        GlobalToast.montrerErreur(message: response.data["detail"]);
        GlobalLoader.hide();
      }

      // Get.to(() => MatchingResultView());
    } catch (e) {
      GlobalLoader.hide();
      GlobalToast.montrerErreur(message: 'Something went wrong');
    }
  }

  // Clear all fields
  void clearAll() {
    girlNameController.clear();
    girlLatController.clear();
    girlLonController.clear();
    boyNameController.clear();
    boyLatController.clear();
    boyLonController.clear();
    girlDob.value = null;
    boyDob.value = null;
  }
}
