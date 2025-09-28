import 'dart:convert';

import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/notification/notification_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
RxBool? isLoading = RxBool(false);

  Rxn<NotificationModel> notification = Rxn<NotificationModel>();
  Future<void> fetchNotification() async {
    isLoading?.value= true;
    try {
      final res = await BaseClient.get(api: "${EndPoint.notification}?userId=72");

      if (res != null && res.statusCode == 200) {
        notification.value = notificationModelFromJson(json.encode(res.data));
      } else {
        debugPrint("Failed : ${res?.data}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading?.value= false;
      update();
    }
  }

  @override
  void onInit() {
    fetchNotification();
    super.onInit();
  }
}
