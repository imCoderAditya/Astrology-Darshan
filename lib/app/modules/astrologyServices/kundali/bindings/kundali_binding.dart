import 'package:get/get.dart';

import '../controllers/kundali_controller.dart';

class KundaliBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KundaliController>(
      () => KundaliController(),
    );
  }
}
