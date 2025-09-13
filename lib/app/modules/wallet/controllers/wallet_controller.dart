import 'dart:convert';
import 'package:astrology/app/core/utils/alerts_messages.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/wallet/wallet_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:get/get.dart';

class WalletController extends GetxController {
  final userId = LocalStorageService.getUserId();

  final selectTransactionType = "".obs;
  final selectStatus = "".obs;
  final isFilterSectionVisible = false.obs;
  RxString? selectedPaymentMode = RxString("");
  final isWithdrawalLoading = false.obs;

  final Rxn<WalletModel> _walletModel = Rxn<WalletModel>();
  Rxn<WalletModel> get walletModel => _walletModel;

  // For expandable cards
  final RxSet<int> expandedCards = <int>{}.obs;

  Future<void> fetchWallet() async {
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.walletAPI}?userId=$userId&transactionType=$selectTransactionType&status=$selectStatus",
      );

      if (res != null && res.statusCode == 200) {
        _walletModel.value = walletModelFromJson(json.encode(res.data));
        // Clear expanded cards when data refreshes
        expandedCards.clear();
      } else {
        LoggerUtils.error("Failed Wallet Data", tag: "WalletController");
      }
    } catch (e) {
      LoggerUtils.error("Error $e", tag: "WalletController");
    } finally {
      update();
    }
  }

  // Filter section methods
  void toggleFilterSection() {
    isFilterSectionVisible.value = !isFilterSectionVisible.value;
  }

  void setTransactionTypeFilter(String type) {
    selectTransactionType.value = type;
  }

  void setStatusFilter(String status) {
    selectStatus.value = status;
  }

  void applyFilters() {
    fetchWallet();
    // Hide filter section after applying filters
    isFilterSectionVisible.value = false;
  }

  void clearAllFilters() {
    selectTransactionType.value = "";
    selectStatus.value = "";
    fetchWallet();
  }

  bool hasActiveFilters() {
    return selectTransactionType.value.isNotEmpty ||
        selectStatus.value.isNotEmpty;
  }

  // Get filtered transaction count for display
  int getFilteredTransactionCount() {
    final wallet = _walletModel.value;
    final transactions = wallet?.transactions ?? [];

    return transactions.where((transaction) {
      bool typeMatch =
          selectTransactionType.value.isEmpty ||
          transaction.transactionType?.toLowerCase() ==
              selectTransactionType.value.toLowerCase();

      bool statusMatch =
          selectStatus.value.isEmpty ||
          transaction.status?.toLowerCase() == selectStatus.value.toLowerCase();

      return typeMatch && statusMatch;
    }).length;
  }

  // Get filter summary text
  String getFilterSummary() {
    List<String> filters = [];

    if (selectTransactionType.value.isNotEmpty) {
      filters.add(selectTransactionType.value.capitalizeFirst ?? '');
    }

    if (selectStatus.value.isNotEmpty) {
      filters.add(selectStatus.value.capitalizeFirst ?? '');
    }

    return filters.isEmpty ? 'All Transactions' : filters.join(' • ');
  }

  void addMoney({double? amount, String? paymentMethod}) async {
    GlobalLoader.show();
    try {
      final res = await BaseClient.post(
        api: EndPoint.addMoneyInWallet,
        data: {
          "UserID": userId,
          "Amount": amount,
          "Description": "Wallet Top-up",
          "TransactionType": "Credit",
          "Status":"Pending",
        },
      );
      final success = res.data["success"] ?? false;
      final message = res.data["message"] ?? false;
      if (res != null && success == true) {
        await fetchWallet();

        Get.back();
        GlobalLoader.hide();
        SnackBarUiView.showSuccess(message: message);
      } else {
        Get.back();
        GlobalLoader.hide();
        debugPrint("WalletController,  Failed: ${res.data}");
      }
    } catch (e) {
      Get.back();
      GlobalLoader.hide();
      SnackBarUiView.showWarning(message: AppAlertsMessage.somethingWentWrong);
      debugPrint("Error:$e");
    }
  }

  @override
  void onInit() {
    fetchWallet();
    super.onInit();
  }
}
