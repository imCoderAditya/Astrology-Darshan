// To parse this JSON data, do
//
//     final popupImageModel = popupImageModelFromJson(jsonString);

import 'dart:convert';

PopupImageModel popupImageModelFromJson(String str) => PopupImageModel.fromJson(json.decode(str));

String popupImageModelToJson(PopupImageModel data) => json.encode(data.toJson());

class PopupImageModel {
    final bool? success;
    final int? total;
    final List<Datum>? data;

    PopupImageModel({
        this.success,
        this.total,
        this.data,
    });

    PopupImageModel copyWith({
        bool? success,
        int? total,
        List<Datum>? data,
    }) => 
        PopupImageModel(
            success: success ?? this.success,
            total: total ?? this.total,
            data: data ?? this.data,
        );

    factory PopupImageModel.fromJson(Map<String, dynamic> json) => PopupImageModel(
        success: json["success"],
        total: json["total"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "total": total,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final int? popupId;
    final String? imageUrl;
    final String? redirect;
    final bool? isActive;
    final DateTime? createdAt;
    final String? type;

    Datum({
        this.popupId,
        this.imageUrl,
        this.redirect,
        this.isActive,
        this.createdAt,
        this.type,
    });

    Datum copyWith({
        int? popupId,
        String? imageUrl,
        String? redirect,
        bool? isActive,
        DateTime? createdAt,
        String? type,
    }) => 
        Datum(
            popupId: popupId ?? this.popupId,
            imageUrl: imageUrl ?? this.imageUrl,
            redirect: redirect ?? this.redirect,
            isActive: isActive ?? this.isActive,
            createdAt: createdAt ?? this.createdAt,
            type: type ?? this.type,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        popupId: json["popupID"],
        imageUrl: json["ImageUrl"],
        redirect: json["Redirect"],
        isActive: json["IsActive"],
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
        type: json["Type"],
    );

    Map<String, dynamic> toJson() => {
        "popupID": popupId,
        "ImageUrl": imageUrl,
        "Redirect": redirect,
        "IsActive": isActive,
        "CreatedAt": createdAt?.toIso8601String(),
        "Type": type,
    };
}
