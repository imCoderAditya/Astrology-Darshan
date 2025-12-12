import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/kundali/numerology_model.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:get/get.dart';

class NumerologyController extends GetxController {
  Rxn<NumerologyModel> numerologyModel = Rxn<NumerologyModel>();
  var isLoading = false.obs;
  Future<void> getnumerology({String? dob}) async {
    isLoading.value = true;
    numerologyModel.value = null;
    final encoded = Uri.encodeComponent(dob.toString());
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.prokeralaNumerology}?datetime=$encoded",
      );

      if (res != null && res.statusCode == 200) {
        numerologyModel.value = numerologyModelFromJson(json.encode(res.data));
        LoggerUtils.debug(
          "NumerologyModel : ${json.encode(numerologyModel.value)}",
        );
      } else {
        LoggerUtils.error("Failed:${json.encode(res?.data)} ");
      }
    } catch (e) {
      SnackBarUiView.showInfo(message: "Something went wrong");
      LoggerUtils.error("Error:$e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
