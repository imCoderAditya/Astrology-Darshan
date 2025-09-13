import 'dart:convert';
import 'dart:developer';

import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/puja/my_puja_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPujaController extends GetxController {
  var isLoading = false.obs;
  Rxn<MyPujaModel> myPujaModel = Rxn<MyPujaModel>();
  final userId = LocalStorageService.getUserId();
  Future<void> getPuja() async {
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.myBooks}?userId=$userId&status=all&page=1&limit=10000",
      );

      if (res != null && res.statusCode == 200) {
        myPujaModel.value = myPujaModelFromJson(json.encode(res.data));
        log("My Puja Response: ${json.encode(myPujaModel.value)}");
      } else {
        debugPrint("Failed Puja Get ${res?.data}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    getPuja();
    super.onInit();
  }
}
