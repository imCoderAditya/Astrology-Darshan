// To parse this JSON data, do
//
//     final pujaCategoryModel = pujaCategoryModelFromJson(jsonString);

import 'dart:convert';

PujaCategoryModel pujaCategoryModelFromJson(String str) =>
    PujaCategoryModel.fromJson(json.decode(str));

String pujaCategoryModelToJson(PujaCategoryModel data) =>
    json.encode(data.toJson());

class PujaCategoryModel {
  final bool? status;
  final String? message;
  final List<PujaCategory>? pujaCategory;

  PujaCategoryModel({this.status, this.message, this.pujaCategory});

  PujaCategoryModel copyWith({
    bool? status,
    String? message,
    List<PujaCategory>? pujaCategory,
  }) => PujaCategoryModel(
    status: status ?? this.status,
    message: message ?? this.message,
    pujaCategory: pujaCategory ?? this.pujaCategory,
  );

  factory PujaCategoryModel.fromJson(Map<String, dynamic> json) =>
      PujaCategoryModel(
        status: json["status"],
        message: json["message"],
        pujaCategory:
            json["data"] == null
                ? []
                : List<PujaCategory>.from(
                  json["data"]!.map((x) => PujaCategory.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data":
        pujaCategory == null
            ? []
            : List<dynamic>.from(pujaCategory!.map((x) => x.toJson())),
  };
}

class PujaCategory {
  final int? pujaCategoryId;
  final String? categoryName;
  final String? description;
  final String? categoryImage;
  final int? sortOrder;

  PujaCategory({
    this.pujaCategoryId,
    this.categoryName,
    this.description,
    this.categoryImage,
    this.sortOrder,
  });

  PujaCategory copyWith({
    int? pujaCategoryId,
    String? categoryName,
    String? description,
    String? categoryImage,
    int? sortOrder,
  }) => PujaCategory(
    pujaCategoryId: pujaCategoryId ?? this.pujaCategoryId,
    categoryName: categoryName ?? this.categoryName,
    description: description ?? this.description,
    categoryImage: categoryImage ?? this.categoryImage,
    sortOrder: sortOrder ?? this.sortOrder,
  );

  factory PujaCategory.fromJson(Map<String, dynamic> json) => PujaCategory(
    pujaCategoryId: json["PujaCategoryID"],
    categoryName: json["CategoryName"],
    description: json["Description"],
    categoryImage: json["CategoryImage"],
    sortOrder: json["SortOrder"],
  );

  Map<String, dynamic> toJson() => {
    "PujaCategoryID": pujaCategoryId,
    "CategoryName": categoryName,
    "Description": description,
    "CategoryImage": categoryImage,
    "SortOrder": sortOrder,
  };
}
