/// Network utility functions for the RoinTech project
library;

import 'dart:io';

class NetworkUtils {
  /// Check if the device has an active internet connection
  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  /// Get a user-friendly error message for network errors
  static String getNetworkErrorMessage(dynamic error) {
    if (error is SocketException) {
      return "No internet connection. Please check your network.";
    }
    return "Something went wrong. Please try again.";
  }
}