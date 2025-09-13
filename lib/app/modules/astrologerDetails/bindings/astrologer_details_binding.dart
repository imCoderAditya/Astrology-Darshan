import 'package:get/get.dart';

import '../controllers/astrologer_details_controller.dart';

class AstrologerDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AstrologerDetailsController>(
      () => AstrologerDetailsController(),
    );
  }
}
