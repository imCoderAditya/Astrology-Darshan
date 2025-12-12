// To parse this JSON data, do
//
//     final numerologyModel = numerologyModelFromJson(jsonString);

import 'dart:convert';

NumerologyModel numerologyModelFromJson(String str) => NumerologyModel.fromJson(json.decode(str));

String numerologyModelToJson(NumerologyModel data) => json.encode(data.toJson());

class NumerologyModel {
    final String? status;
    final Data? data;

    NumerologyModel({
        this.status,
        this.data,
    });

    NumerologyModel copyWith({
        String? status,
        Data? data,
    }) => 
        NumerologyModel(
            status: status ?? this.status,
            data: data ?? this.data,
        );

    factory NumerologyModel.fromJson(Map<String, dynamic> json) => NumerologyModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    final LifePathNumber? lifePathNumber;

    Data({
        this.lifePathNumber,
    });

    Data copyWith({
        LifePathNumber? lifePathNumber,
    }) => 
        Data(
            lifePathNumber: lifePathNumber ?? this.lifePathNumber,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        lifePathNumber: json["life_path_number"] == null ? null : LifePathNumber.fromJson(json["life_path_number"]),
    );

    Map<String, dynamic> toJson() => {
        "life_path_number": lifePathNumber?.toJson(),
    };
}

class LifePathNumber {
    final String? name;
    final int? number;
    final String? description;

    LifePathNumber({
        this.name,
        this.number,
        this.description,
    });

    LifePathNumber copyWith({
        String? name,
        int? number,
        String? description,
    }) => 
        LifePathNumber(
            name: name ?? this.name,
            number: number ?? this.number,
            description: description ?? this.description,
        );

    factory LifePathNumber.fromJson(Map<String, dynamic> json) => LifePathNumber(
        name: json["name"],
        number: json["number"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
        "description": description,
    };
}
