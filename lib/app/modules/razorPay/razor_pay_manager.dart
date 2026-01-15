import 'package:astrology/app/modules/astroPuja/pujaDetails/controllers/puja_details_controller.dart';
import 'package:astrology/app/modules/summary/controllers/summary_controller.dart';
import 'package:astrology/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:astrology/app/services/razerPlay/razorpay_service.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:get/get.dart';

enum PaymentStatus { completed, failed, cancelled }

class RazorpayPaymentManager {
  late RazorpayService _razorpayService;

  String? _type;
  String? _txId;
  Function(PaymentStatus status)? _onResult;

  RazorpayPaymentManager() {
    _init();
  }

  void _init() {
    _razorpayService = RazorpayService(
      showSuccessPopup: true,
      showErrorPopup: true,
      showWalletPopup: true,
      onPaymentSuccess: (response) async {
        SnackBarUiView.showSuccess(message: 'Payment completed successfully');
        await _handlePayment("Completed");
      },
      onPaymentError: (response) async {
        SnackBarUiView.showError(message: 'Payment failed');
        await _handlePayment("Failed");
      },
      onExternalWallet: (response) async {
        await _handlePayment("Cancelled");
      },
    );
  }

  void makePayment({
    required PaymentRequest paymentRequest,
    required String type,
    required Function(PaymentStatus status) onResult,
  }) {
    try {
      // Save callback and data
      _onResult = onResult;
      _type = type;
      _txId = paymentRequest.transactionId;

      // Validate transaction ID
      if (_txId == null || _txId!.isEmpty) {
        throw Exception('Transaction ID is required');
      }

      _razorpayService.openCheckout(
        key: 'rzp_live_Rxp88cyVW7VQAd',
        amount: paymentRequest.amount * 100,
        name: paymentRequest.name,
        description: paymentRequest.description,
        orderId: paymentRequest.transactionId,
        customerName: paymentRequest.customerName,
        customerEmail: paymentRequest.customerEmail,
        customerContact: paymentRequest.customerContact,
        externalWallets: ['paytm', 'phonepe', 'googlepay'],
      );
    } catch (e) {
      SnackBarUiView.showError(message: 'Failed to initiate payment: $e');
      _onResult?.call(PaymentStatus.failed);
      _reset();
    }
  }

  Future<void> _handlePayment(String status) async {
    // Store values before reset
    final type = _type;
    final txId = _txId;
    final callback = _onResult;

    try {
      if (type == null || txId == null) {
        throw Exception('Payment context lost');
      }

      switch (type) {
        case "Ecomerce":
          if (status == "Completed") {
            await Get.find<SummaryController>().statusEccomerceUpdate(
              orderId: txId,
            );
          }
          break;

        case "Wallet":
          // ✅ Fixed: Use Get.find instead of new instance
          await Get.find<WalletController>().statusUpdate(
            transactionId: txId,
            status: status,
          );
          break;

        case "AstroPuja":
          final bookingId = int.tryParse(txId);
          if (bookingId == null) {
            throw Exception('Invalid booking ID: $txId');
          }
          
          await Get.find<PujaDetailsController>().paymentUpdate(
            bookingId: bookingId,
            paymentStatus: status == "Completed" ? "Paid" : "Failed",
          );
          break;

        default:
          throw Exception('Unknown payment type: $type');
      }

      // Send callback
      callback?.call(
        status == "Completed"
            ? PaymentStatus.completed
            : status == "Failed"
                ? PaymentStatus.failed
                : PaymentStatus.cancelled,
      );
    } catch (e) {
      print('Error in _handlePayment: $e');
      SnackBarUiView.showError(message: 'Payment processing failed');
      callback?.call(PaymentStatus.failed);
    } finally {
      _reset();
    }
  }

  void _reset() {
    _type = null;
    _txId = null;
    _onResult = null;
  }

  void dispose() {
    _razorpayService.dispose();
    _reset();
  }
}

class PaymentRequest {
  final int amount;
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