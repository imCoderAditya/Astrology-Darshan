// To parse this JSON data, do
//
//     final categoryEcModel = categoryEcModelFromJson(jsonString);

import 'dart:convert';

CategoryEcModel categoryEcModelFromJson(String str) => CategoryEcModel.fromJson(json.decode(str));

String categoryEcModelToJson(CategoryEcModel data) => json.encode(data.toJson());

class CategoryEcModel {
    final bool? status;
    final String? message;
    final List<CategoryEc>? categoryEc;

    CategoryEcModel({
        this.status,
        this.message,
        this.categoryEc,
    });

    CategoryEcModel copyWith({
        bool? status,
        String? message,
        List<CategoryEc>? categoryEc,
    }) => 
        CategoryEcModel(
            status: status ?? this.status,
            message: message ?? this.message,
            categoryEc: categoryEc ?? this.categoryEc,
        );

    factory CategoryEcModel.fromJson(Map<String, dynamic> json) => CategoryEcModel(
        status: json["status"],
        message: json["message"],
        categoryEc: json["data"] == null ? [] : List<CategoryEc>.from(json["data"]!.map((x) => CategoryEc.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": categoryEc == null ? [] : List<dynamic>.from(categoryEc!.map((x) => x.toJson())),
    };
}

class CategoryEc {
    final int? categoryId;
    final String? categoryName;
    final String? description;
    final String? categoryImage;

    CategoryEc({
        this.categoryId,
        this.categoryName,
        this.description,
        this.categoryImage,
    });

    CategoryEc copyWith({
        int? categoryId,
        String? categoryName,
        String? description,
        String? categoryImage,
    }) => 
        CategoryEc(
            categoryId: categoryId ?? this.categoryId,
            categoryName: categoryName ?? this.categoryName,
            description: description ?? this.description,
            categoryImage: categoryImage ?? this.categoryImage,
        );

    factory CategoryEc.fromJson(Map<String, dynamic> json) => CategoryEc(
        categoryId: json["CategoryID"],
        categoryName: json["CategoryName"],
        description: json["Description"],
        categoryImage: json["CategoryImage"],
    );

    Map<String, dynamic> toJson() => {
        "CategoryID": categoryId,
        "CategoryName": categoryName,
        "Description": description,
        "CategoryImage": categoryImage,
    };
}
