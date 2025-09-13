import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/address/address_model.dart';
import 'package:astrology/app/modules/transaction/views/transaction_view.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:get/get.dart';

class SummaryController extends GetxController {
  final userId = LocalStorageService.getUserId();
  // Observable for selected payment method using a string
  var selectedPaymentMethod = ''.obs;

  // Method to change payment method
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> placeOrderAPI({AddressDatum? address}) async {
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

          Get.off(() => TransactionView(orderData: orderData));
          LoggerUtils.debug("Order placed successfully");
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
}
