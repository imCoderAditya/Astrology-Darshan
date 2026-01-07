import 'dart:convert';
import 'dart:developer';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/address/address_model.dart';
import 'package:astrology/app/modules/profile/controllers/profile_controller.dart';
import 'package:astrology/app/modules/razorPay/razor_pay_controller.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryController extends GetxController {
  final userId = LocalStorageService.getUserId();
  // Observable for selected payment method using a string
  var selectedPaymentMethod = 'online'.obs;

  final profileController =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

  // Method to change payment method
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // final payuController = Get.put(PayuPaymentController());
  final rezorPayController = Get.put(RazorPayController());
  Future<void> placeOrderAPI({AddressDatum? address, String? amount}) async {
    if (address == null) {
      SnackBarUiView.showError(message: 'Please select a valid address.');
      return;
    }

    try {
      final res = await BaseClient.post(
        api: EndPoint.placeOrder,
        data: {
          "UserID": userId,
          "paymentMethod":
              selectedPaymentMethod.value == "cod" ? "Cod" : "Paid",
          "shippingAddress": {
            "firstName": address.address?.firstName ?? "",
            "lastName": address.address?.lastName ?? "",
            "house": address.address?.house ?? "",
            "gali": address.address?.gali ?? "",
            "nearLandmark": address.address?.nearLandmark ?? "",
            "address2": address.address?.address2 ?? "",
            "city": address.address?.city ?? "",
            "state": address.address?.state ?? "",
            "postalCode": address.address?.postalCode ?? "",
            "country": address.address?.country ?? "",
            "phoneNumber": address.address?.phoneNumber ?? "",
          },
        },
      );

      if (res?.statusCode == 200) {
        final body = res!.data as Map<String, dynamic>;
        if (body['success'] == true) {
          final orderData = {
            "success": true,
            "message": body['message'] ?? "Order Placed Successfully!",
            "orderId": body['orderId'],
            "TotalAmount": body['TotalAmount'],
            "PaymentStatus": body['PaymentStatus'],
          };
          log(json.encode(orderData));

          String txnId = "megaone${DateTime.now().millisecondsSinceEpoch}";
          // final payUParam = PayUPaymentParamModel(
          //   amount: amount.toString(),
          //   productInfo: "Astro Ecommerce",
          //   firstName:
          //       "${address.address?.firstName ?? ""} ${address.address?.lastName ?? ""}",
          //   email: profileController.profileModel.value?.data?.email ?? "",
          //   phone:
          //       profileController.profileModel.value?.data?.phoneNumber ?? "",
          //   environment: "0",
          //   transactionId: body['orderId'].toString(),
          //   userCredential:
          //       ":${profileController.profileModel.value?.data?.email ?? ""}",
          // );

          // payuController.openPayUScreen(
          //   payUPaymentParamModel: payUParam,
          //   type: "Ecomerce",
          // );

          debugPrint("Amount===>$amount");
          int amount_ = num.tryParse(amount?.trim() ?? '')?.toInt() ?? 0;
          debugPrint("Amount===>$amount_");
          final name =
              "${address.address?.firstName ?? ""} ${address.address?.lastName ?? ""}";
          rezorPayController.makePayment(
            type: "Ecomerce",
            PaymentRequest(
              amount: (amount_), // ₹100
              name: name,
              description: res.data["Description"] ?? "",
              customerName: name,
              customerEmail:
                  profileController.profileModel.value?.data?.email ?? "",
              customerContact:
                  profileController.profileModel.value?.data?.email ?? "",
              transactionId: txnId,
            ),
          );

          // Get.off(() => TransactionView(orderData: orderData));
          // LoggerUtils.debug("Order placed successfully");
        } else {
          SnackBarUiView.showError(message: body['message'] ?? '');
          LoggerUtils.debug("API error: ${body['message']}");
        }
      } else {
        SnackBarUiView.showError(
          message: 'Failed to place order. Status: ${res?.statusCode}',
        );
        LoggerUtils.debug("Failed to place order. Status: ${res?.statusCode}");
      }
    } catch (e) {
      SnackBarUiView.showError(message: 'Something went wrong ${e.toString()}');
      LoggerUtils.debug("Error placing order: $e");
    }
  }

  Future<void> statusEccomerceUpdate({String? orderId}) async {
    try {
      final res = await BaseClient.post(
        api:
            "https://astroapi.veteransoftwares.com/api/Master/update_payment_status",
        data: {"OrderID": int.tryParse(orderId ?? ""), "PaymentStatus": "Paid"},
      );
      if (res != null && res.statusCode == 200) {
        log("Sucess: ${res.data}");
      } else {
        log("Sucess: ${res.data}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
}
