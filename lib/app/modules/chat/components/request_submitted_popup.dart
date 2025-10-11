import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestSubmittedPopup extends StatelessWidget {
  final String astrologerName;
  final String astrologerPhoto;
  final String requestType; // "Chat", "Call", "Video Call"
  final String waitingTime; // "2-5 mins"
  final VoidCallback? onOkayPressed;
  final VoidCallback? onCancelPressed;

  const RequestSubmittedPopup({
    super.key,
    required this.astrologerName,
    this.astrologerPhoto = '',
    this.requestType = 'Chat',
    this.waitingTime = '2-5 mins',
    this.onOkayPressed,
    this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [const Color(0xFF1F2C34), const Color(0xFF0B141A)]
                    : [const Color(0xFFE3DAC7), const Color(0xFFD4C5B0)],
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon with Animation
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF128C7E), Color(0xFF075E54)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF075E54).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 45.r,
              ),
            ),

            SizedBox(height: 24.h),

            // Title
            Text(
              'Request Submitted!',
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF075E54),
              ),
            ),

            SizedBox(height: 12.h),

            // Description
            Text(
              'Your $requestType request has been sent to the astrologer. Please wait for their response.',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 14.sp,
                color: isDark ? Colors.white70 : Colors.black54,
                height: 1.5,
              ),
            ),

            SizedBox(height: 24.h),

            // Astrologer Details Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? const Color(0xFF2A3942).withOpacity(0.5)
                        : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: const Color(0xFF128C7E).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Astrologer Info
                  Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 28.r,
                        backgroundColor: const Color(0xFF128C7E),
                        child: ClipOval(
                          child:
                              astrologerPhoto.isNotEmpty
                                  ? Image.network(
                                    astrologerPhoto,
                                    fit: BoxFit.cover,
                                    width: 56.r,
                                    height: 56.r,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          _getInitials(astrologerName),
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                  : Center(
                                    child: Text(
                                      _getInitials(astrologerName),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // Name & Status
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              astrologerName,
                              style: GoogleFonts.poppins(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.h,
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Waiting for response',
                                  style: GoogleFonts.openSans(
                                    fontSize: 12.sp,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Divider
                  Divider(
                    color: isDark ? Colors.white24 : Colors.black12,
                    thickness: 1,
                  ),

                  SizedBox(height: 16.h),

                  // Request Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Request Type
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Request Type',
                            style: GoogleFonts.openSans(
                              fontSize: 12.sp,
                              color: isDark ? Colors.white60 : Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF128C7E), Color(0xFF075E54)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getRequestIcon(requestType),
                                  color: Colors.white,
                                  size: 14.r,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  requestType,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Waiting Time
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Expected Wait',
                            style: GoogleFonts.openSans(
                              fontSize: 12.sp,
                              color: isDark ? Colors.white60 : Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                color:
                                    isDark
                                        ? const Color(0xFF128C7E)
                                        : const Color(0xFF075E54),
                                size: 16.r,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                waitingTime,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isDark
                                          ? const Color(0xFF128C7E)
                                          : const Color(0xFF075E54),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Info Message
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF128C7E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFF128C7E).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: const Color(0xFF128C7E),
                    size: 20.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'You will be notified once the astrologer accepts your request.',
                      style: GoogleFonts.openSans(
                        fontSize: 12.sp,
                        color:
                            isDark
                                ? const Color(0xFF128C7E)
                                : const Color(0xFF075E54),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 24.h),

            // OK Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                  if (onOkayPressed != null) {
                    onOkayPressed!();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF128C7E), Color(0xFF075E54)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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

  IconData _getRequestIcon(String type) {
    switch (type.toLowerCase()) {
      case 'chat':
        return Icons.chat_bubble_rounded;
      case 'call':
        return Icons.call_rounded;
      case 'video call':
        return Icons.videocam_rounded;
      default:
        return Icons.chat_bubble_rounded;
    }
  }
}

// Usage Example:
// showDialog(
//   context: context,
//   barrierDismissible: false,
//   builder: (context) => RequestSubmittedPopup(
//     astrologerName: "Dr. Sharma",
//     astrologerPhoto: "https://...",
//     requestType: "Chat",
//     waitingTime: "2-5 mins",
//     onOkayPressed: () {
//       // Navigate to home or specific screen
//       Get.offAllNamed('/home');
//       // OR perform any action
//       print('Request acknowledged');
//     },
//     onCancelPressed: () {
//       // Cancel the request
//       print('Request cancelled');
//     },
//   ),
// );
