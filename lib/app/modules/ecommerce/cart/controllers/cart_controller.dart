// ignore_for_file: unnecessary_overrides

import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/ecommerce/cart_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var isLoading = false.obs;
  final userId = LocalStorageService.getUserId();

  final Rxn<CartEcModel> _cartEcModel = Rxn<CartEcModel>();
  Rxn<CartEcModel> get cartEcModel => _cartEcModel;

  @override
  void onInit() {
    fetchCartItems();
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

  Future<void> fetchCartItems() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(api: "${EndPoint.cart}?userId=$userId");
      if (res != null && res.statusCode == 200) {
        _cartEcModel.value = cartEcModelFromJson(json.encode(res.data));
      } else {
        LoggerUtils.error("Error fetching cart items", tag: "CartController");
      }
    } catch (e) {
      LoggerUtils.error("Error $e", tag: "CartController");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> updateCartAPI({int? cartId, int? quantity}) async {
    GlobalLoader.show();
    try {
      final res = await BaseClient.post(
        api: EndPoint.updateCartAPI,
        data: {"CartID": cartId ?? 0, "ChangeInQuantity": quantity ?? 0},
      );
      if (res != null && res.statusCode == 200) {
        await fetchCartItems();
      } else {
        LoggerUtils.error("Error fetching cart items", tag: "CartController");
      }
    } catch (e) {
      LoggerUtils.error("Error $e", tag: "CartController");
    } finally {
      GlobalLoader.hide();
      update();
    }
  }

  Future<void> deleteProductCartAPI({int? cartId}) async {
    GlobalLoader.show();
    try {
      final res = await BaseClient.post(
        api: EndPoint.deleteCartProduct,
        data: {"CartId": cartId},
      );
      if (res != null && res.statusCode == 200) {
        SnackBarUiView.showSuccess(message: res.data["message"]);
        await fetchCartItems();
      } else {
        LoggerUtils.error("Error fetching cart items", tag: "CartController");
      }
    } catch (e) {
      LoggerUtils.error("Error $e", tag: "CartController");
    } finally {
      GlobalLoader.hide();
      update();
    }
  }
}
