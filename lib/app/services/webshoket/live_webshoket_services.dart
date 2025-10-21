// WebSocket Service
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:web_socket_channel/io.dart';

class LiveWebshoketServices extends GetxService {
  IOWebSocketChannel? _channel;
  final RxBool isConnected = false.obs;
  final RxString connectionStatus = 'Disconnected'.obs;
  String? sessionId;

  void setSessionId(String? sessionId_) {
    sessionId = sessionId_;
  }

  // Stream controller for incoming messages
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  Future<void> connect({String? sessionId}) async {
    try {
      HttpOverrides.global = MyHttpOverrides();

      final wsUrl = Uri.parse(
        'wss://astrologylivechat.veteransoftwares.com/ws/chat/$sessionId',
      );
      debugPrint("Session:===> $sessionId");

      _channel = IOWebSocketChannel.connect(
        wsUrl,
        pingInterval: const Duration(seconds: 5),
      );

      connectionStatus.value = 'Connecting...';

      _channel!.stream.listen(
        (message) {
          log("WebSocket Received: $message");
          connectionStatus.value = 'Connected';
          isConnected.value = true;

          try {
            final Map<String, dynamic> messageData = json.decode(message);
            _messageController.add(messageData);
          } catch (e) {
            log("Error parsing message: $e");
          }
        },
        onError: (error) {
          log("WebSocket Error: $error");
          connectionStatus.value = 'Error: $error';
          isConnected.value = false;
        },
        onDone: () {
          log("WebSocket Closed");
          connectionStatus.value = 'Disconnected';
          isConnected.value = false;
        },
      );
    } catch (e) {
      log("Connection Error: $e");
      connectionStatus.value = 'Connection Failed';
      isConnected.value = false;
    }
  }

  void sendMessage(Map<String, dynamic> messageData) {
    if (_channel != null && isConnected.value) {
      final jsonMessage = json.encode(messageData);
      _channel!.sink.add(jsonMessage);
      log("WebSocket Sent: $jsonMessage");
    } else {
      log("WebSocket not connected");
    }
  }

  void disconnect() {
    _channel?.sink.close(1000, "Closed normally");
    // _messageController.close();
    isConnected.value = false;
    connectionStatus.value = 'Disconnected';
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}

// HttpOverrides to ignore bad SSL certificates (ONLY for testing/dev)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
