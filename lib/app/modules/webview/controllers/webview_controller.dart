import 'package:get/get.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewController extends GetxController {
  var hasConnection = true.obs;
  var progress = 0.0.obs;
  var webNotLoadError = ''.obs;
  var currentUrl = ''.obs;

  void updateConnectionStatus(bool status) => hasConnection.value = status;
  void updateProgress(double value) => progress.value = value;
  void updateUrl(String url) => currentUrl.value = url;
  void updateLoadError(String message) => webNotLoadError.value = message;
}


class NoInternetWidget extends StatelessWidget {
  final String url;
  final InAppWebViewController? controller;

  const NoInternetWidget({
    super.key,
    required this.url,
    required this.controller,
  });

  Future<void> _retryLoadUrl(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      controller?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Still no internet connection")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withValues(alpha: 0.2),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glowing WiFi Icon
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffF44336), Color(0xffFF9800)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.4),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  "You're Offline!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Message
                const Text(
                  "No internet connection.\nPlease check your connection and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 28),

                // Retry Button
                ElevatedButton.icon(
                  onPressed: () => _retryLoadUrl(context),
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  label: const Text("Retry", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 14,
                    ),
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}