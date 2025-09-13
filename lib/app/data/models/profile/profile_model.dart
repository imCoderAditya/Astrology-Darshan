// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    final bool? status;
    final String? message;
    final Data? data;

    ProfileModel({
        this.status,
        this.message,
        this.data,
    });

    ProfileModel copyWith({
        bool? status,
        String? message,
        Data? data,
    }) => 
        ProfileModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    final int? userId;
    final String? firstName;
    final String? lastName;
    final String? email;
    final String? phoneNumber;
    final DateTime? dateOfBirth;
    final String? timeOfBirth;
    final String? placeOfBirth;
    final String? gender;
    final String? profilePicture;
    final String? userType;
    final bool? isVerified;
    final bool? isActive;
    final int? customerId;
    final double? walletBalance;
    final double? totalSpent;
    final String? preferredLanguage;
    final String? timezone;
    final String? notificationPreferences;

    Data({
        this.userId,
        this.firstName,
        this.lastName,
        this.email,
        this.phoneNumber,
        this.dateOfBirth,
        this.timeOfBirth,
        this.placeOfBirth,
        this.gender,
        this.profilePicture,
        this.userType,
        this.isVerified,
        this.isActive,
        this.customerId,
        this.walletBalance,
        this.totalSpent,
        this.preferredLanguage,
        this.timezone,
        this.notificationPreferences,
    });

    Data copyWith({
        int? userId,
        String? firstName,
        String? lastName,
        String? email,
        String? phoneNumber,
        DateTime? dateOfBirth,
        String? timeOfBirth,
        String? placeOfBirth,
        String? gender,
        String? profilePicture,
        String? userType,
        bool? isVerified,
        bool? isActive,
        int? customerId,
        double? walletBalance,
        double? totalSpent,
        String? preferredLanguage,
        String? timezone,
        String? notificationPreferences,
    }) => 
        Data(
            userId: userId ?? this.userId,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            email: email ?? this.email,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            timeOfBirth: timeOfBirth ?? this.timeOfBirth,
            placeOfBirth: placeOfBirth ?? this.placeOfBirth,
            gender: gender ?? this.gender,
            profilePicture: profilePicture ?? this.profilePicture,
            userType: userType ?? this.userType,
            isVerified: isVerified ?? this.isVerified,
            isActive: isActive ?? this.isActive,
            customerId: customerId ?? this.customerId,
            walletBalance: walletBalance ?? this.walletBalance,
            totalSpent: totalSpent ?? this.totalSpent,
            preferredLanguage: preferredLanguage ?? this.preferredLanguage,
            timezone: timezone ?? this.timezone,
            notificationPreferences: notificationPreferences ?? this.notificationPreferences,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["UserID"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        phoneNumber: json["PhoneNumber"],
        dateOfBirth: json["DateOfBirth"] == null ? null : DateTime.parse(json["DateOfBirth"]),
        timeOfBirth: json["TimeOfBirth"],
        placeOfBirth: json["PlaceOfBirth"],
        gender: json["Gender"],
        profilePicture: json["ProfilePicture"],
        userType: json["UserType"],
        isVerified: json["IsVerified"],
        isActive: json["IsActive"],
        customerId: json["CustomerID"],
        walletBalance: json["WalletBalance"],
        totalSpent: json["TotalSpent"],
        preferredLanguage: json["PreferredLanguage"],
        timezone: json["Timezone"],
        notificationPreferences: json["NotificationPreferences"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "DateOfBirth": dateOfBirth?.toIso8601String(),
        "TimeOfBirth": timeOfBirth,
        "PlaceOfBirth": placeOfBirth,
        "Gender": gender,
        "ProfilePicture": profilePicture,
        "UserType": userType,
        "IsVerified": isVerified,
        "IsActive": isActive,
        "CustomerID": customerId,
        "WalletBalance": walletBalance,
        "TotalSpent": totalSpent,
        "PreferredLanguage": preferredLanguage,
        "Timezone": timezone,
        "NotificationPreferences": notificationPreferences,
    };
}
