import 'package:get/get.dart';

import '../controllers/kundali_matching_controller.dart';

class KundaliMatchingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KundaliMatchingController>(
      () => KundaliMatchingController(),
    );
  }
}
