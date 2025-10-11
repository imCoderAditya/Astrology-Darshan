import 'dart:convert';
import 'dart:io';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseServices {
  // Initialize the plugin (only once, e.g., in main.dart)
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Call this function in main() after initializing Firebase
  Future<void> setupFirebaseForegroundListener() async {
    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings (optional)
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    // Initialization settings for all platforms
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('📩 Foreground message received!');
      log('🔹 Data: ${json.encode(message.data)}');

      if (message.notification != null) {
        final notification = message.notification!;
        log('🔔 Notification: ${notification.title} - ${notification.body}');

        // Show local notification
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode, // unique id
          notification.title, // title
          notification.body, // body
          NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel', // channel id
              'General Notifications', // channel name
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(), // optional iOS settings
          ),
        );
      }
    });
  }

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

// import 'dart:io';

// import 'package:astrology/app/core/utils/logger_utils.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:permission_handler/permission_handler.dart';

// class FirebaseServices {
//   static Future<String?> firebaseToken() async {
//     try {
//       // Request notification permission (Provisional for iOS)
//       final notificationSettings = await FirebaseMessaging.instance
//           .requestPermission(
//             alert: true,
//             announcement: false,
//             badge: true,
//             carPlay: false,
//             criticalAlert: false,
//             provisional: false,
//             sound: true,
//           );

//       if (notificationSettings.authorizationStatus ==
//           AuthorizationStatus.authorized) {
//         // Log the notification permission status
//         LoggerUtils.debug(
//           "Notification permission status: ${notificationSettings.authorizationStatus}",
//         );

//         // Optional: Log APNs token (iOS only)

//         if (Platform.isIOS) {
//           final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//           LoggerUtils.debug("APNs token: $apnsToken");
//           // You might want to handle cases where apnsToken is null
//         }

//         // Get FCM token (for all platforms)
//         final fcmToken = await FirebaseMessaging.instance.getToken();
//         LoggerUtils.debug("FCM token: $fcmToken");
//         return fcmToken;
//       } else {
//         LoggerUtils.debug('User declined notification permissions');
//         await openAppSettings();
//         return null;
//       }
//       // You can now send this FCM token to your backend if needed
//     } catch (e) {
//       LoggerUtils.error("Error:$e");
//       return null;
//     }
//   }
// }
