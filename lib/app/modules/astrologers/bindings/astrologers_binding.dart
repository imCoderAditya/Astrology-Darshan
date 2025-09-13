import 'package:get/get.dart';

import '../controllers/astrologers_controller.dart';

class AstrologersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AstrologersController>(
      () => AstrologersController(),
    );
  }
}
