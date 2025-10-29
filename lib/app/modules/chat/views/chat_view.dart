// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/data/models/userRequest/user_request_model.dart';
import 'package:astrology/app/modules/chat/components/request_submitted_popup.dart';
import 'package:astrology/app/modules/chat/controllers/chat_controller.dart';
import 'package:astrology/app/modules/userRequest/controllers/user_request_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/foundation.dart' as foundation;

// Main Chat Screen
class ChatView extends StatefulWidget {
  final String? nativationType;
  final Session? sessionData;
  final int? endTime;
  const ChatView({
    super.key,
    this.sessionData,
    this.endTime,
    this.nativationType,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final controller = Get.put(ChatController());
  final userRequestController = Get.put(UserRequestController());
  bool isCancelled = false;
  initilize() async {
    controller.messageController.clear();
    controller.endTime = widget.endTime;
    debugPrint("=========>${widget.endTime}");
    controller.timerText.value = "";
    controller.navigationPage = widget.nativationType;
    controller.update();
    if (widget.nativationType == "chat&call") {
      debugPrint("Sorry not showing popup");
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => RequestSubmittedPopup(
              astrologerName: widget.sessionData?.astrologerName ?? "",
              astrologerPhoto: widget.sessionData?.astrologerPhoto ?? "",
              requestType: "chat",
              waitingTime: "2-5 mins",
              onOkayPressed: () {
                isCancelled = true;
                setState(() {});
                callcontroller
                    .statusUpdate("Cancelled", controller.sessionID, "chat")
                    .then((value) async {
                      debugPrint("Cancelled API call :${controller.sessionID}");
                    });
              },
              onCancelPressed: () {},
            ),
      );
    }

    debugPrint("Time: ${controller.endTime}");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initilize();
    });
  }

  final callcontroller =
      Get.isRegistered<UserRequestController>()
          ? Get.find<UserRequestController>()
          : Get.put(UserRequestController());
  @override
  void dispose() {
    // controller.webSocketService?.disconnect();
    // controller.showEmojiPicker.value = false

    if (controller.isDisable.value == false) {
      controller.sendMessage(message: "Disconnect");
    }
    Future.delayed(Duration(microseconds: 200));
    controller.webSocketService?.disconnect();
    controller.showEmojiPicker.value = false;

    controller.timerService.stopTimer();
    if (!isCancelled) {
      callcontroller
          .statusUpdate("Completed", controller.sessionID, "chat")
          .then((value) async {
            debugPrint("complete API call :${controller.sessionID}");
          });
    }
    isCancelled = false;
    controller.isDisable.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    debugPrint("Timer: ${controller.endTime}");
    debugPrint("Photo: ${widget.sessionData?.astrologerPhoto}");
    //  debugPrint("Timer: ${ widget.endTime}");

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async {
        if (controller.isDisable.value == false) {
          final shouldClose = await _showExitConfirmationDialog();
          return shouldClose;
        } else {
          return true;
        }
      },

      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0B141A) : const Color(0xFFE3DAC7),
        appBar: _buildAppBar(controller, isDark),
        body: Column(
          children: [
            Obx(
              () =>
                  controller.webSocketService?.isConnected.value == false
                      ? _buildConnectionStatus(controller)
                      : SizedBox(),
            ),
            Expanded(child: _buildMessagesList(controller)),
            Obx(() {
              return controller.isDisable.value == true
                  ? Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.offline_bolt,
                          color: Colors.red,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Chat Disconnected",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  )
                  : _buildMessageInput(controller, isDark);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(ChatController controller) {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
        color:
            controller.webSocketService?.isConnected.value == true
                ? Colors.green.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
        child: Text(
          controller.webSocketService?.connectionStatus.value ?? "",
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontSize: 12.sp,
            color:
                controller.webSocketService?.isConnected.value ?? false
                    ? Colors.green[700]
                    : Colors.red[700],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "";
    final parts = name.trim().split(" ");
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  PreferredSizeWidget _buildAppBar(ChatController controller, bool isDark) {
    return AppBar(
      backgroundColor:
          isDark ? const Color(0xFF1F2C34) : const Color(0xFF075E54),
      elevation: 1,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () async {
          if (controller.isDisable.value == false) {
            bool shouldClose = await _showExitConfirmationDialog();
            if (shouldClose) {
              Get.back();
            }
          } else {
            Get.back();
          }
        },
      ),

      title: Row(
        children: [
          Hero(
            tag: 'profile_${widget.sessionData?.astrologerName ?? ""}',
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.green,
              child: ClipOval(
                child:
                    widget.sessionData?.astrologerPhoto?.isNotEmpty ?? false
                        ? Image.network(
                          widget.sessionData?.astrologerPhoto ?? "",
                          fit: BoxFit.cover,
                          width: 40.r,
                          height: 40.r,
                          errorBuilder: (context, error, stackTrace) {
                            // Show initials when image fails
                            return Center(
                              child: Text(
                                _getInitials(
                                  widget.sessionData?.astrologerName ?? "",
                                ),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        )
                        : Center(
                          child: Text(
                            _getInitials(
                              widget.sessionData?.astrologerName ?? "",
                            ),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
              ),
            ),
          ),

          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sessionData?.astrologerName ?? "",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => Text(
                    controller.webSocketService?.isConnected.value ?? false
                        ? controller.isDisable.value
                            ? "Offline"
                            : controller.lastSeen.value
                        : 'Connecting...',
                    style: GoogleFonts.openSans(
                      color:
                          controller.isDisable.value
                              ? AppColors.white.withValues(alpha: 0.8)
                              : AppColors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Obx(
          () =>
              controller.isDisable.value
                  ? SizedBox()
                  : Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                controller.timerText.value.isEmpty
                                    ? ""
                                    : "Timer: ", // ✅ Static part
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: controller.timerText.value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.yellow, // अलग color दे सकते हो
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _buildMessagesList(ChatController controller) {
    return FadeTransition(
      opacity: controller.fadeAnimation,
      child: Obx(
        () => ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          itemCount: controller.messages.length,
          itemBuilder: (context, index) {
            final message = controller.messages[index];
            return _buildMessageBubble(message);
          },
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment:
          message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
        child: Column(
          crossAxisAlignment:
              message.isSentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 280.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient:
                    message.isSentByMe
                        ? const LinearGradient(
                          colors: [Color(0xFF128C7E), Color(0xFF075E54)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                        : null,
                color: message.isSentByMe ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                  bottomLeft:
                      message.isSentByMe
                          ? Radius.circular(18.r)
                          : Radius.circular(4.r),
                  bottomRight:
                      message.isSentByMe
                          ? Radius.circular(4.r)
                          : Radius.circular(18.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.type == MessageType.image) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        message.imageUrl ?? message.text,
                        width: 250.w,
                        height: 200.h,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 250.w,
                            height: 200.h,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    Text(
                      message.text,
                      style: GoogleFonts.openSans(
                        color:
                            message.isSentByMe ? Colors.white : Colors.black87,
                        fontSize: 14.sp,
                        height: 1.3,
                      ),
                    ),
                  ],
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: GoogleFonts.openSans(
                          color:
                              message.isSentByMe
                                  ? Colors.white70
                                  : Colors.grey[600],
                          fontSize: 11.sp,
                        ),
                      ),
                      if (message.isSentByMe) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          _getStatusIcon(message.status),
                          size: 14.r,
                          color:
                              message.status == MessageStatus.read
                                  ? Colors.blue[300]
                                  : Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(ChatController controller, bool isDark) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2C34) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? const Color(0xFF2A3942)
                              : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Row(
                      children: [
                        Obx(
                          () => IconButton(
                            icon: Icon(
                              controller.showEmojiPicker.value
                                  ? Icons.keyboard
                                  : Icons.emoji_emotions_outlined,
                              color: isDark ? Colors.white70 : Colors.grey[600],
                              size: 24.r,
                            ),
                            onPressed: () {
                              controller.toggleEmojiPicker();
                              // Hide keyboard when showing emoji picker
                              if (controller.showEmojiPicker.value) {
                                FocusScope.of(Get.context!).unfocus();
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.messageController,
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                            onTap: () {
                              // Hide emoji picker when tapping text field
                              if (controller.showEmojiPicker.value) {
                                controller.hideEmojiPicker();
                              }
                            },
                            style: GoogleFonts.openSans(
                              fontSize: 16.sp,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: GoogleFonts.openSans(
                                color:
                                    isDark ? Colors.white54 : Colors.grey[500],
                                fontSize: 16.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.h,
                              ),
                            ),
                          ),
                        ),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.attach_file,
                        //     color: isDark ? Colors.white70 : Colors.grey[600],
                        //     size: 24.r,
                        //   ),
                        //   onPressed: () {},
                        // ),
                        // Obx(
                        //   () =>
                        //       controller.messageText.isEmpty
                        //           ? IconButton(
                        //             icon: Icon(
                        //               Icons.camera_alt,
                        //               color:
                        //                   isDark
                        //                       ? Colors.white70
                        //                       : Colors.grey[600],
                        //               size: 24.r,
                        //             ),
                        //             onPressed: () {},
                        //           )
                        //           : const SizedBox.shrink(),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (controller.messageText.isNotEmpty) {
                        controller.sendMessage();
                        controller.scrollToBottom();
                      }
                    },
                    child: Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF128C7E), Color(0xFF075E54)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF075E54).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        controller.messageText.isNotEmpty
                            ? Icons.send
                            : Icons.send,
                        color: Colors.white,
                        size: 20.r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Emoji Picker Panel
        Obx(
          () =>
              controller.showEmojiPicker.value
                  ? Container(
                    height: 256,
                    color: isDark ? const Color(0xFF1F2C34) : Colors.white,
                    child: EmojiPicker(
                      // onEmojiSelected: (Category category, Emoji emoji) {
                      //     // Do something when emoji is tapped (optional)
                      // },
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)
                        // Set it to null to hide the Backspace-Button
                      },
                      textEditingController:
                          controller
                              .messageController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        height: 256,
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax:
                              28 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.20
                                  : 1.0),
                        ),
                        viewOrderConfig: const ViewOrderConfig(
                          top: EmojiPickerItem.categoryBar,
                          middle: EmojiPickerItem.emojiView,
                          bottom: EmojiPickerItem.searchBar,
                        ),
                        skinToneConfig: const SkinToneConfig(),
                        categoryViewConfig: const CategoryViewConfig(),
                        bottomActionBarConfig: const BottomActionBarConfig(),
                        searchViewConfig: const SearchViewConfig(),
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  IconData _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icons.schedule;
      case MessageStatus.sent:
        return Icons.done;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
    }
  }

  // Add this method to your _ChatViewState class
  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false, // Prevents dismissing by tapping outside
          builder: (BuildContext context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1F2C34) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                      size: 24.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'End Chat Session?',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                'Are you sure you want to close this chat? This action will end the current session and cannot be undone.',
                style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white70 : Colors.black54,
                  height: 1.4,
                ),
              ),
              actions: [
                // Cancel Button
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop(false); // Return false (don't close)
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ),

                // Proceed Button
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'End Chat',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }
}
