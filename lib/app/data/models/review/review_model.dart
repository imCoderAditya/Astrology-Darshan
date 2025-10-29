// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

ReviewModel reviewModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  final bool? success;
  final int? total;
  final List<ReviewData>? reviews;

  ReviewModel({this.success, this.total, this.reviews});

  ReviewModel copyWith({
    bool? success,
    int? total,
    List<ReviewData>? reviews,
  }) => ReviewModel(
    success: success ?? this.success,
    total: total ?? this.total,
    reviews: reviews ?? this.reviews,
  );

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    success: json["success"],
    total: json["total"],
    reviews:
        json["data"] == null
            ? []
            : List<ReviewData>.from(
              json["data"]!.map((x) => ReviewData.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "total": total,
    "data":
        reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
  };
}

class ReviewData {
  final int? reviewId;
  final int? sessionId;
  final int? customerId;
  final String? customerName;
  final String? customerProfilePic;
  final int? astrologerId;
  final String? astrologerName;
  final String? astrologerProfilePic;
  final int? rating;
  final String? reviewText;
  final String? createdAt;

  ReviewData({
    this.reviewId,
    this.sessionId,
    this.customerId,
    this.customerName,
    this.customerProfilePic,
    this.astrologerId,
    this.astrologerName,
    this.astrologerProfilePic,
    this.rating,
    this.reviewText,
    this.createdAt,
  });

  ReviewData copyWith({
    int? reviewId,
    int? sessionId,
    int? customerId,
    String? customerName,
    String? customerProfilePic,
    int? astrologerId,
    String? astrologerName,
    String? astrologerProfilePic,
    int? rating,
    String? reviewText,
    String? createdAt,
  }) => ReviewData(
    reviewId: reviewId ?? this.reviewId,
    sessionId: sessionId ?? this.sessionId,
    customerId: customerId ?? this.customerId,
    customerName: customerName ?? this.customerName,
    customerProfilePic: customerProfilePic ?? this.customerProfilePic,
    astrologerId: astrologerId ?? this.astrologerId,
    astrologerName: astrologerName ?? this.astrologerName,
    astrologerProfilePic: astrologerProfilePic ?? this.astrologerProfilePic,
    rating: rating ?? this.rating,
    reviewText: reviewText ?? this.reviewText,
    createdAt: createdAt ?? this.createdAt,
  );

  factory ReviewData.fromJson(Map<String, dynamic> json) => ReviewData(
    reviewId: json["ReviewID"],
    sessionId: json["SessionID"],
    customerId: json["CustomerID"],
    customerName: json["CustomerName"],
    customerProfilePic: json["CustomerProfilePic"],
    astrologerId: json["AstrologerID"],
    astrologerName: json["AstrologerName"],
    astrologerProfilePic: json["AstrologerProfilePic"],
    rating: json["Rating"],
    reviewText: json["ReviewText"],
    createdAt: json["CreatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "ReviewID": reviewId,
    "SessionID": sessionId,
    "CustomerID": customerId,
    "CustomerName": customerName,
    "CustomerProfilePic": customerProfilePic,
    "AstrologerID": astrologerId,
    "AstrologerName": astrologerName,
    "AstrologerProfilePic": astrologerProfilePic,
    "Rating": rating,
    "ReviewText": reviewText,
    "CreatedAt": createdAt,
  };
}
