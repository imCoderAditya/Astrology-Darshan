// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Shares plain text using the share_plus package.
Future<void> shareText(String text) async {
  await SharePlus.instance.share(ShareParams(text: text));
}

/// Shares a file (image or other) with optional text using the share_plus package.
/// [filePath] should be a valid local file path.
Future<void> shareFile(String filePath, {String? text}) async {
  final params = ShareParams(text: text, files: [XFile(filePath)]);
  await SharePlus.instance.share(params);
}

/// Downloads a network image and shares it with optional text.
/// [context] is used for error feedback.
/// [imageUrl] is the URL of the image to download and share.
/// [details] is the text to share along with the image.
Future<void> shareNetworkImageWithText(String imageUrl, String details) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/product_image.jpg');
    await file.writeAsBytes(response.bodyBytes);

    await shareFile(file.path, text: details);
  } catch (e) {
    ScaffoldMessenger.of(
      Get.context!,
    ).showSnackBar(SnackBar(content: Text('Failed to share product: $e')));
  }
}
