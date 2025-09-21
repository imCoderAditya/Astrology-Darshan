import 'dart:io';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class FirebaseServices {
  static Future<String?> firebaseToken() async {
    try {
      // Request notification permission (Provisional for iOS)
      final notificationSettings = await FirebaseMessaging.instance
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      if (notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        // Log the notification permission status
        LoggerUtils.debug(
          "Notification permission status: ${notificationSettings.authorizationStatus}",
        );

        // Optional: Log APNs token (iOS only)

        if (Platform.isIOS) {
          final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          LoggerUtils.debug("APNs token: $apnsToken");
          // You might want to handle cases where apnsToken is null
        }

        // Get FCM token (for all platforms)
        final fcmToken = await FirebaseMessaging.instance.getToken();
        LoggerUtils.debug("FCM token: $fcmToken");
        return fcmToken;
      } else {
        LoggerUtils.debug('User declined notification permissions');
        await openAppSettings();
        return null;
      }
      // You can now send this FCM token to your backend if needed
    } catch (e) {
      LoggerUtils.error("Error:$e");
      return null;
    }
  }
}