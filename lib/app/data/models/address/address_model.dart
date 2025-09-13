// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

AddressModel addressModelFromJson(String str) => AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
    final bool? status;
    final String? message;
    final List<AddressDatum>? data;

    AddressModel({
        this.status,
        this.message,
        this.data,
    });

    AddressModel copyWith({
        bool? status,
        String? message,
        List<AddressDatum>? data,
    }) => 
        AddressModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<AddressDatum>.from(json["data"]!.map((x) => AddressDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class AddressDatum {
    final int? id;
    final int? userId;
    final Address? address;
    final bool? isActive;

    AddressDatum({
        this.id,
        this.userId,
        this.address,
        this.isActive,
    });

    AddressDatum copyWith({
        int? id,
        int? userId,
        Address? address,
        bool? isActive,
    }) => 
        AddressDatum(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            address: address ?? this.address,
            isActive: isActive ?? this.isActive,
        );

    factory AddressDatum.fromJson(Map<String, dynamic> json) => AddressDatum(
        id: json["id"],
        userId: json["userId"],
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        isActive: json["isActive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "address": address?.toJson(),
        "isActive": isActive,
    };
}

class Address {
    final String? firstName;
    final String? lastName;
    final String? house;
    final String? gali;
    final String? nearLandmark;
    final String? address2;
    final String? city;
    final String? state;
    final String? postalCode;
    final String? country;
    final String? phoneNumber;

    Address({
        this.firstName,
        this.lastName,
        this.house,
        this.gali,
        this.nearLandmark,
        this.address2,
        this.city,
        this.state,
        this.postalCode,
        this.country,
        this.phoneNumber,
    });

    Address copyWith({
        String? firstName,
        String? lastName,
        String? house,
        String? gali,
        String? nearLandmark,
        String? address2,
        String? city,
        String? state,
        String? postalCode,
        String? country,
        String? phoneNumber,
    }) => 
        Address(
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            house: house ?? this.house,
            gali: gali ?? this.gali,
            nearLandmark: nearLandmark ?? this.nearLandmark,
            address2: address2 ?? this.address2,
            city: city ?? this.city,
            state: state ?? this.state,
            postalCode: postalCode ?? this.postalCode,
            country: country ?? this.country,
            phoneNumber: phoneNumber ?? this.phoneNumber,
        );

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        firstName: json["FirstName"],
        lastName: json["LastName"],
        house: json["House"],
        gali: json["Gali"],
        nearLandmark: json["NearLandmark"],
        address2: json["Address2"],
        city: json["City"],
        state: json["State"],
        postalCode: json["PostalCode"],
        country: json["Country"],
        phoneNumber: json["PhoneNumber"],
    );

    Map<String, dynamic> toJson() => {
        "FirstName": firstName,
        "LastName": lastName,
        "House": house,
        "Gali": gali,
        "NearLandmark": nearLandmark,
        "Address2": address2,
        "City": city,
        "State": state,
        "PostalCode": postalCode,
        "Country": country,
        "PhoneNumber": phoneNumber,
    };
}
