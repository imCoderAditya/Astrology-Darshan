import 'dart:convert';
import 'dart:developer';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/astrologer/astro_category_model.dart';
import 'package:astrology/app/data/models/astrologer/astrologer_model.dart';
import 'package:astrology/app/data/models/userRequest/user_request_model.dart';
import 'package:astrology/app/modules/chat/controllers/chat_controller.dart';
import 'package:astrology/app/modules/chat/views/chat_view.dart';
import 'package:astrology/app/modules/profile/controllers/profile_controller.dart';
import 'package:astrology/app/modules/voiceCall/views/voice_call_view.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AstrologersController extends GetxController {
  var isLoading = false.obs;
  int selectCategoryId = 1;
  var selectSpecalization = "All";
  var selectedLanguage = "English";
  var selectedRating = "Rating";

  ScrollController scrollController = ScrollController();
  final Rxn<AstrologerModel> _astrologerModel = Rxn<AstrologerModel>();
  final RxList<Astrologer> _astrologerList = RxList<Astrologer>();

  final Rxn<AstroCategoryModel> _astroCategoryModel = Rxn<AstroCategoryModel>();
  Rxn<AstroCategoryModel> get astroCategoryModel => _astroCategoryModel;

  RxList<Astrologer> get astrologerList => _astrologerList;
  var currentPage = 1.obs;
  var limit = 10.obs;

  final chatController = Get.put(ChatController());

  void selectCategory(Datum datum) async {
    _astrologerList.clear();
    selectCategoryId = datum.categoryId ?? -1;
    selectSpecalization = datum.categoryName ?? "All";
    fetchAstrologerData();
    update();
  }

  Future<void> fetchAstrologerData() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.astrologers}?page=${currentPage.value}&limit=${limit.value}&isOnline=true&specialization=${selectSpecalization.replaceAll("All", "")}&language=$selectedLanguage&sortBy=$selectedRating",
      );
      if (res != null && res.statusCode == 200) {
        // Process the response here
        _astrologerModel.value = astrologerModelFromJson(json.encode(res.data));
        _astrologerList.addAll(_astrologerModel.value?.data?.astrologers ?? []);
      } else {
        LoggerUtils.error("Failed Astrologer List API: $res");
      }
    } catch (e) {
      LoggerUtils.error("Error fetching astrologer data: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  final profileController = Get.put(ProfileController());
  Future<void> astrologerBook({
    int? astrologerId,
    String? type,
    int? endTime,
  }) async {
    // Show loader immediately
    GlobalLoader.show();

    final userId = LocalStorageService.getUserId();
 log("select_id $selectCategoryId");
    try {
      final res = await BaseClient.post(
        api: EndPoint.bookConsultBook,
        data: {
          "customerId": int.parse(userId.toString()),
          "astrologerId": astrologerId ,
          "EstimatedDuration": 5,
          "categoryId": selectCategoryId.abs(),
          "sessionType": type,
          "scheduledAt": DateTime.now().toIso8601String(),
        },
      );

      if (res != null && res.statusCode == 200) {
        log(json.encode(res.data));
        final data = res.data['data'];
        final int sessionId = data['sessionId'];
        debugPrint("Session Id => $sessionId");

        // Hide loader **before navigation**
        GlobalLoader.hide();

        // Navigate to VoiceCalls
        await chatController.setData(sessionId: sessionId);
        if (type == "Call") {
          Get.to(() => VoiceCallView(channelName: sessionId.toString()));
        } else {
          Get.to(
            () => ChatView(
              endTime: endTime,
              sessionData: Session(
                astrologerName: data["astrologerName"] ?? "",
              ),
            ),
          );
        }
      } else {
        // LoggerUtils.error(res.data["message"] ?? "");
        GlobalLoader.hide();
      }
    } catch (e) {
      LoggerUtils.error("Error fetching astrologer data: $e");
      GlobalLoader.hide();
    } finally {
      update();
      profileController.fetchProfile();
    }
  }

  Future<void> fetchAstrologerCategory() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(
        api: EndPoint.getConsultationCategoriess,
      );
      if (res != null && res.statusCode == 200) {
        // Process the response here
        _astroCategoryModel.value = astroCategoryModelFromJson(
          json.encode(res.data),
        );
      } else {
        LoggerUtils.error("Failed Astrologer List API: $res");
      }
    } catch (e) {
      LoggerUtils.error("Error fetching astrologer data: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    fetchAstrologerCategory();
    fetchAstrologerData();
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  void _onScroll() {
    debugPrint("_currentPage $currentPage");
    debugPrint(currentPage.toString());

    final totalPages =
        _astrologerModel.value?.data?.pagination?.totalPages; // get total pages
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 && // added buffer
        !isLoading.value &&
        currentPage < (totalPages ?? 0)) {
      loadMoreTransaction();
    }
  }

  void loadMoreTransaction() {
    final lastPage = _astrologerModel.value?.data?.pagination?.totalPages ?? 0;
    final totalRecords =
        _astrologerModel.value?.data?.pagination?.totalItems ?? 0;
    if (currentPage < lastPage &&
        !isLoading.value &&
        astrologerList.length < totalRecords) {
      currentPage.value++;
      fetchAstrologerData();
      update();
    }
  }
}
