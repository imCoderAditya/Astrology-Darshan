import 'dart:io';

import 'package:astrology/components/global_loader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String securityKey =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_+[]{}|;:,.<>?";

const String APPID = "25747e4b1b9c43d8a8b7cde83abddf45";
const String APPCERTIFICATE = "3bac8b59eec041909daf6ef145021e45";
 final String googleApiKey = "AIzaSyD4AOt8-0N68htBXkrGHgl8lg_goG9wpdk";
TextInputFormatter upperCaseFormatter() {
  return TextInputFormatter.withFunction((oldValue, newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  });
}

Future<void> downloadFile(String file) async {
  final flutterMediaDownloaderPlugin = MediaDownload();

  try {
    // ✅ Android Storage Permission Handling
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      PermissionStatus status;

      if (sdkInt >= 33) {
        status = await Permission.photos.request(); // Android 13+
      } else if (sdkInt >= 30) {
        status =
            await Permission.manageExternalStorage.request(); // Android 11–12
      } else {
        status = await Permission.storage.request(); // Android 10 and below
      }

      if (!status.isGranted) {
        Get.snackbar(
          'Permission Denied',
          'Storage permission is required to download the prescription.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      GlobalLoader.show();

      if (file.isEmpty) throw Exception('Invalid image URL');

      // ✅ Download using your plugin
      await flutterMediaDownloaderPlugin.downloadMedia(Get.context!, file);

      // ✅ Dismiss loader
      if (Get.isDialogOpen ?? false) Get.back();
      GlobalLoader.hide();
      // ✅ Success SnackBar
      Get.snackbar(
        'Download Complete',
        'Prescription saved successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      // ✅ Download using your plugin
      await flutterMediaDownloaderPlugin.downloadMedia(Get.context!, file);
    }
  } catch (e) {
    if (Get.isDialogOpen ?? false) Get.back();

    Get.snackbar(
      'Download Failed',
      'Could not download prescription. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );

    debugPrint('❌ Error downloading: $e');
  }


}

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    final formatted = text[0].toUpperCase() + text.substring(1).toLowerCase();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}