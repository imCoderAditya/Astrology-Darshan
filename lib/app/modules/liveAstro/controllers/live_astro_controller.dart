// // viewer_controller.dart - For Users (Preview Only)
// // ignore_for_file: deprecated_member_use, constant_identifier_names

// import 'dart:async';

// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:agora_token_generator/agora_token_generator.dart';
// import 'package:astrology/app/core/utils/logger_utils.dart';
// import 'package:astrology/app/routes/app_pages.dart';
// import 'package:astrology/components/global_loader.dart';
// import 'package:astrology/components/snack_bar_view.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:permission_handler/permission_handler.dart';

// const String APPID = "25747e4b1b9c43d8a8b7cde83abddf45";
// const String APPCERTIFICATE = "3bac8b59eec041909daf6ef145021e45";

// class LiveAstroController extends GetxController {
//   late RtcEngine engine;
//   String? channelName;
//   String? userName;
//   String? token;
//   int? uId;

//   // Basic states
//   final isEngineReady = false.obs;
//   final isWatching = false.obs;
//   final connectionState = 'disconnected'.obs;
//   final isHostOnline = false.obs;

//   // Viewer-specific features
//   final watchDuration = '00:00'.obs;
//   final networkQuality = 'excellent'.obs;
//   final audioVolume = 100.obs;
//   final isAudioMuted = false.obs;

//   // Host video controller
//   final hostVideoController = Rxn<VideoViewController>();
//   final hostUid = 0.obs;

//   // Timer
//   Timer? _watchTimer;
//   int _watchStartTime = 0;

//   Future<bool> initData({
//     String? etcToken,
//     String? channelName,
//     int? uId,
//     String? userName,
//   }) async {
//     token = etcToken;
//     this.uId = uId;
//     this.channelName = channelName;
//     this.userName = userName;
//     LoggerUtils.debug('🎯Viewer UId: $uId');
//     LoggerUtils.debug('🎯Viewer Channel: $channelName');
//     LoggerUtils.debug('🎯Viewer Token: $etcToken');
//     await initAgora();
//     update();
//     return true;
//   }

//   Future<void> joinLive({String? channelName, String? userName}) async {
//     GlobalLoader.show();
//     const String appId = APPID;
//     const String appCertificate = APPCERTIFICATE;
//     const int tokenExpireSeconds = 3600; // 1 hour
//     final uniqueUid = DateTime.now().millisecondsSinceEpoch % 1000000000;

//     // Generate RTC token for audience
//     String etcToken = RtcTokenBuilder.buildTokenWithUid(
//       appId: appId,
//       appCertificate: appCertificate,
//       channelName: channelName ?? "",
//       uid: uniqueUid,
//       tokenExpireSeconds: tokenExpireSeconds,
//     );
//     token = etcToken;
//     uId = uniqueUid;
//     this.channelName = channelName;
//     this.userName = userName;
//     update();
//     LoggerUtils.debug('🎯Viewer Token Generated: $token');
//     LoggerUtils.debug('🎯Viewer UId: $uId');
//     LoggerUtils.debug('🎯Viewer Channel: $channelName');

//     await initAgora();
//     GlobalLoader.hide();
//     Get.toNamed(Routes.LIVE_ASTRO);
//   }

//   @override
//   void onClose() {
//     _watchTimer?.cancel();
//     leaveLive();
//     super.onClose();
//   }

//   Future<void> initAgora() async {
//     try {
//       // Only request audio permission for viewers (no camera needed)
//       await _requestPermissions();

//       engine = createAgoraRtcEngine();
//       await engine.initialize(RtcEngineContext(appId: APPID));

//       engine.registerEventHandler(
//         RtcEngineEventHandler(
//           onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//             debugPrint('Viewer joined channel: ${connection.channelId}');
//             isWatching.value = true;
//             connectionState.value = 'watching';
//             _startWatchTimer();
//           },
//           onUserJoined: (RtcConnection connection, int uid, int elapsed) {
//             debugPrint('Host joined: $uid');
//             hostUid.value = uid;
//             isHostOnline.value = true;

//             // Create remote video controller for host
//             hostVideoController.value = VideoViewController.remote(
//               rtcEngine: engine,
//               canvas: VideoCanvas(uid: uid),
//               connection: connection,
//             );
//           },
//           onUserOffline: (
//             RtcConnection connection,
//             int uid,
//             UserOfflineReasonType reason,
//           ) {
//             debugPrint('Host left: $uid');
//             if (hostUid.value == uid) {
//               hostVideoController.value = null;
//               hostUid.value = 0;
//               isHostOnline.value = false;
//             }
//           },
//           onConnectionStateChanged: (
//             RtcConnection connection,
//             ConnectionStateType state,
//             ConnectionChangedReasonType reason,
//           ) {
//             debugPrint('Viewer connection state: $state');
//             switch (state) {
//               case ConnectionStateType.connectionStateConnected:
//                 connectionState.value = 'watching';
//                 break;
//               case ConnectionStateType.connectionStateConnecting:
//                 connectionState.value = 'connecting';
//                 break;
//               case ConnectionStateType.connectionStateReconnecting:
//                 connectionState.value = 'reconnecting';
//                 break;
//               case ConnectionStateType.connectionStateFailed:
//                 connectionState.value = 'failed';
//                 break;
//               default:
//                 connectionState.value = 'disconnected';
//             }
//           },
//           onNetworkQuality: (
//             RtcConnection connection,
//             int remoteUid,
//             QualityType txQuality,
//             QualityType rxQuality,
//           ) {
//             // For viewers, focus on receive quality
//             switch (rxQuality) {
//               case QualityType.qualityExcellent:
//               case QualityType.qualityGood:
//                 networkQuality.value = 'excellent';
//                 break;
//               case QualityType.qualityPoor:
//               case QualityType.qualityBad:
//                 networkQuality.value = 'poor';
//                 break;
//               default:
//                 networkQuality.value = 'fair';
//             }
//           },
//           onError: (ErrorCodeType err, String msg) {
//             debugPrint('Viewer Agora Error: $err - $msg');
//             connectionState.value = 'failed';
//           },
//           onRemoteVideoStateChanged: (
//             RtcConnection connection,
//             int remoteUid,
//             RemoteVideoState state,
//             RemoteVideoStateReason reason,
//             int elapsed,
//           ) {
//             debugPrint(
//               'Remote video state changed: $state for uid: $remoteUid',
//             );
//           },
//           onRemoteAudioStateChanged: (
//             RtcConnection connection,
//             int remoteUid,
//             RemoteAudioState state,
//             RemoteAudioStateReason reason,
//             int elapsed,
//           ) {
//             debugPrint(
//               'Remote audio state changed: $state for uid: $remoteUid',
//             );
//           },
//         ),
//       );

//       // Configure for audience (viewer)
//       await _configureForViewing();

//       // Join channel as audience
//       await engine.joinChannel(
//         token: token ?? "",
//         channelId: channelName ?? "",
//         uid: uId ?? 0,
//         options: const ChannelMediaOptions(
//           channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//           clientRoleType: ClientRoleType.clientRoleAudience,
//           publishCameraTrack: false, // Don't publish camera
//           publishMicrophoneTrack: false, // Don't publish microphone
//           autoSubscribeAudio: true,
//           autoSubscribeVideo: true,

//         ),
//       );

//       isEngineReady.value = true;
//     } catch (e) {
//       debugPrint('Error initializing Viewer Agora: $e');
//       Get.snackbar('Error', 'Failed to join live stream: $e');
//     }
//   }

//   Future<void> _configureForViewing() async {
//     // Disable video and audio publishing (viewer mode)
//     await engine.disableVideo();
//     await engine.disableAudio();

//     // Set client role as audience
//     await engine.setClientRole(role: ClientRoleType.clientRoleAudience);

//     // Set channel profile for live broadcasting
//     await engine.setChannelProfile(
//       ChannelProfileType.channelProfileLiveBroadcasting,
//     );

//     // Enable audio playback for listening
//     await engine.enableAudioVolumeIndication(
//       interval: 200,
//       smooth: 3,
//       reportVad: false,
//     );
//   }

//   Future<void> _requestPermissions() async {
//     // Only request audio permission for viewers
//     await [Permission.audio].request();
//   }

//   void _startWatchTimer() {
//     _watchStartTime = DateTime.now().millisecondsSinceEpoch;
//     _watchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       final duration = DateTime.now().millisecondsSinceEpoch - _watchStartTime;
//       final hours = (duration ~/ 3600000).toString().padLeft(2, '0');
//       final minutes = ((duration % 3600000) ~/ 60000).toString().padLeft(
//         2,
//         '0',
//       );
//       final seconds = ((duration % 60000) ~/ 1000).toString().padLeft(2, '0');
//       watchDuration.value = '$hours:$minutes:$seconds';
//     });
//   }

//   // Audio controls for viewer
//   Future<void> toggleAudio() async {
//     isAudioMuted.value = !isAudioMuted.value;
//     await engine.muteAllRemoteAudioStreams(isAudioMuted.value);
//     SnackBarUiView.showSuccess(
//       message: isAudioMuted.value ? 'Audio muted' : 'Audio unmuted',
//     );
//   }

//   Future<void> setAudioVolume(double volume) async {
//     audioVolume.value = volume.round();
//     await engine.adjustPlaybackSignalVolume(audioVolume.value);
//   }

//   // Leave live stream
//   Future<void> leaveLive() async {
//     try {
//       _watchTimer?.cancel();
//       await engine.leaveChannel();
//       await engine.release();

//       // Reset states
//       isWatching.value = false;
//       isEngineReady.value = false;
//       isHostOnline.value = false;
//       hostVideoController.value = null;
//       hostUid.value = 0;
//       connectionState.value = 'disconnected';
//       watchDuration.value = '00:00';
//     } catch (e) {
//       debugPrint('Error leaving live: $e');
//     }
//   }

//   // Share live stream
//   void shareLive() {
//     // Implement share functionality
//     SnackBarUiView.showSuccess(message: 'Share link copied to clipboard');
//   }

//   // Report live stream
//   void reportLive() {
//     // Implement report functionality
//     Get.snackbar(
//       'Report',
//       'Thank you for your report. We will review it shortly.',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.orange,
//       colorText: Colors.white,
//     );
//   }

//   // Network diagnostics for viewer
//   Future<void> runNetworkTest() async {
//     try {
//       await engine.startLastmileProbeTest(
//         const LastmileProbeConfig(
//           probeUplink: false, // Viewer doesn't need uplink test
//           probeDownlink: true,
//           expectedUplinkBitrate: 0,
//           expectedDownlinkBitrate: 500000, // Expected download bitrate
//         ),
//       );

//       SnackBarUiView.showSuccess(message: 'Running network test...');
//     } catch (e) {
//       debugPrint('Network test error: $e');
//     }
//   }

//   @override
//   void onInit() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await joinLive(channelName: "astroLive", userName: "ViewerUser");
//     });
//     super.onInit();
//   }
// }
// viewer_controller.dart - Fixed Version
// ignore_for_file: deprecated_member_use, constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/gift/gift_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/app/services/webshoket/live_webshoket_services.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

const String APPID = "25747e4b1b9c43d8a8b7cde83abddf45";
const String APPCERTIFICATE = "3bac8b59eec041909daf6ef145021e45";

class LiveAstroController extends GetxController {
  TextEditingController messageController = TextEditingController();
  late RtcEngine engine;
  String? channelName;
  String? userName;
  String? token;
  int? uId;

  // Basic states
  final isEngineReady = false.obs;
  final isWatching = false.obs;
  final connectionState = 'disconnected'.obs;
  final isHostOnline = false.obs;

  // Viewer-specific features
  final watchDuration = '00:00'.obs;
  final networkQuality = 'excellent'.obs;
  final audioVolume = 100.obs;
  final isAudioMuted = false.obs;

  // Host video controller
  final hostVideoController = Rxn<VideoViewController>();
  final hostUid = 0.obs;

  // Timer
  Timer? _watchTimer;
  int _watchStartTime = 0;

  Future<bool> initData({
    String? etcToken,
    String? channelName,
    int? uId,
    String? userName,
  }) async {
    token = etcToken;
    this.uId = uId;
    this.channelName = channelName;
    this.userName = userName;
    LoggerUtils.debug('🎯Viewer UId: $uId');
    LoggerUtils.debug('🎯Viewer Channel: $channelName');
    LoggerUtils.debug('🎯Viewer Token: $etcToken');
    await initAgora();
    update();
    return true;
  }

  Future<void> joinLive({String? channelName, String? userName}) async {
    GlobalLoader.show();
    const String appId = APPID;
    const String appCertificate = APPCERTIFICATE;
    const int tokenExpireSeconds = 3600; // 1 hour
    final uniqueUid = DateTime.now().millisecondsSinceEpoch % 1000000000;

    // Generate RTC token for audience
    String etcToken = RtcTokenBuilder.buildTokenWithUid(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName ?? "",
      uid: uniqueUid,
      tokenExpireSeconds: tokenExpireSeconds,
    );
    token = etcToken;
    uId = uniqueUid;
    this.channelName = channelName;
    this.userName = userName;
    update();
    LoggerUtils.debug('🎯Viewer Token Generated: $token');
    LoggerUtils.debug('🎯Viewer UId: $uId');
    LoggerUtils.debug('🎯Viewer Channel: $channelName');

    await initAgora();
    GlobalLoader.hide();
    // Get.toNamed(Routes.LIVE_ASTRO);
  }

  @override
  void onClose() {
    _watchTimer?.cancel();
    leaveLive();
    super.onClose();
  }

  Future<void> initAgora() async {
    try {
      // Request permissions first
      await _requestPermissions();

      engine = createAgoraRtcEngine();
      await engine.initialize(RtcEngineContext(appId: APPID));

      // Configure for viewing FIRST, before setting event handlers
      await _configureForViewing();

      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint('✅ Viewer joined channel: ${connection.channelId}');
            isWatching.value = true;
            connectionState.value = 'watching';
            _startWatchTimer();
          },
          onUserJoined: (RtcConnection connection, int uid, int elapsed) {
            debugPrint('✅ Host joined: $uid');
            hostUid.value = uid;
            isHostOnline.value = true;

            // Create remote video controller for host with proper configuration
            _setupRemoteVideoView(uid, connection);
          },
          onUserOffline: (
            RtcConnection connection,
            int uid,
            UserOfflineReasonType reason,
          ) {
            debugPrint('❌ Host left: $uid (Reason: $reason)');
            if (hostUid.value == uid) {
              hostVideoController.value?.dispose();
              hostVideoController.value = null;
              hostUid.value = 0;
              isHostOnline.value = false;
            }
          },
          onConnectionStateChanged: (
            RtcConnection connection,
            ConnectionStateType state,
            ConnectionChangedReasonType reason,
          ) {
            debugPrint('🔄 Connection state: $state, reason: $reason');
            switch (state) {
              case ConnectionStateType.connectionStateConnected:
                connectionState.value = 'watching';
                break;
              case ConnectionStateType.connectionStateConnecting:
                connectionState.value = 'connecting';
                break;
              case ConnectionStateType.connectionStateReconnecting:
                connectionState.value = 'reconnecting';
                break;
              case ConnectionStateType.connectionStateFailed:
                connectionState.value = 'failed';
                break;
              default:
                connectionState.value = 'disconnected';
            }
          },
          onNetworkQuality: (
            RtcConnection connection,
            int remoteUid,
            QualityType txQuality,
            QualityType rxQuality,
          ) {
            switch (rxQuality) {
              case QualityType.qualityExcellent:
              case QualityType.qualityGood:
                networkQuality.value = 'excellent';
                break;
              case QualityType.qualityPoor:
              case QualityType.qualityBad:
                networkQuality.value = 'poor';
                break;
              default:
                networkQuality.value = 'fair';
            }
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint('❌ Agora Error: $err - $msg');
            connectionState.value = 'failed';
          },
          onRemoteVideoStateChanged: (
            RtcConnection connection,
            int remoteUid,
            RemoteVideoState state,
            RemoteVideoStateReason reason,
            int elapsed,
          ) {
            debugPrint(
              '📹 Remote video state changed: $state for uid: $remoteUid, reason: $reason',
            );

            // Handle video state changes
            if (remoteUid == hostUid.value) {
              switch (state) {
                case RemoteVideoState.remoteVideoStateStarting:
                case RemoteVideoState.remoteVideoStateDecoding:
                  debugPrint('✅ Host video is now available');
                  // Ensure we have a video controller for this user
                  if (hostVideoController.value == null) {
                    _setupRemoteVideoView(remoteUid, connection);
                  }
                  break;
                case RemoteVideoState.remoteVideoStateStopped:
                  debugPrint('⏹️ Host stopped video');
                  break;
                case RemoteVideoState.remoteVideoStateFrozen:
                  debugPrint('🧊 Host video frozen');
                  break;
                case RemoteVideoState.remoteVideoStateFailed:
                  debugPrint('❌ Host video failed');
                  break;
              }
            }
          },
          onRemoteAudioStateChanged: (
            RtcConnection connection,
            int remoteUid,
            RemoteAudioState state,
            RemoteAudioStateReason reason,
            int elapsed,
          ) {
            debugPrint(
              '🔊 Remote audio state changed: $state for uid: $remoteUid, reason: $reason',
            );
          },
          onFirstRemoteVideoFrame: (
            RtcConnection connection,
            int remoteUid,
            int width,
            int height,
            int elapsed,
          ) {
            debugPrint(
              '🎬 First remote video frame received from uid: $remoteUid, size: ${width}x$height',
            );
          },
        ),
      );

      // Join channel as audience
      await engine.joinChannel(
        token: token ?? "",
        channelId: channelName ?? "",
        uid: uId ?? 0,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleAudience,
          publishCameraTrack: true,

          publishMicrophoneTrack: true,
          publishScreenTrack: true,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
        ),
      );

      isEngineReady.value = true;
      debugPrint('✅ Agora engine initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing Viewer Agora: $e');
      Get.snackbar('Error', 'Failed to join live stream: $e');
    }
  }

  void _setupRemoteVideoView(int uid, RtcConnection connection) {
    try {
      debugPrint('🎥 Setting up remote video view for uid: $uid');

      // Dispose existing controller if any
      hostVideoController.value?.dispose();

      // Create new video controller
      hostVideoController.value = VideoViewController.remote(
        rtcEngine: engine,
        canvas: VideoCanvas(
          uid: uid,
          renderMode: RenderModeType.renderModeHidden, // Crop to fit
          mirrorMode: VideoMirrorModeType.videoMirrorModeDisabled,
        ),
        connection: connection,
      );

      debugPrint('✅ Remote video controller created for uid: $uid');
    } catch (e) {
      debugPrint('❌ Error setting up remote video view: $e');
    }
  }

  Future<void> _configureForViewing() async {
    try {
      // Set channel profile for live broadcasting FIRST
      await engine.setChannelProfile(
        ChannelProfileType.channelProfileLiveBroadcasting,
      );

      // Set client role as audience
      await engine.setClientRole(role: ClientRoleType.clientRoleAudience);

      // Enable video receiving (important for viewers!)
      await engine.enableVideo();
      await engine.enableAudio();
      // Configure video for optimal viewing
      await engine.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 640, height: 480),
          frameRate: 30,
          bitrate: 800,
          orientationMode: OrientationMode.orientationModeAdaptive,
        ),
      );

      // Configure audio for receiving
      await engine.enableAudioVolumeIndication(
        interval: 200,
        smooth: 3,
        reportVad: true,
      );

      // Set audio scenario for media playback
      await engine.setAudioScenario(AudioScenarioType.audioScenarioDefault);

      debugPrint('✅ Viewing configuration completed');
    } catch (e) {
      debugPrint('❌ Error in viewing configuration: $e');
    }
  }

  Future<void> _requestPermissions() async {
    try {
      // Request both audio and camera permissions (camera needed for video receiving)
      Map<Permission, PermissionStatus> permissions =
          await [Permission.audio, Permission.camera].request();

      debugPrint('📱 Permissions: $permissions');
    } catch (e) {
      debugPrint('❌ Error requesting permissions: $e');
    }
  }

  void _startWatchTimer() {
    _watchStartTime = DateTime.now().millisecondsSinceEpoch;
    _watchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final duration = DateTime.now().millisecondsSinceEpoch - _watchStartTime;
      final hours = (duration ~/ 3600000).toString().padLeft(2, '0');
      final minutes = ((duration % 3600000) ~/ 60000).toString().padLeft(
        2,
        '0',
      );
      final seconds = ((duration % 60000) ~/ 1000).toString().padLeft(2, '0');
      watchDuration.value = '$hours:$minutes:$seconds';
    });
  }

  // Audio controls for viewer
  Future<void> toggleAudio() async {
    isAudioMuted.value = !isAudioMuted.value;
    await engine.muteAllRemoteAudioStreams(isAudioMuted.value);
    SnackBarUiView.showSuccess(
      message: isAudioMuted.value ? 'Audio muted' : 'Audio unmuted',
    );
  }

  Future<void> setAudioVolume(double volume) async {
    audioVolume.value = volume.round();
    await engine.adjustPlaybackSignalVolume(audioVolume.value);
  }

  // Leave live stream
  Future<void> leaveLive() async {
    try {
      _watchTimer?.cancel();

      // Dispose video controller first
      hostVideoController.value?.dispose();
      hostVideoController.value = null;

      await engine.leaveChannel();
      await engine.release();

      // Reset states
      isWatching.value = false;
      isEngineReady.value = false;
      isHostOnline.value = false;
      hostUid.value = 0;
      connectionState.value = 'disconnected';
      watchDuration.value = '00:00';

      debugPrint('✅ Successfully left live stream');
    } catch (e) {
      debugPrint('❌ Error leaving live: $e');
    }
  }

  // Share live stream
  void shareLive() {
    SnackBarUiView.showSuccess(message: 'Share link copied to clipboard');
  }

  // Report live stream
  void reportLive() {
    Get.snackbar(
      'Report',
      'Thank you for your report. We will review it shortly.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  // Network diagnostics for viewer
  Future<void> runNetworkTest() async {
    try {
      await engine.startLastmileProbeTest(
        const LastmileProbeConfig(
          probeUplink: false,
          probeDownlink: true,
          expectedUplinkBitrate: 0,
          expectedDownlinkBitrate: 500000,
        ),
      );

      SnackBarUiView.showSuccess(message: 'Running network test...');
    } catch (e) {
      debugPrint('❌ Network test error: $e');
    }
  }

  Rxn<GiftModel> giftModel = Rxn<GiftModel>();
  Future<void> fetchGift() async {
    try {
      final res = await BaseClient.get(api: EndPoint.getVirtualGifts);

      if (res != null && res.statusCode == 200) {
        giftModel.value = giftModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Response: ${json.encode(giftModel.value)}");
      } else {
        LoggerUtils.error("Error: ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      update();
    }
  }

  // Given Below API send Gift for Astrologer

  final userId = LocalStorageService.getUserId();

  Future<void> sendLiveGift({int? liveSessionID, int? giftID}) async {
    try {
      final res = await BaseClient.post(
        api: EndPoint.sendGift,
        data: {
          "LiveSessionID": liveSessionID,
          "SenderID": userId,
          "GiftID": giftID,
        },
      );
      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug("Response: ${res.data}");
        if (res.data["success"] == true) {
          Get.back();
          Get.snackbar(
            '🎁 Gift Selected',
            res.data["message"],
            colorText: AppColors.white,
            backgroundColor: AppColors.primaryColor.withValues(alpha: 0.5),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.all(16.w),
            borderRadius: 12.r,
          );
        } else {
          Get.snackbar(
            'Failed',
            res.data["message"],
            colorText: AppColors.white,
            backgroundColor: AppColors.red.withValues(alpha: 0.5),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.all(16.w),
            borderRadius: 12.r,
          );
        }
      } else {
        Get.snackbar(
          'Failed',
          res.data["message"],
          colorText: AppColors.white,
          backgroundColor: AppColors.red.withValues(alpha: 0.5),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16.w),
          borderRadius: 12.r,
        );
        LoggerUtils.error("Error: ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    fetchGift();
    initializeWebSocket();
    super.onInit();
  }

  //-------------------------Live Astrologer chat --------------------------------
  LiveWebshoketServices? liveWebshoketServices;
  StreamSubscription? _wsSubscription;
  final RxList<LiveAstrolorWebSoketModel> liveAstrolorWebSoketList =
      <LiveAstrolorWebSoketModel>[].obs;
  void initializeWebSocket() {
    // messages.clear();
    // scrollToBottom();
    // Check if WebSocketService is already initialized
    if (Get.isRegistered<LiveWebshoketServices>()) {
      liveWebshoketServices = Get.find<LiveWebshoketServices>();
    } else {
      liveWebshoketServices = Get.put(LiveWebshoketServices());
    }

    // Connect if not already connected
    if (!(liveWebshoketServices?.isConnected.value == true)) {
      liveWebshoketServices?.connect(sessionId: "86");
    }

    // Cancel previous subscription before listening again
    _wsSubscription?.cancel();

    // Listen to incoming messages
    _wsSubscription = liveWebshoketServices?.messageStream.listen((
      messageData,
    ) {
      handleIncomingMessage(messageData);
    });
  }

  int? currentUserID;
  LiveAstrolorWebSoketModel? liveAstrolorWebSoketModel;
  void handleIncomingMessage(Map<String, dynamic> messageData) {
    currentUserID = int.parse(userId.toString());
    LoggerUtils.debug("📨 Received message: $messageData");

    // Only handle valid chat messages
    if (messageData['type'] != 'chat_message') return;

    final message = LiveAstrolorWebSoketModel.fromJson(messageData);

    LoggerUtils.debug("👤 Message from another user");

    final alreadyExists = liveAstrolorWebSoketList.any(
      (m) => m.messageID == message.messageID,
    );

    if (!alreadyExists) {
      liveAstrolorWebSoketList.add(message);
      log(
        "✅ Added new message from other user ${json.encode(liveAstrolorWebSoketList)}",
      );
    } else {
      LoggerUtils.debug("⚠️ Duplicate message skipped");
    }
  }

  void sendMessageLocal() {
    // if (messageController.text.trim().isEmpty) return;

    final messageText = messageController.text.trim();

    if (messageController.text.length >= 3 &&
        RegExp(r'^[0-9]+$').hasMatch(messageController.text)) {
      messageController.clear();
      return;
    }
    final localId = DateTime.now().millisecondsSinceEpoch.toString();

    // ✅ Create local message for immediate UI update (NO messageID)
    // final localMessage = {
    //   {
    //     "action": "sendMessage",
    //     "senderId": 143,
    //     "messageType": "Text",
    //     "content": "Hello from WebSocket! 9",
    //     "fileUrl": null,
    //   },
    // };

    // ✅ Add local message immediately to show on screen
    // messages.add(localMessage);

    messageController.clear();
    // this.messageText.value = '';
    // isTyping.value = false;
    // scrollToBottom();

    LoggerUtils.debug(
      "✅ Added local message with status: sending - ID: $localId",
    );

    // Send via WebSocket
    final messageData = {
      "action": "sendMessage",
      "senderId": currentUserID,
      "messageType": "Text",
      "content": messageText,
      "fileUrl": null,
    };

    liveWebshoketServices?.sendMessage(messageData);

    // Update local message status to sent after sending
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   final index = messages.indexWhere((m) => m.id == localId);
    //   if (index != -1 && messages[index].status == MessageStatus.sending) {
    //     messages[index] = messages[index].copyWith(status: MessageStatus.sent);
    //     LoggerUtils.debug("✅ Updated local message status to: sent");
    //   }
    // });
  }
}

//------------------------- Model -------------------------
class LiveAstrolorWebSoketModel {
  final int? messageID;
  final int? sessionID;
  final int? senderID;
  final String? messageType;
  final String? content;
  final String? fileURL;
  final bool? isRead;
  final DateTime? sentAt;
  final String? source;
  final String? type;

  const LiveAstrolorWebSoketModel({
    this.messageID,
    this.sessionID,
    this.senderID,
    this.messageType,
    this.content,
    this.fileURL,
    this.isRead,
    this.sentAt,
    this.source,
    this.type,
  });

  factory LiveAstrolorWebSoketModel.fromJson(Map<String, dynamic> json) {
    return LiveAstrolorWebSoketModel(
      messageID:
          json['messageID'] is int
              ? json['messageID']
              : int.tryParse(json['messageID']?.toString() ?? ''),
      sessionID:
          json['sessionID'] is int
              ? json['sessionID']
              : int.tryParse(json['sessionID']?.toString() ?? ''),
      senderID:
          json['senderID'] is int
              ? json['senderID']
              : int.tryParse(json['senderID']?.toString() ?? ''),
      messageType: json['messageType']?.toString(),
      content: json['content']?.toString(),
      fileURL: json['fileURL']?.toString(),
      isRead:
          json['isRead'] is bool
              ? json['isRead']
              : (json['isRead']?.toString().toLowerCase() == 'true'),
      sentAt:
          json['sentAt'] != null
              ? DateTime.tryParse(json['sentAt'].toString())
              : null,
      source: json['source']?.toString(),
      type: json['type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'messageID': messageID,
      'sessionID': sessionID,
      'senderID': senderID,
      'messageType': messageType,
      'content': content,
      'fileURL': fileURL,
      'isRead': isRead,
      'sentAt': sentAt?.toIso8601String(),
      'source': source,
    };
  }

  LiveAstrolorWebSoketModel copyWith({
    int? messageID,
    int? sessionID,
    int? senderID,
    String? messageType,
    String? content,
    String? fileURL,
    bool? isRead,
    DateTime? sentAt,
    String? source,
    String? type,
  }) {
    return LiveAstrolorWebSoketModel(
      messageID: messageID ?? this.messageID,
      sessionID: sessionID ?? this.sessionID,
      senderID: senderID ?? this.senderID,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      fileURL: fileURL ?? this.fileURL,
      isRead: isRead ?? this.isRead,
      sentAt: sentAt ?? this.sentAt,
      source: source ?? this.source,
      type: type ?? this.type,
    );
  }
}
