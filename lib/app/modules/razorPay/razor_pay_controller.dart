import 'package:astrology/app/modules/astroPuja/pujaDetails/controllers/puja_details_controller.dart';
import 'package:astrology/app/modules/summary/controllers/summary_controller.dart';
import 'package:astrology/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:astrology/app/services/razerPlay/razorpay_service.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RazorPayController extends GetxController {
  RazorpayService? razorpayService;
  String? _type;
  String? _txId;
  var isLoading = false.obs;
  var paymentStatus = ''.obs;



  void _initializeRazorpay({
    bool showSuccessPopup = false,
    bool showErrorPopup = false,
    bool showWalletPopup = false,
    final VoidCallback? onSuccessButtonPressed,
    final VoidCallback? onErrorButtonPressed,
    final VoidCallback? onWalletButtonPressed,
  }) async {
    razorpayService = RazorpayService(
      onSuccessButtonPressed: onSuccessButtonPressed,
      onErrorButtonPressed: onErrorButtonPressed,
      onWalletButtonPressed: onWalletButtonPressed,
      showErrorPopup: showErrorPopup,
      showSuccessPopup: showSuccessPopup,
      showWalletPopup: showWalletPopup,
      onPaymentSuccess: (response) async {
        isLoading.value = false;
        paymentStatus.value = 'success';
        debugPrint('Payment successful callback');
        // Show success snackbar
        SnackBarUiView.showSuccess(message: 'Payment completed successfully');
        // verifyPaymentOnServer(response.paymentId, response.orderId);
        await _fucType(status: "Completed");
      
      },
      onPaymentError: (response) async {
        isLoading.value = false;
        paymentStatus.value = 'failed';
        debugPrint('Payment error callback');
        // Show error snackbar
        // SnackBarUiView.showError(message: 'Payment Failed');
        await _fucType(status: "Failed");
     
      },
      onExternalWallet: (response) async {
        debugPrint('External wallet callback: ${response.walletName}');
        await _fucType(status: "Cancelled");
        
      },
    );
  }

  Future<void> _fucType({String? status}) async {
    final String paymentStatus = status ?? "Unknown";

    // 🔍 Proper logging
    debugPrint("🔔 Payment Callback");
    debugPrint("➡️ Type      : $_type");
    debugPrint("➡️ Status    : $paymentStatus");
    debugPrint("➡️ TxId      : $_txId");

    try {
      switch (_type) {
        case "Ecomerce":
          if (paymentStatus == "Completed") {
            await Get.find<SummaryController>().statusEccomerceUpdate(
              orderId: _txId,
            );
          }
          break;

        case "Wallet":
          await Get.find<WalletController>().statusUpdate(
            transactionId: _txId,
            status: paymentStatus,
          );
          break;

        case "AstroPuja":
          await Get.find<PujaDetailsController>().paymentUpdate(
            bookingId: int.tryParse(_txId.toString()),
            paymentStatus: paymentStatus == "Completed" ? "Paid" : "Failed",
          );
          break;

        default:
          debugPrint("⚠️ Unknown payment type: $_type");
      }
    } catch (e, s) {
      debugPrint("❌ Payment handling error: $e");
      debugPrintStack(stackTrace: s);
    }finally{
      _cleanUp();
    }
  }

  void makePayment(
    PaymentRequest paymentRequest, {
    String? type,
    bool showSuccessPopup = true,
    bool showErrorPopup = true,
    bool showWalletPopup = true,
    VoidCallback? onSuccessButtonPressed,
    VoidCallback? onErrorButtonPressed,
    VoidCallback? onWalletButtonPressed,
  }) {
    // Initialize with dynamic settings
    _initializeRazorpay(
      showSuccessPopup: showSuccessPopup,
      showErrorPopup: showErrorPopup,
      showWalletPopup: showWalletPopup,
      onSuccessButtonPressed: onSuccessButtonPressed,
      onErrorButtonPressed: onErrorButtonPressed,
      onWalletButtonPressed: onWalletButtonPressed,
    );

    isLoading.value = true;
    paymentStatus.value = 'processing';
    razorpayService?.openCheckout(
      key: 'rzp_live_Rxp88cyVW7VQAd',
      amount: paymentRequest.amount * 100,
      name: paymentRequest.name,
      description: paymentRequest.description,
      orderId: _txId,
      customerName: paymentRequest.customerName,
      customerEmail: paymentRequest.customerEmail,
      customerContact: paymentRequest.customerContact,
      externalWallets: ['paytm', 'phonepe', 'googlepay'],
    );
    _type = type;
    _txId = paymentRequest.transactionId;
  }

  @override
  void onClose() {
    razorpayService?.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    razorpayService?.dispose();
    super.dispose();
  }

  void _cleanUp() {
    if (Get.isRegistered<RazorPayController>()) {
      Get.delete<RazorPayController>(); // ✅ controller deleted
    }
  }

}

class PaymentRequest {
  final int amount; // in paise
  final String name;
  final String description;
  final String customerName;
  final String customerEmail;

  final String customerContact;
  final String transactionId;

  PaymentRequest({
    required this.amount,
    required this.name,
    required this.description,
    required this.customerName,
    required this.customerEmail,
    required this.customerContact,
    required this.transactionId,
  });
}
