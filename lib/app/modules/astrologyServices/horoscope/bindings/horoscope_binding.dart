import 'package:get/get.dart';

import '../controllers/horoscope_controller.dart';

class HoroscopeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HoroscopeController>(
      () => HoroscopeController(),
    );
  }
}
