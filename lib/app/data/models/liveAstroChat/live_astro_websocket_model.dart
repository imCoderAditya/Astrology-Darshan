// To parse this JSON data, do
//
//     final liveAstrolorWebSoketModel = liveAstrolorWebSoketModelFromJson(jsonString);

import 'dart:convert';

LiveAstrolorWebSoketModel liveAstrolorWebSoketModelFromJson(String str) => LiveAstrolorWebSoketModel.fromJson(json.decode(str));

String liveAstrolorWebSoketModelToJson(LiveAstrolorWebSoketModel data) => json.encode(data.toJson());

class LiveAstrolorWebSoketModel {
    final String? type;
    final int? messageId;
    final int? sessionId;
    final int? senderId;
    final String? senderName;
    final String? profilePicture;
    final String? messageType;
    final String? content;
    final dynamic fileUrl;
    final bool? isRead;
    final DateTime? sentAt;
    final String? source;

    LiveAstrolorWebSoketModel({
        this.type,
        this.messageId,
        this.sessionId,
        this.senderId,
        this.senderName,
        this.profilePicture,
        this.messageType,
        this.content,
        this.fileUrl,
        this.isRead,
        this.sentAt,
        this.source,
    });

    LiveAstrolorWebSoketModel copyWith({
        String? type,
        int? messageId,
        int? sessionId,
        int? senderId,
        String? senderName,
        String? profilePicture,
        String? messageType,
        String? content,
        dynamic fileUrl,
        bool? isRead,
        DateTime? sentAt,
        String? source,
    }) => 
        LiveAstrolorWebSoketModel(
            type: type ?? this.type,
            messageId: messageId ?? this.messageId,
            sessionId: sessionId ?? this.sessionId,
            senderId: senderId ?? this.senderId,
            senderName: senderName ?? this.senderName,
            profilePicture: profilePicture ?? this.profilePicture,
            messageType: messageType ?? this.messageType,
            content: content ?? this.content,
            fileUrl: fileUrl ?? this.fileUrl,
            isRead: isRead ?? this.isRead,
            sentAt: sentAt ?? this.sentAt,
            source: source ?? this.source,
        );

    factory LiveAstrolorWebSoketModel.fromJson(Map<String, dynamic> json) => LiveAstrolorWebSoketModel(
        type: json["type"],
        messageId: json["messageID"],
        sessionId: json["sessionID"],
        senderId: json["senderID"],
        senderName: json["senderName"],
        profilePicture: json["profilePicture"],
        messageType: json["messageType"],
        content: json["content"],
        fileUrl: json["fileURL"],
        isRead: json["isRead"],
        sentAt: json["sentAt"] == null ? null : DateTime.parse(json["sentAt"]),
        source: json["source"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "messageID": messageId,
        "sessionID": sessionId,
        "senderID": senderId,
        "senderName": senderName,
        "profilePicture": profilePicture,
        "messageType": messageType,
        "content": content,
        "fileURL": fileUrl,
        "isRead": isRead,
        "sentAt": sentAt?.toIso8601String(),
        "source": source,
    };
}