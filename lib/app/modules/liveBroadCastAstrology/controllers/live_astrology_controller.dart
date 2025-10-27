import 'dart:convert';
import 'dart:developer';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/astrologer/live_astrologer_model.dart';
import 'package:get/get.dart';

class LiveAstrologyController extends GetxController {
  RxBool isLoading = false.obs;

  final Rxn<LiveAstrologerModel> _liveAstrologerModel =
      Rxn<LiveAstrologerModel>();

  Rxn<LiveAstrologerModel> get liveAstrologerModel => _liveAstrologerModel;

  Future<void> liveAstrologerAPI() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(api: EndPoint.liveAstrologer);
      if (res != null && res.statusCode == 200) {
        _liveAstrologerModel.value = liveAstrologerModelFromJson(
          json.encode(res.data),
        );
        log("Live Astrologer ${json.encode(_liveAstrologerModel.value)}");
      } else {
        LoggerUtils.error(
          "Failed Live Astrologer",
          tag: "LiveAstrologyController",
        );
      }
    } catch (e) {
      LoggerUtils.error("Error: $e", tag: "LiveAstrologyController");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    liveAstrologerAPI();
    super.onInit();
  }
}
