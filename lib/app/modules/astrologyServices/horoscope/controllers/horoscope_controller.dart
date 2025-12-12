import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/kundali/horoscope_model.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:get/get.dart';

class HoroscopeController extends GetxController {
  Rxn<HoroscopeModel> horoscopeModel = Rxn<HoroscopeModel>();
  String getCurrentIsoDateTime() {
    final now = DateTime.now();
    return "${now.toIso8601String()}z";
  }

  Future<void> getHoroscope({String? sign, String? dob}) async {
    horoscopeModel.value = null;
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.prokeralaPredictionHoroscope}?datetime=${getCurrentIsoDateTime()}&sign=$sign&type=general",
      );

      if (res != null && res.statusCode == 200) {
        horoscopeModel.value = horoscopeModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Horoscope : ${json.encode(horoscopeModel.value)}");
      } else {
        LoggerUtils.error("Failed:${json.encode(res?.data)} ");
      }
    } catch (e) {
      SnackBarUiView.showInfo(message: "Something went wrong");
      LoggerUtils.error("Error:$e");
    } finally {
      update();
    }
  }
}
