import 'package:get/get.dart';

import '../controllers/puja_details_controller.dart';

class PujaDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PujaDetailsController>(
      () => PujaDetailsController(),
    );
  }
}
