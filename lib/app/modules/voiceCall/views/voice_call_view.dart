// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/data/models/userRequest/user_request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/voice_call_controller.dart';

class VoiceCallView extends StatefulWidget {
  final String? channelName;
  final Session? session;

  const VoiceCallView({super.key, this.channelName, this.session});

  @override
  State<VoiceCallView> createState() => _VoiceCallViewState();
}

class _VoiceCallViewState extends State<VoiceCallView> {
  final VoiceCallController controller = Get.put(VoiceCallController());

  @override
  void dispose() {
    controller.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("====>${json.encode(widget.session)}");
    controller.channelName.value = widget.channelName ?? "";
    return WillPopScope(
      onWillPop:
          () async =>
              false, //await controller.showEndChatDialog(context) ?? false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Voice Call', style: TextStyle(color: AppColors.white)),
          centerTitle: false,
          automaticallyImplyLeading: false,

          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: AppColors.white),
          //   onPressed:
          //       () async => {await controller.showEndChatDialog(context)},
          // ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    controller.connectionStatus,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.indigo],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Channel Info
                // _buildChannelInfo(),

                // Participants List
                Expanded(
                  child: _buildParticipantsList(session: widget.session),
                ),

                // Control Buttons
                _buildControlButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📌 Show confirmation dialog before ending chat or popping the screen

  // Widget _buildChannelInfo() {
  //   return Container(
  //     margin: const EdgeInsets.all(16),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           'Channel: $channelName',
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Obx(
  //           () => Text(
  //             '${controller.participantsCount} Participant(s)',
  //             style: const TextStyle(color: Colors.white70, fontSize: 14),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildParticipantsList({Session? session}) {
    return Obx(() {
      if (!controller.isJoined.value && !controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mic_off, size: 80, color: Colors.white54),
              const SizedBox(height: 16),
              const Text(
                'Tap "Join Call" to start',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed:
                    () => controller.joinChannel(widget.channelName ?? ""),
                icon: const Icon(Icons.call),
                label: const Text('Join Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      if (controller.isLoading.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Connecting...',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        );
      }

      // Show participants
      List<Widget> participants = [];

      // Add local user
      participants.add(
        _buildParticipantCard(
          name: "You",
          photo:
              controller
                  .profileController
                  .profileModel
                  .value
                  ?.data
                  ?.profilePicture ??
              "",
          uid: controller.localUid.value,
          isLocal: true,
          isMuted: controller.isMuted.value,
        ),
      );
      // Add remote users
      for (int uid in controller.remoteUsers) {
        participants.add(
          _buildParticipantCard(
            uid: uid,
            name: session?.astrologerName ?? "",
            photo: session?.astrologerPhoto ?? "",
            isLocal: false,
            isMuted: false, // You can track remote mute status if needed
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: participants.length,
        itemBuilder: (context, index) => participants[index],
      );
    });
  }

  Widget _buildParticipantCard({
    required int uid,
    required bool isLocal,
    required bool isMuted,
    String? name,
    String? photo,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: isLocal ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade300,
            child:
                widget.session?.astrologerPhoto?.isNotEmpty ?? false
                    ? ClipOval(
                      child: Image.network(
                        photo ?? "",
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, color: Colors.white);
                        },
                      ),
                    )
                    : const Icon(Icons.person, color: Colors.white),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$name",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (isMuted) const Icon(Icons.mic_off, color: Colors.red, size: 20),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Obx(() {
        if (!controller.isJoined.value) {
          return const SizedBox.shrink();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mute/Unmute Button
            _buildControlButton(
              icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
              color: controller.isMuted.value ? Colors.red : Colors.green,
              onPressed: controller.toggleMute,
            ),

            // Speaker Button
            _buildControlButton(
              icon:
                  controller.isSpeakerOn.value
                      ? Icons.volume_up
                      : Icons.volume_down,
              color: controller.isSpeakerOn.value ? Colors.blue : Colors.grey,
              onPressed: controller.toggleSpeaker,
            ),

            // End Call Button
            _buildControlButton(
              icon: Icons.call_end,
              color: Colors.red,
              onPressed: () async {
                await controller.showEndChatDialog(Get.context!);
                Get.back();
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 28,
      ),
    );
  }
}
