import 'dart:convert';
import 'dart:developer';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/kundali/kundali_model.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/components/snack_bar_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KundaliController extends GetxController {
  Rxn<String>? iso = Rxn<String>();
  Rxn<KundaliModel> kundaliModel = Rxn<KundaliModel>();

  //. Kundali Form
  // Text Controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final latController = TextEditingController();
  final lonController = TextEditingController();

  // Focus Node
  final focusNode = FocusNode();

  // Observable Variables

  final selectedAyanamsa = RxInt(1);

  RxBool isLoading = RxBool(false);
  RxString? language = RxString("hi");
  Future<void> fetchKundali() async {
    // GlobalLoader.show();
    isLoading.value = true;
    final lat = double.parse(latController.text);
    final lon = double.parse(lonController.text);
    try {
      final res = await BaseClient.post(
        api: EndPoint.kundali,

        data: {
          "name": nameController.text.trim(),
          "dateTime": iso?.value.toString(),
          "lat": lat,
          "lon": lon,
          "ayanamsa": 1,
          "la": language?.value,
        },
      );

      if (res != null && res.statusCode == 200) {
        kundaliModel.value = kundaliModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Kundali==>${json.encode(kundaliModel.value)}");
        Get.toNamed(Routes.KUNDALI);
      } else {
        final jsonDecode = json.decode(res.data);
        SnackBarUiView.showError(message: jsonDecode["errors"][0]["detail"]);

        LoggerUtils.error("Failed $jsonDecode");
      }
    } catch (e) {
      debugPrint("Error:$e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> pickDateTime(BuildContext context) async {
    // Initial value you want to show in picker
    DateTime initial = DateTime.parse("2001-07-15T08:30:00+05:30");

    /// Pick Date
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    /// Pick Time
    final TimeOfDay? time = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    if (time == null) return;

    /// Merge selected Date + Time
    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    /// Format to ISO without milliseconds: YYYY-MM-DDTHH:mm:ss+05:30
    iso?.value = _formatToISO(selectedDateTime);

    log("Final ISO DateTime: ${iso?.value}"); // <-- EXACT FORMAT

    update();
  }

  String _formatToISO(DateTime dt) {
    final Duration offset = dt.timeZoneOffset;

    final String sign = offset.isNegative ? "-" : "+";
    final int hours = offset.inHours.abs();
    final int minutes = offset.inMinutes.abs() % 60;

    final String formattedOffset =
        "$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";

    return "${dt.toIso8601String().split('.').first}$formattedOffset";
  }

  // Validation
  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      SnackBarUiView.showError(message: 'Please enter your name');
      return false;
    }

    if (addressController.text.trim().isEmpty) {
      SnackBarUiView.showError(message: 'Please select your birth place');
      return false;
    }

    if (latController.text.trim().isEmpty ||
        lonController.text.trim().isEmpty) {
      SnackBarUiView.showError(message: 'Please select a valid location');

      return false;
    }

    if (iso?.value == null) {
      SnackBarUiView.showError(message: 'Please select date and time of birth');
      return false;
    }

    return true;
  }

  // Reset Form
  void resetForm() {
    nameController.clear();
    addressController.clear();
    latController.clear();
    lonController.clear();
    selectedAyanamsa.value = 1;
    language?.value = 'hi';
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    latController.dispose();
    lonController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
