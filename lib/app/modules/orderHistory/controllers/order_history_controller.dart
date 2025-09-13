import 'dart:convert';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/ecommerce/user_order_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryController extends GetxController {
  // User ID and API variables
  final userId = LocalStorageService.getUserId();
  var selectedStatus = "All".obs;
  var currentPage = 1.obs;
  int limit = 2;

  // Observable variables
  final Rxn<UserOrderModel> _userOrderModel = Rxn<UserOrderModel>();
  Rxn<UserOrderModel> get userOrderModels => _userOrderModel;
  final RxBool isLoading = false.obs;

  // Getters
  // List<Order> get allOrders => _userOrderModel.value?.data?.orders ?? [];
  RxList<Order> orderList = RxList<Order>([]);
  ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    fetchOrders(status: "All");
    scrollController.addListener(_onScroll);
  }

void _onScroll() {
  final totalPages = userOrderModels.value?.data?.totalPages ?? 0;

  if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 && // buffer
      !isLoading.value &&
      currentPage.value < totalPages) {
    loadMoreTransaction();
  }
}

void loadMoreTransaction() {
  final lastPage = userOrderModels.value?.data?.totalPages ?? 0;
  final totalRecords = userOrderModels.value?.data?.totalOrders ?? 0;

  if (!isLoading.value &&
      currentPage.value < lastPage &&
      orderList.length < totalRecords) {
    currentPage.value++;
    fetchOrders(status: selectedStatus.value);
    update();
  }
}

  // Filter orders by status
  void filterByStatus(String status) {
    orderList.clear();
    fetchOrders(status: status);
    selectedStatus.value = status;
    update(); // Trigger UI update
  }

  // Fetch all orders from API
  Future<void> fetchOrders({String? status, bool isRefresh = false}) async {

    try {
      isLoading.value = true;

      final res = await BaseClient.get(
        api:
            "${EndPoint.getUserOrders}?userId=$userId&page=${currentPage.value}&limit=$limit&status=$status",
      );

      if (res != null && res.statusCode == 200) {
        _userOrderModel.value = userOrderModelFromJson(json.encode(res.data));
        orderList.addAll(_userOrderModel.value?.data?.orders ?? []);

        LoggerUtils.debug(
          "Order history for status $status: ${jsonEncode(_userOrderModel.value)}",
        );
      } else {
        LoggerUtils.error(
          "Failed to fetch order history for status $status: ${res?.statusCode}",
        );
      }
    } catch (e) {
      LoggerUtils.error("Failed to fetch order history for status $status: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
