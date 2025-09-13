import 'package:get/get.dart';

import '../controllers/user_request_controller.dart';

class UserRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRequestController>(
      () => UserRequestController(),
    );
  }
}
