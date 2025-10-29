import 'dart:convert';
import 'dart:developer';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/review/review_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  TextEditingController reviewTextController = TextEditingController();
  final Rxn<ReviewModel> _reviewModel = Rxn<ReviewModel>();
  Rxn<ReviewModel> get reviewModel => _reviewModel;
  int? sessionId;
  final count = 0.obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    final map = Get.arguments;
    sessionId = map["sessionId"];
    log("sessionId: $sessionId");
    fetchReview();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchReview() async {
    final userId = LocalStorageService.getCustomerId();
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.getReviews}?sessionId=$sessionId&customerId=$userId&astrologerId=0",
      );

      if (res != null && res.statusCode == 200) {
        reviewModel.value = reviewModelFromJson(json.encode(res.data));
      } else {
        LoggerUtils.error("Failed Review List", tag: "ReviewController");
      }
    } catch (e) {
      LoggerUtils.error("error $e", tag: "ReviewController");
    } finally {
      update();
    }
  }

  Future<void> addUpdateReview({
    required int sessionId,
    required int rating,
    required String reviewText,
  }) async {
    isLoading.value = true;
    try {
      final res = await BaseClient.post(
        api: EndPoint.getReAddOrUpdateReviewviews,
        data: {
          "SessionId": sessionId,
          "Rating": rating,
          "ReviewText": reviewTextController.text,
        },
      );

      if (res != null && res.statusCode == 201) {
        await fetchReview();
        Get.back();
      } else {
        Get.back();
        LoggerUtils.debug("Response Failed");
        SnackBarUiView.showError(message: res.data["message"]);
      }
    } catch (e) {
      Get.back();
      SnackBarUiView.showError(message: "Something went wrong");
      LoggerUtils.error("Error: $e", tag: "ReviewController");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> deleteReview(int reviewId) async {
    isLoading.value = true;
    try {
      final res = await BaseClient.post(
        api: EndPoint.deleteReview,
        data: {"reviewId": reviewId},
      );

      if (res != null && res.statusCode == 200) {
        await fetchReview();
        Get.back();
        SnackBarUiView.showError(message: res.data["message"]);
      } else {
        Get.back();
        LoggerUtils.debug("Response Failed");
        SnackBarUiView.showError(message: res.data["message"]);
      }
    } catch (e) {
      Get.back();
      SnackBarUiView.showError(message: "Something went wrong");
      LoggerUtils.error("Error: $e", tag: "ReviewController");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
