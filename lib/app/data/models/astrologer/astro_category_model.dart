// To parse this JSON data, do
//
//     final astroCategoryModel = astroCategoryModelFromJson(jsonString);

import 'dart:convert';

AstroCategoryModel astroCategoryModelFromJson(String str) => AstroCategoryModel.fromJson(json.decode(str));

String astroCategoryModelToJson(AstroCategoryModel data) => json.encode(data.toJson());

class AstroCategoryModel {
    final bool? status;
    final String? message;
    final List<Datum>? data;

    AstroCategoryModel({
        this.status,
        this.message,
        this.data,
    });

    AstroCategoryModel copyWith({
        bool? status,
        String? message,
        List<Datum>? data,
    }) => 
        AstroCategoryModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory AstroCategoryModel.fromJson(Map<String, dynamic> json) => AstroCategoryModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final int? categoryId;
    final String? categoryName;
    final String? description;
    final DateTime? createdAt;

    Datum({
        this.categoryId,
        this.categoryName,
        this.description,
        this.createdAt,
    });

    Datum copyWith({
        int? categoryId,
        String? categoryName,
        String? description,
        DateTime? createdAt,
    }) => 
        Datum(
            categoryId: categoryId ?? this.categoryId,
            categoryName: categoryName ?? this.categoryName,
            description: description ?? this.description,
            createdAt: createdAt ?? this.createdAt,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        categoryId: json["CategoryID"],
        categoryName: json["CategoryName"],
        description: json["Description"],
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "CategoryID": categoryId,
        "CategoryName": categoryName,
        "Description": description,
        "CreatedAt": createdAt?.toIso8601String(),
    };
}
