// import 'dart:async';
// import 'package:astrology/app/core/utils/logger_utils.dart';
// import 'package:astrology/app/services/storage/local_storage_service.dart';
// import 'package:astrology/app/services/webshoket/web_shoket_services.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// // Message Model
// class Message {
//   final String id;
//   final String text;
//   final bool isSentByMe;
//   final DateTime timestamp;
//   final MessageStatus status;
//   final String? imageUrl;
//   final MessageType type;
//   final int? messageID;
//   final int? sessionID;
//   final int senderID;
//   final bool isRead;

//   Message({
//     required this.id,
//     required this.text,
//     required this.isSentByMe,
//     required this.timestamp,
//     required this.senderID,
//     this.status = MessageStatus.sent,
//     this.imageUrl,
//     this.type = MessageType.text,
//     this.messageID,
//     this.sessionID,
//     this.isRead = false,
//   });

//   factory Message.fromWebSocket(Map<String, dynamic> json, int currentUserID) {
//     return Message(
//       id:
//           json['messageID']?.toString() ??
//           DateTime.now().millisecondsSinceEpoch.toString(),
//       text: json['content'] ?? '',
//       isSentByMe: json['senderID'] == currentUserID,
//       timestamp: DateTime.parse(
//         json['sentAt'] ?? DateTime.now().toIso8601String(),
//       ),
//       senderID: json['senderID'] ?? 0,
//       status:
//           json['isRead'] == true ? MessageStatus.read : MessageStatus.delivered,
//       type: _getMessageType(json['messageType']),
//       messageID: json['messageID'],
//       sessionID: json['sessionID'],
//       isRead: json['isRead'] ?? false,
//       imageUrl: json['fileURL'],
//     );
//   }

//   // Convert Message to JSON for storage
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'text': text,
//       'isSentByMe': isSentByMe,
//       'timestamp': timestamp.toIso8601String(),
//       'status': status.index,
//       'imageUrl': imageUrl,
//       'type': type.index,
//       'messageID': messageID,
//       'sessionID': sessionID,
//       'senderID': senderID,
//       'isRead': isRead,
//     };
//   }

//   // Convert JSON to Message object
//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       id: json['id'] ?? '',
//       text: json['text'] ?? '',
//       isSentByMe: json['isSentByMe'] ?? false,
//       timestamp: DateTime.parse(
//         json['timestamp'] ?? DateTime.now().toIso8601String(),
//       ),
//       status: MessageStatus.values[json['status'] ?? 0],
//       imageUrl: json['imageUrl'],
//       type: MessageType.values[json['type'] ?? 0],
//       messageID: json['messageID'],
//       sessionID: json['sessionID'],
//       senderID: json['senderID'] ?? 0,
//       isRead: json['isRead'] ?? false,
//     );
//   }

//   static MessageType _getMessageType(String? type) {
//     switch (type?.toLowerCase()) {
//       case 'image':
//         return MessageType.image;
//       case 'voice':
//         return MessageType.voice;
//       default:
//         return MessageType.text;
//     }
//   }

//   // Copy method to update message properties
//   Message copyWith({
//     String? id,
//     String? text,
//     bool? isSentByMe,
//     DateTime? timestamp,
//     MessageStatus? status,
//     String? imageUrl,
//     MessageType? type,
//     int? messageID,
//     int? sessionID,
//     int? senderID,
//     bool? isRead,
//   }) {
//     return Message(
//       id: id ?? this.id,
//       text: text ?? this.text,
//       isSentByMe: isSentByMe ?? this.isSentByMe,
//       timestamp: timestamp ?? this.timestamp,
//       status: status ?? this.status,
//       imageUrl: imageUrl ?? this.imageUrl,
//       type: type ?? this.type,
//       messageID: messageID ?? this.messageID,
//       sessionID: sessionID ?? this.sessionID,
//       senderID: senderID ?? this.senderID,
//       isRead: isRead ?? this.isRead,
//     );
//   }
// }

// enum MessageStatus { sending, sent, delivered, read }

// enum MessageType { text, image, voice }

// // Chat Controller
// class ChatController extends GetxController with GetTickerProviderStateMixin {
//   final TextEditingController messageController = TextEditingController();
//   final ScrollController scrollController = ScrollController();
//   var showEmojiPicker = false.obs;
//   late AnimationController animationController;
//   late Animation<double> fadeAnimation;
//   StreamSubscription? _wsSubscription;

//   // WebSocket service
//   WebSocketService? webSocketService;

//   // Storage instance
//   final GetStorage storage = GetStorage();

//   final RxList<Message> messages = <Message>[].obs;
//   final RxBool isTyping = false.obs;
//   final RxString messageText = ''.obs;

//   // Chat info
//   final RxString chatTitle = 'Sarah Johnson'.obs;
//   final RxString lastSeen = 'Online'.obs;

//   // Current user ID
//   int? currentUserID;
//   int? sessionID;

//   Future<void> setData({int? sessionId}) async {
//     final userId_ = LocalStorageService.getUserId();
//     final userId = userId_;
//     currentUserID = int.parse(userId.toString());
//     sessionID = sessionId;
//     update();
//     debugPrint("currentUserID=$currentUserID sessionID $sessionID");
//     initializeWebSocket();
//   }

//   // Storage key for messages
//   String get messagesKey => 'chat_messages_session_$sessionID';

//   @override
//   void onInit() {
//     super.onInit();
//     animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(animationController);

//     messageController.addListener(() {
//       messageText.value = messageController.text;
//       isTyping.value = messageController.text.isNotEmpty;
//     });

//     // Load previous messages first
//     loadStoredMessages();

//     animationController.forward();
//   }

//   void toggleEmojiPicker() {
//     showEmojiPicker.value = !showEmojiPicker.value;
//   }

//   void hideEmojiPicker() {
//     showEmojiPicker.value = false;
//   }

//   void loadStoredMessages() {
//     try {
//       final storedMessages = storage.read<List>(messagesKey);
//       if (storedMessages != null && storedMessages.isNotEmpty) {
//         final messagesList =
//             storedMessages
//                 .map(
//                   (json) => Message.fromJson(Map<String, dynamic>.from(json)),
//                 )
//                 .toList();

//         messages.assignAll(messagesList);
//         LoggerUtils.debug("✅ Loaded ${messagesList.length} stored messages");

//         // Scroll to bottom after loading messages
//         Future.delayed(const Duration(milliseconds: 300), () {
//           scrollToBottom();
//         });
//       } else {
//         LoggerUtils.debug("ℹ️ No stored messages found");
//       }
//     } catch (e) {
//       LoggerUtils.debug("❌ Error loading stored messages: $e");
//     }
//   }

//   void saveMessagesToStorage() {
//     try {
//       final messagesJson = messages.map((message) => message.toJson()).toList();
//       storage.write(messagesKey, messagesJson);
//       LoggerUtils.debug("✅ Saved ${messages.length} messages to storage");
//     } catch (e) {
//       LoggerUtils.debug("❌ Error saving messages: $e");
//     }
//   }

//   void initializeWebSocket() {
//     // Check if WebSocketService is already initialized
//     if (Get.isRegistered<WebSocketService>()) {
//       webSocketService = Get.find<WebSocketService>();
//     } else {
//       webSocketService = Get.put(WebSocketService());
//     }

//     // Connect if not already connected
//     if (!(webSocketService?.isConnected.value == true)) {
//       webSocketService?.connect(sessionId: sessionID.toString());
//     }

//     // Cancel previous subscription before listening again
//     _wsSubscription?.cancel();

//     // Listen to incoming messages
//     _wsSubscription = webSocketService?.messageStream.listen((messageData) {
//       handleIncomingMessage(messageData);
//     });
//   }

//   void handleIncomingMessage(Map<String, dynamic> messageData) {
//     LoggerUtils.debug("📨 Received message: $messageData");

//     if (messageData['type'] == 'chat_message') {
//       final incomingMessage = Message.fromWebSocket(
//         messageData,
//         currentUserID ?? 0,
//       );

//       LoggerUtils.debug(
//         "📋 Processed message - SenderID: ${incomingMessage.senderID}, CurrentUserID: $currentUserID, Text: ${incomingMessage.text}",
//       );

//       // Check if this message is from current user (our own message coming back from server)
//       if (incomingMessage.senderID == currentUserID) {
//         LoggerUtils.debug("🔄 This is our own message coming back from server");

//         // ✅ Find local message by text content and remove it, then add server message
//         final localMessageIndex = messages.indexWhere(
//           (message) =>
//               message.isSentByMe &&
//               message.text == incomingMessage.text &&
//               message.senderID == currentUserID &&
//               message.messageID == null, // Local messages don't have messageID
//         );

//         if (localMessageIndex != -1) {
//           // ✅ Remove local message and add server message at same position
//           messages.removeAt(localMessageIndex);
//           messages.insert(localMessageIndex, incomingMessage);

//           LoggerUtils.debug("✅ Replaced local message with server message");
//           saveMessagesToStorage();
//         } else {
//           LoggerUtils.debug(
//             "⚠️ No matching local message found - adding as new message",
//           );

//           // If we can't find matching local message, add as new
//           final existingIndex = messages.indexWhere(
//             (m) => m.messageID == incomingMessage.messageID,
//           );

//           if (existingIndex == -1) {
//             messages.add(incomingMessage);
//             scrollToBottom();
//             saveMessagesToStorage();
//             LoggerUtils.debug("✅ Added own message as new");
//           }
//         }
//       } else {
//         // This is a message from another user
//         LoggerUtils.debug("👤 Message from another user");

//         // Check if message already exists to prevent duplicates
//         final existingIndex = messages.indexWhere(
//           (m) => m.messageID == incomingMessage.messageID,
//         );

//         if (existingIndex == -1) {
//           messages.add(incomingMessage);
//           scrollToBottom();
//           LoggerUtils.debug("✅ Added new message from other user");
//           saveMessagesToStorage();
//         } else {
//           LoggerUtils.debug(
//             "⚠️ Message from other user already exists, skipping",
//           );
//         }
//       }
//     }
//   }

//   void sendMessage() {
//     if (messageController.text.trim().isEmpty) return;

//     final messageText = messageController.text.trim();
//     final localId = DateTime.now().millisecondsSinceEpoch.toString();

//     // ✅ Create local message for immediate UI update (NO messageID)
//     final localMessage = Message(
//       id: localId,
//       text: messageText,
//       isSentByMe: true,
//       timestamp: DateTime.now(),
//       senderID: currentUserID ?? 0,
//       status: MessageStatus.sending,
//       messageID: null, // ✅ Local message has no messageID
//     );

//     // ✅ Add local message immediately to show on screen
//     messages.add(localMessage);
//     messageController.clear();
//     this.messageText.value = '';
//     isTyping.value = false;
//     scrollToBottom();

//     // Save messages to storage immediately
//     saveMessagesToStorage();

//     LoggerUtils.debug(
//       "✅ Added local message with status: sending - ID: $localId",
//     );

//     // Send via WebSocket
//     final messageData = {
//       "SenderID": currentUserID,
//       "MessageType": "Text",
//       "Content": messageText,
//       "FileURL": null,
//     };

//     webSocketService?.sendMessage(messageData);

//     // Update local message status to sent after sending
//     Future.delayed(const Duration(milliseconds: 500), () {
//       final index = messages.indexWhere((m) => m.id == localId);
//       if (index != -1 && messages[index].status == MessageStatus.sending) {
//         messages[index] = messages[index].copyWith(status: MessageStatus.sent);
//         LoggerUtils.debug("✅ Updated local message status to: sent");
//         saveMessagesToStorage();
//       }
//     });
//   }

//   void clearChatHistory() {
//     messages.clear();
//     storage.remove(messagesKey);
//     LoggerUtils.debug("✅ Chat history cleared");
//   }

// void scrollToBottom() {
//   Future.delayed(const Duration(milliseconds: 100), () {
//     if (scrollController.hasClients && Get.isRegistered<ChatController>()) {
//       scrollController.animateTo(
//         scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   });
// }

//   @override
//   void onClose() {
//     saveMessagesToStorage();

//     // Cancel subscription
//     _wsSubscription?.cancel();
//     _wsSubscription = null;

//     // Dispose controllers
//     messageController.dispose();
//     if (scrollController.hasClients) {
//       scrollController.dispose();
//     }
//     animationController.dispose();

//     super.onClose();
//   }
// }

import 'dart:async';
import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:astrology/app/services/webshoket/web_shoket_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Message Model
class Message {
  final String id;
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;
  final MessageStatus status;
  final String? imageUrl;
  final MessageType type;
  final int? messageID;
  final int? sessionID;
  final int senderID;
  final bool isRead;

  Message({
    required this.id,
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
    required this.senderID,
    this.status = MessageStatus.sent,
    this.imageUrl,
    this.type = MessageType.text,
    this.messageID,
    this.sessionID,
    this.isRead = false,
  });

  factory Message.fromWebSocket(Map<String, dynamic> json, int currentUserID) {
    return Message(
      id:
          json['messageID']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['content'] ?? '',
      isSentByMe: json['senderID'] == currentUserID,
      timestamp: DateTime.parse(
        json['sentAt'] ?? DateTime.now().toIso8601String(),
      ),
      senderID: json['senderID'] ?? 0,
      status:
          json['isRead'] == true ? MessageStatus.read : MessageStatus.delivered,
      type: _getMessageType(json['messageType']),
      messageID: json['messageID'],
      sessionID: json['sessionID'],
      isRead: json['isRead'] ?? false,
      imageUrl: json['fileURL'],
    );
  }

  // Convert Message to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isSentByMe': isSentByMe,
      'timestamp': timestamp.toIso8601String(),
      'status': status.index,
      'imageUrl': imageUrl,
      'type': type.index,
      'messageID': messageID,
      'sessionID': sessionID,
      'senderID': senderID,
      'isRead': isRead,
    };
  }

  // Convert JSON to Message object
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      isSentByMe: json['isSentByMe'] ?? false,
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      status: MessageStatus.values[json['status'] ?? 0],
      imageUrl: json['imageUrl'],
      type: MessageType.values[json['type'] ?? 0],
      messageID: json['messageID'],
      sessionID: json['sessionID'],
      senderID: json['senderID'] ?? 0,
      isRead: json['isRead'] ?? false,
    );
  }

  static MessageType _getMessageType(String? type) {
    switch (type?.toLowerCase()) {
      case 'image':
        return MessageType.image;
      case 'voice':
        return MessageType.voice;
      default:
        return MessageType.text;
    }
  }

  // Copy method to update message properties
  Message copyWith({
    String? id,
    String? text,
    bool? isSentByMe,
    DateTime? timestamp,
    MessageStatus? status,
    String? imageUrl,
    MessageType? type,
    int? messageID,
    int? sessionID,
    int? senderID,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      isSentByMe: isSentByMe ?? this.isSentByMe,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      messageID: messageID ?? this.messageID,
      sessionID: sessionID ?? this.sessionID,
      senderID: senderID ?? this.senderID,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum MessageStatus { sending, sent, delivered, read }

enum MessageType { text, image, voice }

// Chat Controller
class ChatController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  var showEmojiPicker = false.obs;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  StreamSubscription? _wsSubscription;

  // WebSocket service
  WebSocketService? webSocketService;

  // Storage instance
  final GetStorage storage = GetStorage();

  final RxList<Message> messages = <Message>[].obs;
  final RxBool isTyping = false.obs;
  final RxString messageText = ''.obs;

  // Chat info
  // final RxString chatTitle = 'Sarah Johnson'.obs;
  final RxString lastSeen = 'Online'.obs;

  // Current user ID
  int? currentUserID;
  int? sessionID;

  Future<void> setData({int? sessionId}) async {
    final userId_ = LocalStorageService.getUserId();
    final userId = userId_;
    currentUserID = int.parse(userId.toString());
    sessionID = sessionId;
    update();
    debugPrint("currentUserID=$currentUserID sessionID $sessionID");
    initializeWebSocket();
  }

  // Storage key for messages
  String get messagesKey => 'chat_messages_session_$sessionID';

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);

    messageController.addListener(() {
      messageText.value = messageController.text;
      isTyping.value = messageController.text.isNotEmpty;
    });

    animationController.forward();
  }

  void toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
  }

  void hideEmojiPicker() {
    showEmojiPicker.value = false;
  }

  void initializeWebSocket() {
    messages.clear();
    scrollToBottom();
    // Check if WebSocketService is already initialized
    if (Get.isRegistered<WebSocketService>()) {
      webSocketService = Get.find<WebSocketService>();
    } else {
      webSocketService = Get.put(WebSocketService());
    }

    // Connect if not already connected
    if (!(webSocketService?.isConnected.value == true)) {
      webSocketService?.connect(sessionId: sessionID.toString());
    }

    // Cancel previous subscription before listening again
    _wsSubscription?.cancel();

    // Listen to incoming messages
    _wsSubscription = webSocketService?.messageStream.listen((messageData) {
      handleIncomingMessage(messageData);
    });
  }

  void handleIncomingMessage(Map<String, dynamic> messageData) {
    LoggerUtils.debug("📨 Received message: $messageData");

    if (messageData['type'] == 'chat_message') {
      final incomingMessage = Message.fromWebSocket(
        messageData,
        currentUserID ?? 0,
      );

      LoggerUtils.debug(
        "📋 Processed message - SenderID: ${incomingMessage.senderID}, CurrentUserID: $currentUserID, Text: ${incomingMessage.text}",
      );

      // Check if this message is from current user (our own message coming back from server)
      if (incomingMessage.senderID == currentUserID) {
        LoggerUtils.debug("🔄 This is our own message coming back from server");

        // ✅ Find local message by text content and remove it, then add server message
        final localMessageIndex = messages.indexWhere(
          (message) =>
              message.isSentByMe &&
              message.text == incomingMessage.text &&
              message.senderID == currentUserID &&
              message.messageID == null, // Local messages don't have messageID
        );

        if (localMessageIndex != -1) {
          // ✅ Remove local message and add server message at same position
          messages.removeAt(localMessageIndex);
          messages.insert(localMessageIndex, incomingMessage);

          LoggerUtils.debug("✅ Replaced local message with server message");
        } else {
          LoggerUtils.debug(
            "⚠️ No matching local message found - adding as new message",
          );

          // If we can't find matching local message, add as new
          final existingIndex = messages.indexWhere(
            (m) => m.messageID == incomingMessage.messageID,
          );

          if (existingIndex == -1) {
            messages.add(incomingMessage);
            scrollToBottom();

            LoggerUtils.debug("✅ Added own message as new");
          }
        }
      } else {
        // This is a message from another user
        LoggerUtils.debug("👤 Message from another user");

        // Check if message already exists to prevent duplicates
        final existingIndex = messages.indexWhere(
          (m) => m.messageID == incomingMessage.messageID,
        );

        if (existingIndex == -1) {
          messages.add(incomingMessage);
          scrollToBottom();
          LoggerUtils.debug("✅ Added new message from other user");
        } else {
          LoggerUtils.debug(
            "⚠️ Message from other user already exists, skipping",
          );
        }
      }
    }
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final messageText = messageController.text.trim();
    final localId = DateTime.now().millisecondsSinceEpoch.toString();

    // ✅ Create local message for immediate UI update (NO messageID)
    final localMessage = Message(
      id: localId,
      text: messageText,
      isSentByMe: true,
      timestamp: DateTime.now(),
      senderID: currentUserID ?? 0,
      status: MessageStatus.sending,
      messageID: null, // ✅ Local message has no messageID
    );

    // ✅ Add local message immediately to show on screen
    messages.add(localMessage);
    messageController.clear();
    this.messageText.value = '';
    isTyping.value = false;
    scrollToBottom();

    LoggerUtils.debug(
      "✅ Added local message with status: sending - ID: $localId",
    );

    // Send via WebSocket
    final messageData = {
      "SenderID": currentUserID,
      "MessageType": "Text",
      "Content": messageText,
      "FileURL": null,
    };

    webSocketService?.sendMessage(messageData);

    // Update local message status to sent after sending
    Future.delayed(const Duration(milliseconds: 500), () {
      final index = messages.indexWhere((m) => m.id == localId);
      if (index != -1 && messages[index].status == MessageStatus.sending) {
        messages[index] = messages[index].copyWith(status: MessageStatus.sent);
        LoggerUtils.debug("✅ Updated local message status to: sent");
      }
    });
  }

  void clearChatHistory() {
    messages.clear();
    storage.remove(messagesKey);
    LoggerUtils.debug("✅ Chat history cleared");
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void onClose() {
    // Cancel subscription
    _wsSubscription?.cancel();
    _wsSubscription = null;

    // Dispose controllers
    messageController.dispose();
    scrollController.dispose();
    animationController.dispose();

    super.onClose();
  }
}
