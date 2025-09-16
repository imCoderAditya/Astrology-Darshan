// viewer_view.dart - UI for Users (Preview Only)
// ignore_for_file: deprecated_member_use

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/data/models/astrologer/live_astrologer_model.dart';
import 'package:astrology/app/modules/liveAstro/controllers/live_astro_controller.dart';
import 'package:astrology/components/custom_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ViewerView extends GetView<LiveAstroController> {
  final LiveAstrologer? liveAstrologer;
  const ViewerView({super.key, this.liveAstrologer});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveAstroController>(
      init: LiveAstroController(),
      builder: (controller) {
        return Obx(() {
          if (!controller.isEngineReady.value) {
            return _buildLoadingScreen();
          }

          return Stack(
            children: [
              // Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0A0E27),
                      Color(0xFF1A1F3A),
                      Color(0xFF2A2F4A),
                    ],
                  ),
                ),
              ),

              // Main Video View (Host's stream)
              _buildHostVideoView(),

              // Top Controls
              _buildTopControls(),

              // Bottom Controls
              // _buildBottomControls(),
              _buildTextField(),

              // Side Controls
              // _buildSideControls(),

              // Connection Status
              _buildConnectionStatus(),

              // Watch Timer
              _buildWatchTimer(),

              // Host Info
              _buildHostInfo(),
            ],
          );
        });
      },
    );
  }

  Widget _buildTextField() {
    return Positioned(
      bottom: 40.h,
      left: 16.w,
      right: 16.w,
      child: Row(
        children: [
          // Chat Input Field
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: Colors.white54, fontSize: 14.sp),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
          SizedBox(width: 10.w),

          // Gift Icon Button
          InkWell(
            onTap: () {
              giftBottomSheet();
            },
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(color: AppColors.white.withOpacity(0.3)),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF2A2F4A)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D4FF)),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Joining live stream...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please wait while we connect you',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHostVideoView() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child:
              controller.hostVideoController.value != null &&
                      controller.isHostOnline.value
                  ? AgoraVideoView(
                    controller: controller.hostVideoController.value!,
                  )
                  : Container(
                    color: Colors.black.withOpacity(0.8),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.tv_off,
                            color: Color(0xFF00D4FF),
                            size: 80,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Host is not live yet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Waiting for the astrologer to start...',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 24),
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF00D4FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: () => _showLeaveDialog(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),

          // Live indicator (only show when host is live)
          if (controller.isHostOnline.value)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.fiber_manual_record, color: Colors.white, size: 8),
                  SizedBox(width: 4),
                  Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          // Share button
          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.black.withOpacity(0.3),
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: IconButton(
          //     onPressed: controller.shareLive,
          //     icon: const Icon(Icons.share, color: Colors.white),
          //   ),
          // ),
          Row(
            children: [
              _buildControlButton(
                icon:
                    controller.isAudioMuted.value
                        ? Icons.volume_off
                        : Icons.volume_up,
                isActive: !controller.isAudioMuted.value,
                onPressed: controller.toggleAudio,
                tooltip:
                    controller.isAudioMuted.value
                        ? 'Unmute audio'
                        : 'Mute audio',
              ),
              SizedBox(width: 10.w),
              // Volume Control
              _buildControlButton(
                icon: Icons.tune,
                isActive: true,
                onPressed: () => _showAudioControlDialog(),
                tooltip: 'Audio settings',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Positioned(
      top: 120.h,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _getConnectionColor().withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getConnectionIcon(), color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Text(
              _getConnectionText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchTimer() {
    return Positioned(
      top: 160.h,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Obx(
              () => Text(
                controller.watchDuration.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHostInfo() {
    return Positioned(
      bottom: 100.h,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 12,
              backgroundColor: Color(0xFF00D4FF),
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              controller.userName ?? 'Astrologer',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 35.w,
        height: 35.h,
        decoration: BoxDecoration(
          color: isActive ? Colors.transparent : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                isActive
                    ? AppColors.primaryColor
                    : Colors.white.withOpacity(0.3),
          ),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: isActive ? Colors.white : Colors.white70,
            size: 24,
          ),
        ),
      ),
    );
  }

  Color _getConnectionColor() {
    switch (controller.connectionState.value) {
      case 'watching':
        return Colors.green;
      case 'connecting':
        return Colors.orange;
      case 'reconnecting':
        return Colors.yellow;
      default:
        return Colors.red;
    }
  }

  IconData _getConnectionIcon() {
    switch (controller.connectionState.value) {
      case 'watching':
        return Icons.signal_cellular_alt;
      case 'connecting':
        return Icons.sync;
      case 'reconnecting':
        return Icons.sync_problem;
      default:
        return Icons.signal_cellular_connected_no_internet_0_bar;
    }
  }

  String _getConnectionText() {
    switch (controller.connectionState.value) {
      case 'watching':
        return 'Watching';
      case 'connecting':
        return 'Connecting...';
      case 'reconnecting':
        return 'Reconnecting...';
      default:
        return 'Connection failed';
    }
  }

  void _showLeaveDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text(
          'Leave Live Stream',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to leave this live stream?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.leaveLive();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Leave', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  void _showAudioControlDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text(
          'Audio Settings',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Volume', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Obx(
              () => Slider(
                value: controller.audioVolume.value.toDouble(),
                min: 0,
                max: 100,
                divisions: 10,
                label: '${controller.audioVolume.value}%',
                activeColor: const Color(0xFF00D4FF),
                onChanged: (double value) => controller.setAudioVolume(value),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  controller.isAudioMuted.value
                      ? Icons.volume_off
                      : Icons.volume_up,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  controller.isAudioMuted.value ? 'Audio Muted' : 'Audio On',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: controller.toggleAudio,
            child: Text(controller.isAudioMuted.value ? 'Unmute' : 'Mute'),
          ),
          TextButton(onPressed: () => Get.back(), child: const Text('Done')),
        ],
      ),
    );
  }

  void giftBottomSheet() {
    Get.bottomSheet(
      GetBuilder<LiveAstroController>(
        init: LiveAstroController(),
        builder: (controller) {
          return Container(
            height: Get.height * 0.9,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0xFF1A1F3A), const Color(0xFF0F1426)],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle and Header
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    children: [
                      // Sheet Handle
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 50.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.accentColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Header with animation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppColors.headerGradientColors,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.card_giftcard_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Send a Divine Gift',
                            style: AppTextStyles.headlineMedium().copyWith(
                              color: Colors.white,
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        'Share blessings with your loved ones',
                        style: AppTextStyles.body().copyWith(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Grid Title
                        Text(
                          'Choose Your Gift',
                          style: AppTextStyles.body().copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Gift Grid
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.giftModel.value?.data?.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.w,
                                mainAxisSpacing: 16.h,
                                mainAxisExtent: 150.h,
                              ),
                          itemBuilder: (context, index) {
                            final gift =
                                controller.giftModel.value?.data?[index];
                            return GestureDetector(
                              onTap: () {
                                // Add haptic feedback
                                HapticFeedback.lightImpact();

                                // Show selection animation
                                // Get.snackbar(
                                //   '🎁 Gift Selected',
                                //   'Added ${gift?.giftName ?? ""} to your gift',

                                //   colorText: Colors.white,
                                //   duration: const Duration(seconds: 2),
                                //   snackPosition: SnackPosition.TOP,
                                //   margin: EdgeInsets.all(16.w),
                                //   borderRadius: 12.r,
                                //   icon: CustomCachedNetworkImage(
                                //     imageUrl: gift?.giftAnimation ?? "",
                                //   ),
                                // );

                                controller.sendLiveGift(
                                  giftID: gift?.giftId,
                                  liveSessionID: liveAstrologer?.astrologerId,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      gift?.giftAnimation ?? "",
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Icon with gradient background
                                      Container(
                                        height: 50.h,
                                        width: 60.w,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              gift?.giftImage ?? "",
                                            ),
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: CustomCachedNetworkImage(
                                          imageUrl: gift?.giftImage ?? "",
                                        ),
                                      ),

                                      SizedBox(height: 12.h),

                                      // Gift Name
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          color: AppColors.backgroundDark
                                              .withValues(alpha: 0.4),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              gift?.giftName ?? "",

                                              style: AppTextStyles.body()
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.sp,
                                                  ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                            SizedBox(height: 4.h),

                                            // Price
                                            Text(
                                              "\u20B9 ${gift?.price.toString() ?? ""}",
                                              style: AppTextStyles.body()
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.sp,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 24.w,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.body().copyWith(
                        color: Colors.white70,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  // not used code given bellow
  /*
  Widget _buildReportOption(String option) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Radio<String>(
              value: option,
              groupValue: null,
              onChanged: (value) {},
              activeColor: const Color(0xFF00D4FF),
            ),
            Expanded(
              child: Text(option, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildQualityInfoItem(String title, String value, Color color) {
    return ListTile(
      leading: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Text(
        value,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _getNetworkQualityText() {
    switch (controller.networkQuality.value) {
      case 'excellent':
        return 'Excellent';
      case 'poor':
        return 'Poor';
      default:
        return 'Fair';
    }
  }

  Color _getNetworkQualityColor() {
    switch (controller.networkQuality.value) {
      case 'excellent':
        return Colors.green;
      case 'poor':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  void _showChatDialog() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1F3A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Live Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const Center(
                  child: Text(
                    'Chat feature coming soon!\nYou\'ll be able to interact with the astrologer here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60, fontSize: 16),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: const TextStyle(color: Colors.white30),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF00D4FF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: null,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text(
          'Report Live Stream',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why are you reporting this live stream?',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            _buildReportOption('Inappropriate content'),
            _buildReportOption('Spam or misleading'),
            _buildReportOption('Harassment or bullying'),
            _buildReportOption('Copyright violation'),
            _buildReportOption('Other'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.reportLive();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Report', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


    void _showQualityDialog() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1F3A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Stream Quality',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _buildQualityInfoItem(
              'Network Quality',
              _getNetworkQualityText(),
              _getNetworkQualityColor(),
            ),
            _buildQualityInfoItem(
              'Connection',
              _getConnectionText(),
              _getConnectionColor(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.runNetworkTest();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Run Speed Test',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


    Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }

 void _toggleFullscreen() {
    // Implement fullscreen functionality
    Get.snackbar(
      'Fullscreen',
      'Fullscreen mode activated',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A1F3A),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

 void _showMoreOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1F3A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'More Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _buildSettingsItem(
              'Share Stream',
              Icons.share,
              controller.shareLive,
            ),
            _buildSettingsItem(
              'Report Stream',
              Icons.flag,
              () => _showReportDialog(),
            ),
            _buildSettingsItem('Network Test', Icons.network_check, () {
              controller.runNetworkTest();
              Get.back();
            }),
            _buildSettingsItem('Help & Support', Icons.help, () {
              Get.snackbar(
                'Help',
                'For support, please contact our help center.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF1A1F3A),
                colorText: Colors.white,
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }



  Widget _buildSideButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color:
              isActive
                  ? const Color(0xFF00D4FF)
                  : Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 40,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Audio Toggle Button
            _buildControlButton(
              icon:
                  controller.isAudioMuted.value
                      ? Icons.volume_off
                      : Icons.volume_up,
              isActive: !controller.isAudioMuted.value,
              onPressed: controller.toggleAudio,
              tooltip:
                  controller.isAudioMuted.value ? 'Unmute audio' : 'Mute audio',
            ),

            // Volume Control
            _buildControlButton(
              icon: Icons.tune,
              isActive: true,
              onPressed: () => _showAudioControlDialog(),
              tooltip: 'Audio settings',
            ),

            // Leave Button
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => _showLeaveDialog(),
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 28,
                ),
                tooltip: 'Leave stream',
              ),
            ),

            // Quality Settings
            _buildControlButton(
              icon: Icons.hd,
              isActive: true,
              onPressed: () => _showQualityDialog(),
              tooltip: 'Video quality',
            ),

            // More options
            _buildControlButton(
              icon: Icons.more_vert,
              isActive: true,
              onPressed: () => _showMoreOptions(),
              tooltip: 'More options',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideControls() {
    return Positioned(
      right: 16,
      top: 260,
      child: Column(
        children: [
          // Chat button
          _buildSideButton(
            icon: Icons.chat,
            onPressed: () => _showChatDialog(),
            tooltip: 'Chat',
          ),
          const SizedBox(height: 12),

          // Share button
          _buildSideButton(
            icon: Icons.share,
            onPressed: controller.shareLive,
            tooltip: 'Share',
          ),
          const SizedBox(height: 12),

          // Report button
          _buildSideButton(
            icon: Icons.flag,
            onPressed: () => _showReportDialog(),
            tooltip: 'Report',
          ),
          const SizedBox(height: 12),

          // Fullscreen button
          _buildSideButton(
            icon: Icons.fullscreen,
            onPressed: () => _toggleFullscreen(),
            tooltip: 'Fullscreen',
          ),
        ],
      ),
    );
  }
*/
}
