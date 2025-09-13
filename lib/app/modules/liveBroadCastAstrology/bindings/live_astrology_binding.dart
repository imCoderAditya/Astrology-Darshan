import 'package:get/get.dart';

import '../controllers/live_astrology_controller.dart';

class LiveAstrologyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LiveAstrologyController>(
      () => LiveAstrologyController(),
    );
  }
}
