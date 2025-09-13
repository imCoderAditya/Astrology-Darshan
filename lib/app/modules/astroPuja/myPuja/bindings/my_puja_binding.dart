import 'package:get/get.dart';

import '../controllers/my_puja_controller.dart';

class MyPujaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyPujaController>(
      () => MyPujaController(),
    );
  }
}
