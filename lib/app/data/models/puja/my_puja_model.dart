// To parse this JSON data, do
//
//     final myPujaModel = myPujaModelFromJson(jsonString);

import 'dart:convert';

MyPujaModel myPujaModelFromJson(String str) => MyPujaModel.fromJson(json.decode(str));

String myPujaModelToJson(MyPujaModel data) => json.encode(data.toJson());

class MyPujaModel {
    final bool? status;
    final String? message;
    final Data? data;

    MyPujaModel({
        this.status,
        this.message,
        this.data,
    });

    MyPujaModel copyWith({
        bool? status,
        String? message,
        Data? data,
    }) => 
        MyPujaModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory MyPujaModel.fromJson(Map<String, dynamic> json) => MyPujaModel(
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
    final List<Booking>? bookings;
    final Pagination? pagination;

    Data({
        this.bookings,
        this.pagination,
    });

    Data copyWith({
        List<Booking>? bookings,
        Pagination? pagination,
    }) => 
        Data(
            bookings: bookings ?? this.bookings,
            pagination: pagination ?? this.pagination,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        bookings: json["bookings"] == null ? [] : List<Booking>.from(json["bookings"]!.map((x) => Booking.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "bookings": bookings == null ? [] : List<dynamic>.from(bookings!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class Booking {
    final int? bookingId;
    final String? bookingNumber;
    final String? pujaServiceName;
    final String? serviceImage;
    final dynamic scheduledDate;
    final dynamic scheduledTime;
    final double? amount;
    final String? status;
    final String? paymentStatus;
    final String? pujaLocation;
    final dynamic liveStreamUrl;
    final bool? canCancel;
    final bool? canReview;
    final String? createdAt;
    final User? user;

    Booking({
        this.bookingId,
        this.bookingNumber,
        this.pujaServiceName,
        this.serviceImage,
        this.scheduledDate,
        this.scheduledTime,
        this.amount,
        this.status,
        this.paymentStatus,
        this.pujaLocation,
        this.liveStreamUrl,
        this.canCancel,
        this.canReview,
        this.createdAt,
        this.user,
    });

    Booking copyWith({
        int? bookingId,
        String? bookingNumber,
        String? pujaServiceName,
        String? serviceImage,
        dynamic scheduledDate,
        dynamic scheduledTime,
        double? amount,
        String? status,
        String? paymentStatus,
        String? pujaLocation,
        dynamic liveStreamUrl,
        bool? canCancel,
        bool? canReview,
        String? createdAt,
        User? user,
    }) => 
        Booking(
            bookingId: bookingId ?? this.bookingId,
            bookingNumber: bookingNumber ?? this.bookingNumber,
            pujaServiceName: pujaServiceName ?? this.pujaServiceName,
            serviceImage: serviceImage ?? this.serviceImage,
            scheduledDate: scheduledDate ?? this.scheduledDate,
            scheduledTime: scheduledTime ?? this.scheduledTime,
            amount: amount ?? this.amount,
            status: status ?? this.status,
            paymentStatus: paymentStatus ?? this.paymentStatus,
            pujaLocation: pujaLocation ?? this.pujaLocation,
            liveStreamUrl: liveStreamUrl ?? this.liveStreamUrl,
            canCancel: canCancel ?? this.canCancel,
            canReview: canReview ?? this.canReview,
            createdAt: createdAt ?? this.createdAt,
            user: user ?? this.user,
        );

    factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        bookingId: json["BookingId"],
        bookingNumber: json["BookingNumber"],
        pujaServiceName: json["PujaServiceName"],
        serviceImage: json["ServiceImage"],
        scheduledDate: json["ScheduledDate"],
        scheduledTime: json["ScheduledTime"],
        amount: json["Amount"]?.toDouble(),
        status: json["Status"],
        paymentStatus: json["PaymentStatus"],
        pujaLocation: json["PujaLocation"],
        liveStreamUrl: json["LiveStreamURL"],
        canCancel: json["CanCancel"],
        canReview: json["CanReview"],
        createdAt: json["CreatedAt"],
        user: json["User"] == null ? null : User.fromJson(json["User"]),
    );

    Map<String, dynamic> toJson() => {
        "BookingId": bookingId,
        "BookingNumber": bookingNumber,
        "PujaServiceName": pujaServiceName,
        "ServiceImage": serviceImage,
        "ScheduledDate": scheduledDate,
        "ScheduledTime": scheduledTime,
        "Amount": amount,
        "Status": status,
        "PaymentStatus": paymentStatus,
        "PujaLocation": pujaLocation,
        "LiveStreamURL": liveStreamUrl,
        "CanCancel": canCancel,
        "CanReview": canReview,
        "CreatedAt": createdAt,
        "User": user?.toJson(),
    };
}

class User {
    final int? userId;
    final String? name;
    final String? email;
    final String? phoneNumber;
    final String? profilePicture;

    User({
        this.userId,
        this.name,
        this.email,
        this.phoneNumber,
        this.profilePicture,
    });

    User copyWith({
        int? userId,
        String? name,
        String? email,
        String? phoneNumber,
        String? profilePicture,
    }) => 
        User(
            userId: userId ?? this.userId,
            name: name ?? this.name,
            email: email ?? this.email,
            phoneNumber: phoneNumber ?? this.phoneNumber,
            profilePicture: profilePicture ?? this.profilePicture,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
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

class Pagination {
    final int? currentPage;
    final int? totalPages;
    final int? totalItems;

    Pagination({
        this.currentPage,
        this.totalPages,
        this.totalItems,
    });

    Pagination copyWith({
        int? currentPage,
        int? totalPages,
        int? totalItems,
    }) => 
        Pagination(
            currentPage: currentPage ?? this.currentPage,
            totalPages: totalPages ?? this.totalPages,
            totalItems: totalItems ?? this.totalItems,
        );

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        totalItems: json["totalItems"],
    );

    Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "totalPages": totalPages,
        "totalItems": totalItems,
    };
}
