import 'package:get/get.dart';

import '../controllers/live_astro_controller.dart';

class LiveAstroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LiveAstroController>(
      () => LiveAstroController(),
    );
  }
}
