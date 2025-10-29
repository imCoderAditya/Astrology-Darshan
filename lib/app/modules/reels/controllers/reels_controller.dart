// import 'dart:convert';

// import 'package:astrology/app/core/utils/logger_utils.dart';
// import 'package:astrology/app/data/baseclient/base_client.dart';
// import 'package:astrology/app/data/endpoint/end_pont.dart';
// import 'package:astrology/app/data/models/reels/reels_model.dart'
//     show ReelsModel, reelsModelFromJson;
// import 'package:get/get.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class ReelsController extends GetxController {
//   int _currentIndex = 0;
//   int get currentIndex => _currentIndex;
//   final Rxn<ReelsModel> _reelsModel = Rxn<ReelsModel>();
//   Rxn<ReelsModel> get reelsModel => _reelsModel;
// YoutubePlayerController? youtubeController;

//   void setYoutubeController(YoutubePlayerController controller) {
//     youtubeController = controller;
//   }

//   void pauseVideo() {
//     youtubeController?.pause();
//     update();
//   }

//   void playVideo() {
//     youtubeController?.play();
//     update();
//   }
//   void setCurrentIndex(int index) {
//     _currentIndex = index;
//     update();
//   }

//   Future<void> getReels() async {
//     try {
//       final res = await BaseClient.get(api: EndPoint.fetchReels);
//       if (res != null && res.statusCode == 200) {
//         _reelsModel.value = reelsModelFromJson(jsonEncode(res.data));
//         LoggerUtils.debug("Response: ${json.encode(_reelsModel.value)}");
//       } else {
//         LoggerUtils.error("Failed to load Reel Data");
//       }
//     } catch (e) {
//       LoggerUtils.error("Error $e", tag: 'ReelsController');
//     } finally {
//       update();
//     }
//   }

//   @override
//   void onInit() {
//     getReels();
//     super.onInit();
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/reels/reels_model.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ReelsController extends GetxController {
  VideoPlayerController? videoController;
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  final Rxn<ReelsModel> _reelsModel = Rxn<ReelsModel>();
  Rxn<ReelsModel> get reelsModel => _reelsModel;
  void setController(VideoPlayerController controller) {
    videoController = controller;
  }

  void pauseVideo() {
    videoController?.pause();
    log('Video pause');
  }

  void playVideo() {
    videoController?.play();
    log('Video Play');
  }

  Future<void> getReels() async {
    try {
      final res = await BaseClient.get(api: EndPoint.fetchReels);
      if (res != null && res.statusCode == 200) {
        _reelsModel.value = reelsModelFromJson(jsonEncode(res.data));
        LoggerUtils.debug("Response: ${json.encode(_reelsModel.value)}");
      } else {
        LoggerUtils.error("Failed to load Reel Data");
      }
    } catch (e) {
      LoggerUtils.error("Error $e", tag: 'ReelsController');
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    getReels();
    super.onInit();
  }
}
