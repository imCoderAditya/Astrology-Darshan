// To parse this JSON data, do
//
//     final astrologerModel = astrologerModelFromJson(jsonString);

import 'dart:convert';

AstrologerModel astrologerModelFromJson(String str) =>
    AstrologerModel.fromJson(json.decode(str));

String astrologerModelToJson(AstrologerModel data) =>
    json.encode(data.toJson());

class AstrologerModel {
  final bool? success;
  final Data? data;

  AstrologerModel({this.success, this.data});

  AstrologerModel copyWith({bool? success, Data? data}) => AstrologerModel(
    success: success ?? this.success,
    data: data ?? this.data,
  );

  factory AstrologerModel.fromJson(Map<String, dynamic> json) =>
      AstrologerModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"success": success, "data": data?.toJson()};
}

class Data {
  final List<Astrologer>? astrologers;
  final Pagination? pagination;

  Data({this.astrologers, this.pagination});

  Data copyWith({List<Astrologer>? astrologers, Pagination? pagination}) =>
      Data(
        astrologers: astrologers ?? this.astrologers,
        pagination: pagination ?? this.pagination,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    astrologers:
        json["astrologers"] == null
            ? []
            : List<Astrologer>.from(
              json["astrologers"]!.map((x) => Astrologer.fromJson(x)),
            ),
    pagination:
        json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "astrologers":
        astrologers == null
            ? []
            : List<dynamic>.from(astrologers!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Astrologer {
  final int? astrologerId;
  final int? userId;
  final String? displayName;
  final String? profilePicture;
  final String? bio;
  final int? experience;
  final List<String>? specializations;
  final List<String>? languages;
  final String? education;
  final String? certifications;
  final double? consultationRate;
  final double? chatMrpPerMinute;
  final double? callMrpPerMinute;
  final double? callDpPerMinute;
  final double? rating;
  final int? totalRatings;
  final int? totalConsultations;
  final String? consultationType;
  final bool? isApproved;
  final bool? isOnline;
  final bool? isAvailableForCall;
  final bool? isAvailableForChat;
  final bool? isBoosted;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? dateOfBirth;
  final String? timeOfBirth;
  final String? placeOfBirth;

  Astrologer({
    this.astrologerId,
    this.userId,
    this.displayName,
    this.profilePicture,
    this.bio,
    this.experience,
    this.specializations,
    this.languages,
    this.education,
    this.certifications,
    this.consultationRate,
    this.chatMrpPerMinute,
    this.callMrpPerMinute,
    this.callDpPerMinute,
    this.rating,
    this.totalRatings,
    this.totalConsultations,
    this.consultationType,
    this.isApproved,
    this.isOnline,
    this.isAvailableForCall,
    this.isAvailableForChat,
    this.isBoosted,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.timeOfBirth,
    this.placeOfBirth,
  });

  Astrologer copyWith({
    int? astrologerId,
    int? userId,
    String? displayName,
    String? profilePicture,
    String? bio,
    int? experience,
    List<String>? specializations,
    List<String>? languages,
    String? education,
    String? certifications,
    double? consultationRate,
    double? chatMrpPerMinute,
    double? callMrpPerMinute,
    double? callDpPerMinute,
    double? rating,
    int? totalRatings,
    int? totalConsultations,
    String? consultationType,
    bool? isApproved,
    bool? isOnline,
    bool? isAvailableForCall,
    bool? isAvailableForChat,
    bool? isBoosted,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? dateOfBirth,
    String? timeOfBirth,
    String? placeOfBirth,
  }) => Astrologer(
    astrologerId: astrologerId ?? this.astrologerId,
    userId: userId ?? this.userId,
    displayName: displayName ?? this.displayName,
    profilePicture: profilePicture ?? this.profilePicture,
    bio: bio ?? this.bio,
    experience: experience ?? this.experience,
    specializations: specializations ?? this.specializations,
    languages: languages ?? this.languages,
    education: education ?? this.education,
    certifications: certifications ?? this.certifications,
    consultationRate: consultationRate ?? this.consultationRate,
    chatMrpPerMinute: chatMrpPerMinute ?? this.chatMrpPerMinute,
    callMrpPerMinute: callMrpPerMinute ?? this.callMrpPerMinute,
    callDpPerMinute: callDpPerMinute ?? this.callDpPerMinute,
    rating: rating ?? this.rating,
    totalRatings: totalRatings ?? this.totalRatings,
    totalConsultations: totalConsultations ?? this.totalConsultations,
    isApproved: isApproved ?? this.isApproved,
    isOnline: isOnline ?? this.isOnline,
    isAvailableForCall: isAvailableForCall ?? this.isAvailableForCall,
    isAvailableForChat: isAvailableForChat ?? this.isAvailableForChat,
    isBoosted: isBoosted ?? this.isBoosted,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    gender: gender ?? this.gender,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    timeOfBirth: timeOfBirth ?? this.timeOfBirth,
    placeOfBirth: placeOfBirth ?? this.placeOfBirth,
    consultationType: consultationType ?? this.consultationType,
  );

  factory Astrologer.fromJson(Map<String, dynamic> json) => Astrologer(
    astrologerId: json["astrologerId"],
    userId: json["userId"],
    displayName: json["displayName"],
    profilePicture: json["profilePicture"],
    bio: json["bio"],
    experience: json["experience"],
    consultationType: json["consultationType"],
    specializations:
        json["specializations"] == null
            ? []
            : List<String>.from(json["specializations"]!.map((x) => x)),
    languages:
        json["languages"] == null
            ? []
            : List<String>.from(json["languages"]!.map((x) => x)),
    education: json["education"],
    certifications: json["certifications"],
    consultationRate: json["consultationRate"]?.toDouble(),
    chatMrpPerMinute: json["chat_MRPPerMinute"]?.toDouble(),
    callMrpPerMinute: json["call_MrpPerMinute"]?.toDouble(),
    callDpPerMinute: json["call_DpPerMinute"]?.toDouble(),
    rating: json["rating"]?.toDouble(),
    totalRatings: json["totalRatings"],
    totalConsultations: json["totalConsultations"],
    isApproved: json["isApproved"],
    isOnline: json["IsOnline"],
    isAvailableForCall: json["IsAvailableForCall"],
    isAvailableForChat: json["IsAvailableForChat"],
    isBoosted: json["isBoosted"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    gender: json["gender"],
    dateOfBirth: json["dateOfBirth"],
    timeOfBirth: json["timeOfBirth"],
    placeOfBirth: json["placeOfBirth"],
  );

  Map<String, dynamic> toJson() => {
    "astrologerId": astrologerId,
    "userId": userId,
    "displayName": displayName,
    "profilePicture": profilePicture,
    "bio": bio,
    "experience": experience,
    "specializations":
        specializations == null
            ? []
            : List<dynamic>.from(specializations!.map((x) => x)),
    "languages":
        languages == null ? [] : List<dynamic>.from(languages!.map((x) => x)),
    "education": education,
    "certifications": certifications,
    "consultationRate": consultationRate,
    "chat_MRPPerMinute": chatMrpPerMinute,
    "call_MrpPerMinute": callMrpPerMinute,
    "call_DpPerMinute": callDpPerMinute,
    "rating": rating,
    "totalRatings": totalRatings,
    "totalConsultations": totalConsultations,
    "isApproved": isApproved,
    "IsOnline": isOnline,
    "IsAvailableForCall": isAvailableForCall,
    "IsAvailableForChat": isAvailableForChat,
    "isBoosted": isBoosted,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phoneNumber": phoneNumber,
    "gender": gender,
    "dateOfBirth": dateOfBirth,
    "timeOfBirth": timeOfBirth,
    "placeOfBirth": placeOfBirth,
  };
}

class Pagination {
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final int? itemsPerPage;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
  });

  Pagination copyWith({
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
  }) => Pagination(
    currentPage: currentPage ?? this.currentPage,
    totalPages: totalPages ?? this.totalPages,
    totalItems: totalItems ?? this.totalItems,
    itemsPerPage: itemsPerPage ?? this.itemsPerPage,
  );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    totalItems: json["totalItems"],
    itemsPerPage: json["itemsPerPage"],
  );

  Map<String, dynamic> toJson() => {
    "currentPage": currentPage,
    "totalPages": totalPages,
    "totalItems": totalItems,
    "itemsPerPage": itemsPerPage,
  };
}
