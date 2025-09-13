import 'package:get/get.dart';

import '../controllers/puja_controller.dart';

class PujaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PujaController>(
      () => PujaController(),
    );
  }
}
