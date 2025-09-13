import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/userRequest/user_request_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:get/get.dart';

class UserRequestController extends GetxController {
  var isLoading = false.obs;
  Rxn<UserRequestModel> userRequestModel = Rxn<UserRequestModel>();

  Future<void> fetchUserRequest({String? status, String? sessionType}) async {
    final userId = LocalStorageService.getUserId();
    isLoading.value = true;
    try {
      final res = await BaseClient.post(
        api: EndPoint.getConsultationSessions,
        payloadObj: {
          "AstrologerId": 0,
          "CustomerId": userId,
          "SessionType": sessionType ?? "",
          "Status": status ?? "",
          "Page": 1,
          "Limit": 1000,
        },
      );

      if (res != null) {
        userRequestModel.value = userRequestModelFromJson(
          json.encode(res.data),
        );
      } else {
        LoggerUtils.error("Failed ${res.data}");
      }
    } catch (e) {
      LoggerUtils.debug("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> statusUpdate(
    String? status,
    int? sessionId, {
    bool isSideChat = false,
  }) async {
    Get.back();
    GlobalLoader.show();
    try {
      final res = await BaseClient.post(
        api: EndPoint.statusUpdate,
        data: {"SessionId": sessionId, "Status": status},
      );

      if (res != null && res.statusCode == 200) {
        await fetchUserRequest().then((value) {
          if (isSideChat == true) {
            Get.back();
          }
        });
        await Future.delayed(Duration(microseconds: 200));
        GlobalLoader.hide();
      } else {
        GlobalLoader.hide();
        LoggerUtils.error("Failed ${res.data}");
      }
    } catch (e) {
      GlobalLoader.hide();
      LoggerUtils.debug("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    fetchUserRequest(status: "Active");
    super.onInit();
  }
}
