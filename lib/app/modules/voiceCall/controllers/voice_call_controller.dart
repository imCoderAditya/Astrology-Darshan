// 1. Agora Controller - GetX Controller for managing voice call state
// ignore_for_file: constant_identifier_names

import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/modules/userRequest/controllers/user_request_controller.dart';
import 'package:astrology/components/confirm_dailog_box.dart';
import 'package:astrology/components/global_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceCallController extends GetxController {
  static const String APPID = "8afca3f27f524c65a4ead12c1f5f92fa";
  static const String APPCERTIFICATE = "d1dc9896ab264eb18df26c49dfe96e01";

  // Agora Engine instance
  RtcEngine? engine;

  // Observable variables
  RxBool isJoined = false.obs;
  RxBool isMuted = false.obs;
  RxBool isLoading = false.obs;
  RxBool isSpeakerOn = false.obs;
  RxList<int> remoteUsers = <int>[].obs;
  RxString channelName = ''.obs;
  RxInt localUid = 0.obs;

  String? token;

  @override
  void onReady() {
    generateToken(channelName: channelName.value, userName: "Sachin");
    super.onReady();
  }

  @override
  void onClose() {
    leaveChannel();
    engine?.release();
    super.onClose();
  }

  // Initialize Agora SDK
  Future<void> initializeAgora() async {
    try {
      // Request microphone permission
      await requestMicrophonePermission();

      // Create Agora engine
      engine = createAgoraRtcEngine();

      await engine?.initialize(
        RtcEngineContext(
          appId: APPID,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      // Enable audio
      await engine?.enableAudio();

      joinChannel(channelName.value, uid: localUid.value);

      // Set event handlers
      _setEventHandlers();

      LoggerUtils.debug("Agora SDK initialized successfully");
    } catch (e) {
      LoggerUtils.error("Error initializing Agora: $e");
      Get.snackbar("Error", "Failed to initialize voice call: $e");
    }
  }

  /// Requests microphone permission and throws an exception if not granted
  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;

    if (!status.isGranted) {
      // Request permission
      status = await Permission.microphone.request();
    }

    if (!status.isGranted) {
      // Permission denied
      throw Exception('Microphone permission not granted');
    }
  }

  // Set up event handlers
  void _setEventHandlers() {
    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          LoggerUtils.debug(
            "Local user joined channel: ${connection.channelId}",
          );
          isJoined.value = true;
          localUid.value = connection.localUid!;
          isLoading.value = false;
          // Get.snackbar(
          //   "Success",
          //   "Joined channel successfully",
          //   backgroundColor: Colors.green,
          //   colorText: Colors.white,
          // );
        },

        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          LoggerUtils.debug("Remote user joined: $remoteUid");
          remoteUsers.add(remoteUid);
          Get.snackbar(
            "User Joined",
            "User $remoteUid joined the call",
            backgroundColor: Colors.blue,
            colorText: Colors.white,
          );
        },

        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) {
          LoggerUtils.debug("Remote user left: $remoteUid");
          remoteUsers.remove(remoteUid);
          Get.snackbar(
            "User Left",
            "User $remoteUid left the call",
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        },

        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          LoggerUtils.debug("Left channel");
          isJoined.value = false;
          remoteUsers.clear();
          localUid.value = 0;
          channelName.value = '';
        },

        onAudioVolumeIndication: (
          RtcConnection connection,
          List<AudioVolumeInfo> speakers,
          int speakerNumber,
          int totalVolume,
        ) {
          // Handle volume indication if needed
          // You can use this to show speaking indicators
        },

        onError: (ErrorCodeType err, String msg) {
          LoggerUtils.error("Agora Error: $err - $msg");
          Get.snackbar(
            "Error",
            "Voice call error: $msg",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
      ),
    );
  }

  Future<void> generateToken({String? channelName, String? userName}) async {
    GlobalLoader.show();
    // Your Agora project credentials

    // const String channelName = 'Test';
    const int tokenExpireSeconds = 3600; // 1 hour
    final uniqueUid = DateTime.now().millisecondsSinceEpoch % 1000000000;

    // Generate RTC token
    String etcToken = RtcTokenBuilder.buildTokenWithUid(
      appId: APPID,
      appCertificate: APPCERTIFICATE,
      channelName: channelName ?? "",
      uid: uniqueUid,
      tokenExpireSeconds: tokenExpireSeconds,
    );
    token = etcToken;
    localUid.value = uniqueUid;
    this.channelName.value = channelName ?? "";
    // this.userName = userName;
    update();
    LoggerUtils.debug('🎯initail RTC Token: $token');
    LoggerUtils.debug('🎯initail RTC UId: $uniqueUid');
    LoggerUtils.debug('🎯initail RTC Channel: $channelName');

    await initializeAgora();
    GlobalLoader.hide();
  }

  // Join a voice channel
  Future<void> joinChannel(String channel, {int uid = 0}) async {
    if (isJoined.value) {
      Get.snackbar("Warning", "Already in a channel");
      return;
    }

    try {
      isLoading.value = true;
      channelName.value = channel;

      // For production, generate token server-side
      // For testing, you can use null or generate a temporary token

      await engine?.joinChannel(
        token: token ?? "",
        channelId: channel,
        uid: uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
          autoSubscribeAudio: true,
        ),
      );
    } catch (e) {
      isLoading.value = false;
      LoggerUtils.error("Error joining channel: $e");
      Get.snackbar("Error", "Failed to join channel: $e");
    }
  }

  // Leave the current channel
  Future<void> leaveChannel() async {
    if (!isJoined.value) return;

    try {
      await engine!.leaveChannel();
      LoggerUtils.error("Left channel successfully");
    } catch (e) {
      LoggerUtils.error("Error leaving channel: $e");
    }
  }

  // Toggle mute/unmute
  Future<void> toggleMute() async {
    if (!isJoined.value) return;

    try {
      isMuted.value = !isMuted.value;
      await engine!.muteLocalAudioStream(isMuted.value);
      LoggerUtils.error("Audio ${isMuted.value ? 'muted' : 'unmuted'}");
    } catch (e) {
      LoggerUtils.error("Error toggling mute: $e");
    }
  }

  // Toggle speaker on/off
  Future<void> toggleSpeaker() async {
    try {
      isSpeakerOn.value = !isSpeakerOn.value;
      await engine?.setEnableSpeakerphone(isSpeakerOn.value);
      debugPrint("Speaker ${isSpeakerOn.value ? 'enabled' : 'disabled'}");
    } catch (e) {
      debugPrint("Error toggling speaker: $e");
    }
  }

  // Get connection status
  String get connectionStatus {
    if (isLoading.value) return "Connecting...";
    if (isJoined.value) return "Connected";
    return "Disconnected";
  }

  // Get participants count
  int get participantsCount => remoteUsers.length + (isJoined.value ? 1 : 0);
  final userRequsetController = Get.put(UserRequestController());
  Future<bool?> showEndChatDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => ConfirmDialog(
            title: "End Chat",
            content: "Are you sure you want to end the Chat?",
            cancelText: "No",
            confirmText: "Yes, End",
            isDanger: true,
            onConfirm: () async {
              await userRequsetController
                  .statusUpdate("Completed", int.parse(channelName.value))
                  .then((_) {
                    leaveChannel();
                  });
              Get.back(); // Pop screen
            },
          ),
    );
  }
}
