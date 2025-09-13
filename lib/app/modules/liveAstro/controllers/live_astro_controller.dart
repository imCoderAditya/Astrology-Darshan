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

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:astrology/components/snack_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

const String APPID = "25747e4b1b9c43d8a8b7cde83abddf45";
const String APPCERTIFICATE = "3bac8b59eec041909daf6ef145021e45";

class LiveAstroController extends GetxController {
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
}
