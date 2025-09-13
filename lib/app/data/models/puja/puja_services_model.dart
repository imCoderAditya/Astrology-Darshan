// To parse this JSON data, do
//
//     final pujaServiceModel = pujaServiceModelFromJson(jsonString);

import 'dart:convert';

PujaServiceModel pujaServiceModelFromJson(String str) =>
    PujaServiceModel.fromJson(json.decode(str));

String pujaServiceModelToJson(PujaServiceModel data) =>
    json.encode(data.toJson());

class PujaServiceModel {
  final bool? status;
  final String? message;
  final int? totalCount;
  final int? page;
  final int? limit;
  final List<PujaService>? pujaService;

  PujaServiceModel({
    this.status,
    this.message,
    this.totalCount,
    this.page,
    this.limit,
    this.pujaService,
  });

  PujaServiceModel copyWith({
    bool? status,
    String? message,
    int? totalCount,
    int? page,
    int? limit,
    List<PujaService>? pujaService,
  }) => PujaServiceModel(
    status: status ?? this.status,
    message: message ?? this.message,
    totalCount: totalCount ?? this.totalCount,
    page: page ?? this.page,
    limit: limit ?? this.limit,
    pujaService: pujaService ?? this.pujaService,
  );

  factory PujaServiceModel.fromJson(Map<String, dynamic> json) =>
      PujaServiceModel(
        status: json["status"],
        message: json["message"],
        totalCount: json["totalCount"],
        page: json["page"],
        limit: json["limit"],
        pujaService:
            json["data"] == null
                ? []
                : List<PujaService>.from(
                  json["data"]!.map((x) => PujaService.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "totalCount": totalCount,
    "page": page,
    "limit": limit,
    "data":
        pujaService == null
            ? []
            : List<dynamic>.from(pujaService!.map((x) => x.toJson())),
  };
}

class PujaService {
  final int? pujaServiceId;
  final String? serviceName;
  final String? description;
  final double? price;
  final int? duration;
  final String? benefits;
  final String? requirements;
  final String? includes;
  final String? serviceImage;
  final double? averageRating;
  final int? reviewCount;
  final int? bookingCount;
  final List<Review>? reviews;

  PujaService({
    this.pujaServiceId,
    this.serviceName,
    this.description,
    this.price,
    this.duration,
    this.benefits,
    this.requirements,
    this.includes,
    this.serviceImage,
    this.averageRating,
    this.reviewCount,
    this.bookingCount,
    this.reviews,
  });

  PujaService copyWith({
    int? pujaServiceId,
    String? serviceName,
    String? description,
    double? price,
    int? duration,
    String? benefits,
    String? requirements,
    String? includes,
    String? serviceImage,
    double? averageRating,
    int? reviewCount,
    int? bookingCount,
    List<Review>? reviews,
  }) => PujaService(
    pujaServiceId: pujaServiceId ?? this.pujaServiceId,
    serviceName: serviceName ?? this.serviceName,
    description: description ?? this.description,
    price: price ?? this.price,
    duration: duration ?? this.duration,
    benefits: benefits ?? this.benefits,
    requirements: requirements ?? this.requirements,
    includes: includes ?? this.includes,
    serviceImage: serviceImage ?? this.serviceImage,
    averageRating: averageRating ?? this.averageRating,
    reviewCount: reviewCount ?? this.reviewCount,
    bookingCount: bookingCount ?? this.bookingCount,
    reviews: reviews ?? this.reviews,
  );

  factory PujaService.fromJson(Map<String, dynamic> json) => PujaService(
    pujaServiceId: json["PujaServiceID"],
    serviceName: json["ServiceName"],
    description: json["Description"],
    price: json["Price"],
    duration: json["Duration"],
    benefits: json["Benefits"],
    requirements: json["Requirements"],
    includes: json["Includes"],
    serviceImage: json["ServiceImage"],
    averageRating: json["AverageRating"],
    reviewCount: json["ReviewCount"],
    bookingCount: json["BookingCount"],
    reviews:
        json["Reviews"] == null
            ? []
            : List<Review>.from(
              json["Reviews"]!.map((x) => Review.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "PujaServiceID": pujaServiceId,
    "ServiceName": serviceName,
    "Description": description,
    "Price": price,
    "Duration": duration,
    "Benefits": benefits,
    "Requirements": requirements,
    "Includes": includes,
    "ServiceImage": serviceImage,
    "AverageRating": averageRating,
    "ReviewCount": reviewCount,
    "BookingCount": bookingCount,
    "Reviews":
        reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
  };
}

class Review {
  final int? reviewId;
  final int? rating;
  final String? comment;
  final DateTime? createdAt;
  final Reviewer? reviewer;

  Review({
    this.reviewId,
    this.rating,
    this.comment,
    this.createdAt,
    this.reviewer,
  });

  Review copyWith({
    int? reviewId,
    int? rating,
    String? comment,
    DateTime? createdAt,
    Reviewer? reviewer,
  }) => Review(
    reviewId: reviewId ?? this.reviewId,
    rating: rating ?? this.rating,
    comment: comment ?? this.comment,
    createdAt: createdAt ?? this.createdAt,
    reviewer: reviewer ?? this.reviewer,
  );

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    reviewId: json["ReviewID"],
    rating: json["Rating"],
    comment: json["Comment"],
    createdAt:
        json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    reviewer:
        json["Reviewer"] == null ? null : Reviewer.fromJson(json["Reviewer"]),
  );

  Map<String, dynamic> toJson() => {
    "ReviewID": reviewId,
    "Rating": rating,
    "Comment": comment,
    "CreatedAt": createdAt?.toIso8601String(),
    "Reviewer": reviewer?.toJson(),
  };
}

class Reviewer {
  final int? userId;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profilePicture;

  Reviewer({
    this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.profilePicture,
  });

  Reviewer copyWith({
    int? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
  }) => Reviewer(
    userId: userId ?? this.userId,
    name: name ?? this.name,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    profilePicture: profilePicture ?? this.profilePicture,
  );

  factory Reviewer.fromJson(Map<String, dynamic> json) => Reviewer(
    userId: json["UserID"],
    name: json["Name"],
    email: json["Email"],
    phoneNumber: json["PhoneNumber"],
    profilePicture: json["ProfilePicture"],
  );

  Map<String, dynamic> toJson() => {
    "UserID": userId,
    "Name": name,
    "Email": email,
    "PhoneNumber": phoneNumber,
    "ProfilePicture": profilePicture,
  };
}
