import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeDeviceInfo {
  static const platform = MethodChannel('com.rointech.rointech');

  static Future<String?> getDeviceId() async {
    try {
      final String? deviceId = await platform.invokeMethod('getDeviceId');
      debugPrint("Devices=====>$deviceId");
      return deviceId;
    } catch (e) {
      debugPrint("Failed to get device ID: $e");
      return null;
    }
  }
}