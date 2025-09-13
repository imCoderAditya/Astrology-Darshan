// To parse this JSON data, do
//
//     final imageSliderModel = imageSliderModelFromJson(jsonString);

import 'dart:convert';

ImageSliderModel imageSliderModelFromJson(String str) => ImageSliderModel.fromJson(json.decode(str));

String imageSliderModelToJson(ImageSliderModel data) => json.encode(data.toJson());

class ImageSliderModel {
    final bool? success;
    final int? total;
    final List<Datum>? data;

    ImageSliderModel({
        this.success,
        this.total,
        this.data,
    });

    ImageSliderModel copyWith({
        bool? success,
        int? total,
        List<Datum>? data,
    }) => 
        ImageSliderModel(
            success: success ?? this.success,
            total: total ?? this.total,
            data: data ?? this.data,
        );

    factory ImageSliderModel.fromJson(Map<String, dynamic> json) => ImageSliderModel(
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
    final int? sliderId;
    final String? imageUrl;
    final String? redirect;
    final int? displayOrder;
    final bool? isActive;
    final DateTime? createdAt;
    final String? typee;

    Datum({
        this.sliderId,
        this.imageUrl,
        this.redirect,
        this.displayOrder,
        this.isActive,
        this.createdAt,
        this.typee,
    });

    Datum copyWith({
        int? sliderId,
        String? imageUrl,
        String? redirect,
        int? displayOrder,
        bool? isActive,
        DateTime? createdAt,
        String? typee,
    }) => 
        Datum(
            sliderId: sliderId ?? this.sliderId,
            imageUrl: imageUrl ?? this.imageUrl,
            redirect: redirect ?? this.redirect,
            displayOrder: displayOrder ?? this.displayOrder,
            isActive: isActive ?? this.isActive,
            createdAt: createdAt ?? this.createdAt,
            typee: typee ?? this.typee,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        sliderId: json["SliderID"],
        imageUrl: json["ImageUrl"],
        redirect: json["Redirect"],
        displayOrder: json["DisplayOrder"],
        isActive: json["IsActive"],
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
        typee: json["Typee"],
    );

    Map<String, dynamic> toJson() => {
        "SliderID": sliderId,
        "ImageUrl": imageUrl,
        "Redirect": redirect,
        "DisplayOrder": displayOrder,
        "IsActive": isActive,
        "CreatedAt": createdAt?.toIso8601String(),
        "Typee": typee,
    };
}
