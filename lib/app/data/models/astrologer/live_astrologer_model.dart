// To parse this JSON data, do
//
//     final liveAstrologerModel = liveAstrologerModelFromJson(jsonString);

import 'dart:convert';

LiveAstrologerModel liveAstrologerModelFromJson(String str) =>
    LiveAstrologerModel.fromJson(json.decode(str));

String liveAstrologerModelToJson(LiveAstrologerModel data) =>
    json.encode(data.toJson());

class LiveAstrologerModel {
  final bool? success;
  final String? message;
  final List<LiveAstrologer>? liveAstrologer;

  LiveAstrologerModel({this.success, this.message, this.liveAstrologer});

  LiveAstrologerModel copyWith({
    bool? success,
    String? message,
    List<LiveAstrologer>? liveAstrologer,
  }) => LiveAstrologerModel(
    success: success ?? this.success,
    message: message ?? this.message,
    liveAstrologer: liveAstrologer ?? this.liveAstrologer,
  );

  factory LiveAstrologerModel.fromJson(Map<String, dynamic> json) =>
      LiveAstrologerModel(
        success: json["success"],
        message: json["message"],
        liveAstrologer:
            json["data"] == null
                ? []
                : List<LiveAstrologer>.from(
                  json["data"]!.map((x) => LiveAstrologer.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data":
        liveAstrologer == null
            ? []
            : List<dynamic>.from(liveAstrologer!.map((x) => x.toJson())),
  };
}

class LiveAstrologer {
  final int? liveSessionId;
  final String? streamKey;
  final String? streamUrl;
  final String? thumbnail;
  final String? title;
  final String? description;
  final DateTime? startedAt;
  final int? astrologerId;
  final String? displayName;
  final String? bio;
  final double? rating;
  final int? experience;
  final double? consultationRate;
  final String? specializations;
  final String? languages;
  final bool? isOnline;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;

  LiveAstrologer({
    this.liveSessionId,
    this.streamKey,
    this.streamUrl,
    this.thumbnail,
    this.title,
    this.description,
    this.startedAt,
    this.astrologerId,
    this.displayName,
    this.bio,
    this.rating,
    this.experience,
    this.consultationRate,
    this.specializations,
    this.languages,
    this.isOnline,
    this.userId,
    this.firstName,
    this.lastName,
    this.profilePicture,
  });

  LiveAstrologer copyWith({
    int? liveSessionId,
    String? streamKey,
    String? streamUrl,
    String? thumbnail,
    String? title,
    String? description,
    DateTime? startedAt,
    int? astrologerId,
    String? displayName,
    String? bio,
    double? rating,
    int? experience,
    double? consultationRate,
    String? specializations,
    String? languages,
    bool? isOnline,
    int? userId,
    String? firstName,
    String? lastName,
    String? profilePicture,
  }) => LiveAstrologer(
    liveSessionId: liveSessionId ?? this.liveSessionId,
    streamKey: streamKey ?? this.streamKey,
    streamUrl: streamUrl ?? this.streamUrl,
    thumbnail: thumbnail ?? this.thumbnail,
    title: title ?? this.title,
    description: description ?? this.description,
    startedAt: startedAt ?? this.startedAt,
    astrologerId: astrologerId ?? this.astrologerId,
    displayName: displayName ?? this.displayName,
    bio: bio ?? this.bio,
    rating: rating ?? this.rating,
    experience: experience ?? this.experience,
    consultationRate: consultationRate ?? this.consultationRate,
    specializations: specializations ?? this.specializations,
    languages: languages ?? this.languages,
    isOnline: isOnline ?? this.isOnline,
    userId: userId ?? this.userId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    profilePicture: profilePicture ?? this.profilePicture,
  );

  factory LiveAstrologer.fromJson(Map<String, dynamic> json) => LiveAstrologer(
    liveSessionId: json["liveSessionId"],
    streamKey: json["streamKey"],
    streamUrl: json["streamUrl"],
    thumbnail: json["thumbnail"],
    title: json["title"],
    description: json["description"],
    startedAt:
        json["startedAt"] == null ? null : DateTime.parse(json["startedAt"]),
    astrologerId: json["astrologerId"],
    displayName: json["displayName"],
    bio: json["bio"],
    rating: json["rating"]?.toDouble(),
    experience: json["experience"],
    consultationRate: json["consultationRate"]?.toDouble(),
    specializations: json["specializations"],
    languages: json["languages"],
    isOnline: json["isOnline"],
    userId: json["userId"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    profilePicture: json["profilePicture"],
  );

  Map<String, dynamic> toJson() => {
    "liveSessionId": liveSessionId,
    "streamKey": streamKey,
    "streamUrl": streamUrl,
    "thumbnail": thumbnail,
    "title": title,
    "description": description,
    "startedAt": startedAt?.toIso8601String(),
    "astrologerId": astrologerId,
    "displayName": displayName,
    "bio": bio,
    "rating": rating,
    "experience": experience,
    "consultationRate": consultationRate,
    "specializations": specializations,
    "languages": languages,
    "isOnline": isOnline,
    "userId": userId,
    "firstName": firstName,
    "lastName": lastName,
    "profilePicture": profilePicture,
  };
}
