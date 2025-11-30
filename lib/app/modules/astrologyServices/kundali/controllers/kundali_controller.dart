import 'dart:convert';
import 'dart:developer';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/kundali/kundali_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KundaliController extends GetxController {
  Rxn<String>? iso = Rxn<String>();
  Rxn<KundaliModel> kundaliModel = Rxn<KundaliModel>();

  RxBool isLoading = RxBool(false);
  RxString? language = RxString("hi");
  Future<void> fetchKundali() async {
    // GlobalLoader.show();
    isLoading.value = true;

    try {
      final res = await BaseClient.post(
        api: EndPoint.kundali,

        data: {
          "name": "Rahul Sharma",
          "dateTime": "1990-07-15T08:30:00+05:30",
          "lat": 28.6139,
          "lon": 77.2090,
          "ayanamsa": 1,
          "la": language?.value,
        },
      );

      if (res != null && res.statusCode == 200) {
        kundaliModel.value = kundaliModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Kundali==>${json.encode(kundaliModel.value)}");
      } else {
        LoggerUtils.error("Failed ${json.encode(res.data)}");
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
      context: context,
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

    fetchKundali();
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

  @override
  void onInit() {
    fetchKundali();
    super.onInit();
  }
}
