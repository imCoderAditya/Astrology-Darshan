import 'dart:convert';
import 'dart:developer';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/profile/profile_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rxn<ProfileModel> _profileModel = Rxn<ProfileModel>();
  Rxn<ProfileModel> get profileModel => _profileModel;
  final userId = LocalStorageService.getUserId();
  Future<void> fetchProfile() async {
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.userProfile}?userId=$userId",
      );

      if (res != null && res.statusCode == 200) {
        _profileModel.value = profileModelFromJson(json.encode(res.data));
        log("Profile: ${json.encode(_profileModel.value)}");
      } else {
        LoggerUtils.error("Failed TO fetch API", tag: "ProfileController");
      }
    } catch (e) {
      LoggerUtils.error("Error:$e");
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }
}
