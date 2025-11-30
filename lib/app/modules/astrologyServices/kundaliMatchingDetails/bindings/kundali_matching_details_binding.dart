import 'package:get/get.dart';

import '../controllers/kundali_matching_details_controller.dart';

class KundaliMatchingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KundaliMatchingDetailsController>(
      () => KundaliMatchingDetailsController(),
    );
  }
}
