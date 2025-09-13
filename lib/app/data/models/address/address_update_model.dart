// To parse this JSON data, do
//
//     final addressUpdateModel = addressUpdateModelFromJson(jsonString);

import 'dart:convert';

AddressUpdateModel addressUpdateModelFromJson(String str) => AddressUpdateModel.fromJson(json.decode(str));

String addressUpdateModelToJson(AddressUpdateModel data) => json.encode(data.toJson());

class AddressUpdateModel {
    final int? userId;
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

    AddressUpdateModel({
        this.userId,
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

    AddressUpdateModel copyWith({
        int? userId,
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
        AddressUpdateModel(
            userId: userId ?? this.userId,
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

    factory AddressUpdateModel.fromJson(Map<String, dynamic> json) => AddressUpdateModel(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        house: json["house"],
        gali: json["gali"],
        nearLandmark: json["nearLandmark"],
        address2: json["address2"],
        city: json["city"],
        state: json["state"],
        postalCode: json["postalCode"],
        country: json["country"],
        phoneNumber: json["phoneNumber"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "house": house,
        "gali": gali,
        "nearLandmark": nearLandmark,
        "address2": address2,
        "city": city,
        "state": state,
        "postalCode": postalCode,
        "country": country,
        "phoneNumber": phoneNumber,
    };
}
