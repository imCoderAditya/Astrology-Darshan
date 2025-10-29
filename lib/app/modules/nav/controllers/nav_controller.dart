import 'package:astrology/app/modules/astrologers/controllers/astrologers_controller.dart';
import 'package:astrology/app/modules/home/controllers/home_controller.dart';
import 'package:astrology/app/modules/liveBroadCastAstrology/controllers/live_astrology_controller.dart';
import 'package:astrology/app/modules/reels/controllers/reels_controller.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  var currentIndex = 0.obs;
  final liveAtrologerControler =
      Get.isRegistered<LiveAstrologyController>()
          ? Get.find<LiveAstrologyController>()
          : Get.put(LiveAstrologyController());
  final homeController =
      Get.isRegistered<HomeController>()
          ? Get.find<HomeController>()
          : Get.put(HomeController());

  final astrologersController =
      Get.isRegistered<AstrologersController>()
          ? Get.find<AstrologersController>()
          : Get.put(AstrologersController());

  void changeTab(int index) {
    currentIndex.value = index;
    if (index == 0) {
      Get.find<ReelsController>().pauseVideo();
      liveAtrologerControler.liveAstrologerAPI();
      homeController.fetchAstrologerData();
    } else if (index == 1) {
      Get.find<ReelsController>().pauseVideo();
      astrologersController.astrologerList.clear();
      astrologersController.fetchAstrologerData();
    } else if (index == 2) {
      Get.find<ReelsController>().playVideo();
    } else if (index == 3) {
      Get.find<ReelsController>().pauseVideo();
    } else if (index == 4) {
      Get.find<ReelsController>().pauseVideo();
    } else {
      Get.find<ReelsController>().pauseVideo();
    }
  }
}
