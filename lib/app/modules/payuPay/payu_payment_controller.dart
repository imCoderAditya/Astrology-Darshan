import 'dart:convert';
import 'dart:developer';
import 'package:astrology/app/modules/astroPuja/pujaDetails/controllers/puja_details_controller.dart';
import 'package:astrology/app/modules/payuPay/hash_service.dart';
import 'package:astrology/app/modules/payuPay/payu_model.dart';
import 'package:astrology/app/modules/summary/controllers/summary_controller.dart';
import 'package:astrology/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:get/get.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';

class PayuPaymentController extends GetxController
    implements PayUCheckoutProProtocol {
  // final walletController = Get.find<WalletController>();
  // String? _amount;
  String? _type;
  String? _txId;

  late PayUCheckoutProFlutter _checkoutPro;

  Future<void> openPayUScreen({
    PayUPaymentParamModel? payUPaymentParamModel,
    String? type,
  }) async {
    try {
      _checkoutPro.openCheckoutScreen(
        payUPaymentParams: {
          PayUPaymentParamKey.key: HashService.marchantKey,
          PayUPaymentParamKey.amount: payUPaymentParamModel?.amount,
          PayUPaymentParamKey.productInfo: payUPaymentParamModel?.productInfo,
          PayUPaymentParamKey.firstName: payUPaymentParamModel?.firstName,
          PayUPaymentParamKey.email: payUPaymentParamModel?.email,
          PayUPaymentParamKey.phone: payUPaymentParamModel?.phone,
          PayUPaymentParamKey.environment: "0",
          PayUPaymentParamKey.transactionId:
              payUPaymentParamModel?.transactionId,
          PayUPaymentParamKey.userCredential:
              ":${payUPaymentParamModel?.userCredential}",
          PayUPaymentParamKey.android_surl:
              "https:///www.payumoney.com/mobileapp/payumoney/success.php",
          PayUPaymentParamKey.android_furl:
              "https:///www.payumoney.com/mobileapp/payumoney/failure.php",
          PayUPaymentParamKey.ios_surl:
              "https:///www.payumoney.com/mobileapp/payumoney/success.php",
          PayUPaymentParamKey.ios_furl:
              "https:///www.payumoney.com/mobileapp/payumoney/failure.php",
        },
        payUCheckoutProConfig: {
          PayUCheckoutProConfigKeys.merchantName: "PayU",
          PayUCheckoutProConfigKeys.primaryColor: "#57a43e",
          PayUCheckoutProConfigKeys.secondaryColor: "#28785b",
        },
      );

      // _amount = payUPaymentParamModel?.amount;
      _type = type;
      _txId = payUPaymentParamModel?.transactionId;

      update();
    } catch (e) {
      log("Exception during PayU Init: $e");
    } finally {
      update();
    }
  }

  @override
  generateHash(Map response) async {
    Map hashResponse = HashService.generateHash(response);
    log("hash print: ${json.encode(hashResponse)}");
    _checkoutPro.hashGenerated(hash: hashResponse);
  }

  @override
  onPaymentSuccess(dynamic response) {
    log("✅ Payment Success: $response");
    _fucType(status: "Completed");
  }

  @override
  onPaymentFailure(dynamic response) {
    log("❌ Payment Failed: $response");
    _fucType(status: "Failed");
  }

  @override
  onPaymentCancel(Map? response) {
    log("⚠️ Payment Cancelled: $response");
    _fucType(status: "Cancelled");
  }

  @override
  onError(Map? response) {
    log("🚨 Payment Error: $response");
  }

  @override
  void onInit() {
    _checkoutPro = PayUCheckoutProFlutter(this);
    super.onInit();
  }

  _fucType({String? status}) async {
    if (_type == "Ecomerce" && status == "Completed") {
      SummaryController().statusEccomerceUpdate(orderId: _txId);
    } else if (_type == "Wallet") {
      WalletController().statusUpdate(transactionId: _txId, status: status);
    } else if (_type == "AstroPuja") {
      if (status == "Completed") {
        await PujaDetailsController().paymentUpdate(
          bookingId: int.tryParse(_txId.toString()),
          paymentStatus: "Paid",
        );
      } else {
        await PujaDetailsController().paymentUpdate(
          bookingId: int.tryParse(_txId.toString()),
          paymentStatus: "Failed",
        );
      }
    }
  }
}
