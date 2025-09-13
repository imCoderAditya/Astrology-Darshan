// To parse this JSON data, do
//
//     final userRequestModel = userRequestModelFromJson(jsonString);

import 'dart:convert';

UserRequestModel userRequestModelFromJson(String str) =>
    UserRequestModel.fromJson(json.decode(str));

String userRequestModelToJson(UserRequestModel data) =>
    json.encode(data.toJson());

class UserRequestModel {
  final bool? success;
  final Data? data;
  final String? message;

  UserRequestModel({this.success, this.data, this.message});

  UserRequestModel copyWith({bool? success, Data? data, String? message}) =>
      UserRequestModel(
        success: success ?? this.success,
        data: data ?? this.data,
        message: message ?? this.message,
      );

  factory UserRequestModel.fromJson(Map<String, dynamic> json) =>
      UserRequestModel(
        success: json["Success"],
        data: json["Data"] == null ? null : Data.fromJson(json["Data"]),
        message: json["Message"],
      );

  Map<String, dynamic> toJson() => {
    "Success": success,
    "Data": data?.toJson(),
    "Message": message,
  };
}

class Data {
  final List<Session>? sessions;
  final Pagination? pagination;

  Data({this.sessions, this.pagination});

  Data copyWith({List<Session>? sessions, Pagination? pagination}) => Data(
    sessions: sessions ?? this.sessions,
    pagination: pagination ?? this.pagination,
  );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sessions:
        json["sessions"] == null
            ? []
            : List<Session>.from(
              json["sessions"]!.map((x) => Session.fromJson(x)),
            ),
    pagination:
        json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "sessions":
        sessions == null
            ? []
            : List<dynamic>.from(sessions!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Pagination {
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;

  Pagination({this.currentPage, this.totalPages, this.totalItems});

  Pagination copyWith({
    int? currentPage,
    int? totalPages,
    int? totalItems,
  }) => Pagination(
    currentPage: currentPage ?? this.currentPage,
    totalPages: totalPages ?? this.totalPages,
    totalItems: totalItems ?? this.totalItems,
  );

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["CurrentPage"],
    totalPages: json["TotalPages"],
    totalItems: json["TotalItems"],
  );

  Map<String, dynamic> toJson() => {
    "CurrentPage": currentPage,
    "TotalPages": totalPages,
    "TotalItems": totalItems,
  };
}

class Session {
  final int? sessionId;
  final String? astrologerName;
  final String? astrologerPhoto;
  final String? categoryName;
  final String? sessionType;
  final String? status;
  final String? scheduledAt;
  final String? startedAt;
  final String? endedAt;
  final int? duration;
  final double? totalAmount;
  final dynamic customerRating;
  final dynamic customerReview;
  final Customer? customer;

  Session({
    this.sessionId,
    this.astrologerName,
    this.astrologerPhoto,
    this.categoryName,
    this.sessionType,
    this.status,
    this.scheduledAt,
    this.startedAt,
    this.endedAt,
    this.duration,
    this.totalAmount,
    this.customerRating,
    this.customerReview,
    this.customer,
  });

  Session copyWith({
    int? sessionId,
    String? astrologerName,
    String? astrologerPhoto,
    String? categoryName,
    String? sessionType,
    String? status,
    String? scheduledAt,
    String? startedAt,
    String? endedAt,
    int? duration,
    double? totalAmount,
    dynamic customerRating,
    dynamic customerReview,
    Customer? customer,
  }) => Session(
    sessionId: sessionId ?? this.sessionId,
    astrologerName: astrologerName ?? this.astrologerName,
    astrologerPhoto: astrologerPhoto ?? this.astrologerPhoto,
    categoryName: categoryName ?? this.categoryName,
    sessionType: sessionType ?? this.sessionType,
    status: status ?? this.status,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    duration: duration ?? this.duration,
    totalAmount: totalAmount ?? this.totalAmount,
    customerRating: customerRating ?? this.customerRating,
    customerReview: customerReview ?? this.customerReview,
    customer: customer ?? this.customer,
  );

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    sessionId: json["SessionId"],
    astrologerName: json["AstrologerName"],
    astrologerPhoto: json["AstrologerPhoto"],
    categoryName: json["CategoryName"],
    sessionType: json["SessionType"],
    status: json["Status"],
    scheduledAt: json["ScheduledAt"],
    startedAt: json["StartedAt"],
    endedAt: json["EndedAt"],
    duration: json["Duration"],
    totalAmount: json["TotalAmount"],
    customerRating: json["CustomerRating"],
    customerReview: json["CustomerReview"],
    customer:
        json["Customer"] == null ? null : Customer.fromJson(json["Customer"]),
  );

  Map<String, dynamic> toJson() => {
    "SessionId": sessionId,
    "AstrologerName": astrologerName,
    "AstrologerPhoto": astrologerPhoto,
    "CategoryName": categoryName,
    "SessionType": sessionType,
    "Status": status,
    "ScheduledAt": scheduledAt,
    "StartedAt": startedAt,
    "EndedAt": endedAt,
    "Duration": duration,
    "TotalAmount": totalAmount,
    "CustomerRating": customerRating,
    "CustomerReview": customerReview,
    "Customer": customer?.toJson(),
  };
}

class Customer {
  final int? customerId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? profilePicture;

  Customer({
    this.customerId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.profilePicture,
  });

  Customer copyWith({
    int? customerId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profilePicture,
  }) => Customer(
    customerId: customerId ?? this.customerId,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    profilePicture: profilePicture ?? this.profilePicture,
  );

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    customerId: json["CustomerId"],
    firstName: json["FirstName"],
    lastName: json["LastName"],
    email: json["Email"],
    phoneNumber: json["PhoneNumber"],
    profilePicture: json["ProfilePicture"],
  );

  Map<String, dynamic> toJson() => {
    "CustomerId": customerId,
    "FirstName": firstName,
    "LastName": lastName,
    "Email": email,
    "PhoneNumber": phoneNumber,
    "ProfilePicture": profilePicture,
  };
}
