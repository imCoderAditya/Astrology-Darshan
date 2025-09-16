// To parse this JSON data, do
//
//     final giftModel = giftModelFromJson(jsonString);

import 'dart:convert';

GiftModel giftModelFromJson(String str) => GiftModel.fromJson(json.decode(str));

String giftModelToJson(GiftModel data) => json.encode(data.toJson());

class GiftModel {
    final bool? success;
    final int? total;
    final List<GiftData>? data;

    GiftModel({
        this.success,
        this.total,
        this.data,
    });

    GiftModel copyWith({
        bool? success,
        int? total,
        List<GiftData>? data,
    }) => 
        GiftModel(
            success: success ?? this.success,
            total: total ?? this.total,
            data: data ?? this.data,
        );

    factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
        success: json["success"],
        total: json["total"],
        data: json["data"] == null ? [] : List<GiftData>.from(json["data"]!.map((x) => GiftData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "total": total,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class GiftData {
    final int? giftId;
    final String? giftName;
    final String? giftImage;
    final String? giftAnimation;
    final double? price;
    final bool? isActive;
    final String? createdAt;

    GiftData({
        this.giftId,
        this.giftName,
        this.giftImage,
        this.giftAnimation,
        this.price,
        this.isActive,
        this.createdAt,
    });

    GiftData copyWith({
        int? giftId,
        String? giftName,
        String? giftImage,
        String? giftAnimation,
        double? price,
        bool? isActive,
        String? createdAt,
    }) => 
        GiftData(
            giftId: giftId ?? this.giftId,
            giftName: giftName ?? this.giftName,
            giftImage: giftImage ?? this.giftImage,
            giftAnimation: giftAnimation ?? this.giftAnimation,
            price: price ?? this.price,
            isActive: isActive ?? this.isActive,
            createdAt: createdAt ?? this.createdAt,
        );

    factory GiftData.fromJson(Map<String, dynamic> json) => GiftData(
        giftId: json["GiftID"],
        giftName: json["GiftName"],
        giftImage: json["GiftImage"],
        giftAnimation: json["GiftAnimation"],
        price: json["Price"]?.toDouble(),
        isActive: json["IsActive"],
        createdAt: json["CreatedAt"],
    );

    Map<String, dynamic> toJson() => {
        "GiftID": giftId,
        "GiftName": giftName,
        "GiftImage": giftImage,
        "GiftAnimation": giftAnimation,
        "Price": price,
        "IsActive": isActive,
        "CreatedAt": createdAt,
    };
}
