// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    final bool? status;
    final String? message;
    final int? unreadCount;
    final int? totalCount;
    final List<Datum>? data;

    NotificationModel({
        this.status,
        this.message,
        this.unreadCount,
        this.totalCount,
        this.data,
    });

    NotificationModel copyWith({
        bool? status,
        String? message,
        int? unreadCount,
        int? totalCount,
        List<Datum>? data,
    }) => 
        NotificationModel(
            status: status ?? this.status,
            message: message ?? this.message,
            unreadCount: unreadCount ?? this.unreadCount,
            totalCount: totalCount ?? this.totalCount,
            data: data ?? this.data,
        );

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        status: json["status"],
        message: json["message"],
        unreadCount: json["unreadCount"],
        totalCount: json["totalCount"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "unreadCount": unreadCount,
        "totalCount": totalCount,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final int? notificationId;
    final int? userId;
    final String? title;
    final String? message;
    final Type? type;
    final bool? isRead;
    final bool? isNew;
    final String? actionUrl;
    final DateTime? createdAt;

    Datum({
        this.notificationId,
        this.userId,
        this.title,
        this.message,
        this.type,
        this.isRead,
        this.isNew,
        this.actionUrl,
        this.createdAt,
    });

    Datum copyWith({
        int? notificationId,
        int? userId,
        String? title,
        String? message,
        Type? type,
        bool? isRead,
        bool? isNew,
        String? actionUrl,
        DateTime? createdAt,
    }) => 
        Datum(
            notificationId: notificationId ?? this.notificationId,
            userId: userId ?? this.userId,
            title: title ?? this.title,
            message: message ?? this.message,
            type: type ?? this.type,
            isRead: isRead ?? this.isRead,
            isNew: isNew ?? this.isNew,
            actionUrl: actionUrl ?? this.actionUrl,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        notificationId: json["notificationId"],
        userId: json["userId"],
        title: json["title"],
        message: json["message"],
        type: typeValues.map[json["type"]]!,
        isRead: json["isRead"],
        isNew: json["isNew"],
        actionUrl: json["actionUrl"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "userId": userId,
        "title": title,
        "message": message,
        "type": typeValues.reverse[type],
        "isRead": isRead,
        "isNew": isNew,
        "actionUrl": actionUrl,
        "createdAt": createdAt?.toIso8601String(),
    };
}

enum Type {
    CONSULTATION
}

final typeValues = EnumValues({
    "Consultation": Type.CONSULTATION
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
