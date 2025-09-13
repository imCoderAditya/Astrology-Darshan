import 'dart:convert';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/models/address/address_model.dart';
import 'package:astrology/app/data/models/address/address_update_model.dart';
import 'package:astrology/app/data/repositories/address/address_repositories.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  var selectedAddressId = 0.obs;
  var isLoading = false.obs;
  var isAddress = false.obs;
  final AddressRepository _addressRepository = AddressRepository();
  final Rxn<AddressModel> _addressModel = Rxn<AddressModel>();

  Rxn<AddressDatum> addressDatum = Rxn<AddressDatum>();

  Rxn<AddressModel> get addressModel => _addressModel;

  @override
  void onInit() {
    super.onInit();
    isAddress.value =
        Get.arguments != null ? (Get.arguments["placeOrder"] ?? false) : false;

    debugPrint("==>$isAddress");
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    isLoading.value = true;

    try {
      final res = await _addressRepository.fetchAddresses();
      if (res != null) {
        _addressModel.value = addressModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Response : ${json.encode(_addressModel.value)}");
      } else {
        LoggerUtils.debug("AddressController: ${res.data}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void selectAddress(int addressId, {AddressDatum? address}) {
    selectedAddressId.value = addressId;
    addressDatum.value = address;
    update();
  }

  Future<void> deleteAddress(int addressId) async {
    GlobalLoader.show();
    try {
      final res = await _addressRepository.deleteAddress(addressId: addressId);

      if (res != null) {
        await loadAddresses();
        GlobalLoader.hide();
        SnackBarUiView.showSuccess(message: res.data["Message"]);
      } else {
        LoggerUtils.debug("AddressController: ${res.data}");
        GlobalLoader.hide();
        SnackBarUiView.showWarning(message: res.data["Message"]);
      }
    } catch (e) {
      LoggerUtils.debug("Error: $e");
      GlobalLoader.hide();
      SnackBarUiView.showError(message: "Something went wrong");
    }
  }

  Future<void> editAddress(
    AddressUpdateModel addressUpdateModel,
    String? addressId,
  ) async {
    GlobalLoader.show();
    try {
      final res = await _addressRepository.updateAddress(
        addressUpdateModel: addressUpdateModel,
        addressId: addressId,
      );
      if (res != null) {
        await loadAddresses();

        GlobalLoader.hide();
        SnackBarUiView.showSuccess(message: res.data["message"]);
      } else {
        LoggerUtils.debug("AddressController: ${res.data}");
        GlobalLoader.hide();
        SnackBarUiView.showWarning(message: res.data["message"]);
      }
    } catch (e) {
      LoggerUtils.debug("Error: $e");
      GlobalLoader.hide();
      SnackBarUiView.showError(message: "Something went wrong");
    }
  }

  Future<void> addAddress(AddressUpdateModel addressUpdateModel) async {
    GlobalLoader.show();
    try {
      final res = await _addressRepository.addAddress(
        addressUpdateModel: addressUpdateModel,
      );

      if (res != null) {
        await loadAddresses();
        Get.back();
        GlobalLoader.hide();
        SnackBarUiView.showSuccess(message: res.data["message"]);
      } else {
        LoggerUtils.debug("AddressController: ${res.data}");
        Get.back();
        GlobalLoader.hide();
        SnackBarUiView.showWarning(message: res.data);
      }
    } catch (e) {
      LoggerUtils.debug("Error NO: $e");
      Get.back();
      GlobalLoader.hide();
      SnackBarUiView.showError(message: "Something went wrong");
    }
  }
}
