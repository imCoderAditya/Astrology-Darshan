import 'package:get/get.dart';

import '../controllers/numerology_controller.dart';

class NumerologyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NumerologyController>(
      () => NumerologyController(),
    );
  }
}
