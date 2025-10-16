import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/puja/puja_services_model.dart';
import 'package:astrology/app/modules/astroPuja/myPuja/views/my_puja_view.dart';
import 'package:astrology/app/modules/payuPay/payu_model.dart';
import 'package:astrology/app/modules/payuPay/payu_payment_controller.dart';
import 'package:astrology/app/modules/profile/controllers/profile_controller.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:get/get.dart';

class PujaDetailsController extends GetxController {

    final payuController = Get.put(PayuPaymentController());
    final profileController = Get.isRegistered<ProfileController>()?Get.find<ProfileController>():Get.put(ProfileController());
  final userId = LocalStorageService.getUserId();
  Future<void> bookPuja({
    int? pujaServiceID,
    String? pujaLocation,
    PujaService? pujaService,
    String? address,
  }) async {
    try {
      final res = await BaseClient.post(
        api: EndPoint.bookPuja,
        data: {
          "UserID": int.parse(userId.toString()),
          "PujaServiceID": pujaServiceID,
          "Status": "Pending",
          "PaymentStatus": "Pending",
          "PaymentMethod": "UPI",
          "PujaLocation": pujaLocation ?? "",
          "Address": address ?? "",
        },
      );

      if (res != null && res.statusCode == 200 && res.data["status"] == true) {
        GlobalLoader.hide();
        LoggerUtils.debug("Response Status: ${res.data}");
        final data = res.data["data"];
        // after payment getway open then call api 

        // await paymentUpdate(
        //   bookingId: data["BookingID"],
        //   paymentStatus: "Paid",
        // );
        // Get.off(MyPujaView());

         final payUParam = PayUPaymentParamModel(
            amount: pujaService?.price.toString()??"",
            productInfo: "Astro Puja",
        firstName:
                "${profileController.profileModel.value?.data?.firstName?? ""} ${profileController.profileModel.value?.data?.lastName ?? ""}",
            email: profileController.profileModel.value?.data?.email??"",
            phone:
               profileController.profileModel.value?.data?.phoneNumber??"",
            environment: "0",
            transactionId: data['BookingID'].toString(),
            userCredential:
                ":${profileController.profileModel.value?.data?.userId ?? ""}",
          );

          payuController.openPayUScreen(
            payUPaymentParamModel: payUParam,
            type: "AstroPuja",
          );
      } else {
        GlobalLoader.hide();
        LoggerUtils.error("Failed Book Puja ${res.data}");
      }
    } catch (e) {
      GlobalLoader.hide();
      LoggerUtils.error("error: $e");
    }
  }

  Future<void> paymentUpdate({int? bookingId, String? paymentStatus}) async {
    try {
      //Paid , Failed
      final res = await BaseClient.post(
        api: EndPoint.updatePayment,
        data: {"BookingID": bookingId, "PaymentStatus": paymentStatus},
      );

      if (res != null && res.statusCode == 200 && res.data["status"] == true) {
        GlobalLoader.hide();
        LoggerUtils.debug("Response Status: ${res.data}");
        Get.off(MyPujaView());
      } else {
        GlobalLoader.hide();
        LoggerUtils.error("Failed Book Puja ${res.data}");
      }
    } catch (e) {
      GlobalLoader.hide();
      LoggerUtils.error("error: $e");
    }
  }
}
