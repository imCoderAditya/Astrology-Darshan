// To parse this JSON data, do
//
//     final kundaliMatchingModel = kundaliMatchingModelFromJson(jsonString);

import 'dart:convert';

KundaliMatchingModel kundaliMatchingModelFromJson(String str) => KundaliMatchingModel.fromJson(json.decode(str));

String kundaliMatchingModelToJson(KundaliMatchingModel data) => json.encode(data.toJson());

class KundaliMatchingModel {
    final String? status;
    final Data? data;
    final String? boyName;
    final String? girlName;

    KundaliMatchingModel({
        this.status,
        this.data,
        this.boyName,
        this.girlName,
    });

    KundaliMatchingModel copyWith({
        String? status,
        Data? data,
        String? boyName,
        String? girlName,
    }) => 
        KundaliMatchingModel(
            status: status ?? this.status,
            data: data ?? this.data,
            boyName: boyName ?? this.boyName,
            girlName: girlName ?? this.girlName,
        );

    factory KundaliMatchingModel.fromJson(Map<String, dynamic> json) => KundaliMatchingModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        boyName: json["boyName"],
        girlName: json["girlName"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "boyName": boyName,
        "girlName": girlName,
    };
}

class Data {
    final Info? girlInfo;
    final Info? boyInfo;
    final Message? message;
    final GunaMilan? gunaMilan;
    final MangalDoshaDetails? girlMangalDoshaDetails;
    final MangalDoshaDetails? boyMangalDoshaDetails;

    Data({
        this.girlInfo,
        this.boyInfo,
        this.message,
        this.gunaMilan,
        this.girlMangalDoshaDetails,
        this.boyMangalDoshaDetails,
    });

    Data copyWith({
        Info? girlInfo,
        Info? boyInfo,
        Message? message,
        GunaMilan? gunaMilan,
        MangalDoshaDetails? girlMangalDoshaDetails,
        MangalDoshaDetails? boyMangalDoshaDetails,
    }) => 
        Data(
            girlInfo: girlInfo ?? this.girlInfo,
            boyInfo: boyInfo ?? this.boyInfo,
            message: message ?? this.message,
            gunaMilan: gunaMilan ?? this.gunaMilan,
            girlMangalDoshaDetails: girlMangalDoshaDetails ?? this.girlMangalDoshaDetails,
            boyMangalDoshaDetails: boyMangalDoshaDetails ?? this.boyMangalDoshaDetails,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        girlInfo: json["girl_info"] == null ? null : Info.fromJson(json["girl_info"]),
        boyInfo: json["boy_info"] == null ? null : Info.fromJson(json["boy_info"]),
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
        gunaMilan: json["guna_milan"] == null ? null : GunaMilan.fromJson(json["guna_milan"]),
        girlMangalDoshaDetails: json["girl_mangal_dosha_details"] == null ? null : MangalDoshaDetails.fromJson(json["girl_mangal_dosha_details"]),
        boyMangalDoshaDetails: json["boy_mangal_dosha_details"] == null ? null : MangalDoshaDetails.fromJson(json["boy_mangal_dosha_details"]),
    );

    Map<String, dynamic> toJson() => {
        "girl_info": girlInfo?.toJson(),
        "boy_info": boyInfo?.toJson(),
        "message": message?.toJson(),
        "guna_milan": gunaMilan?.toJson(),
        "girl_mangal_dosha_details": girlMangalDoshaDetails?.toJson(),
        "boy_mangal_dosha_details": boyMangalDoshaDetails?.toJson(),
    };
}

class Info {
    final Koot? koot;
    final Nakshatra? nakshatra;
    final Nakshatra? rasi;

    Info({
        this.koot,
        this.nakshatra,
        this.rasi,
    });

    Info copyWith({
        Koot? koot,
        Nakshatra? nakshatra,
        Nakshatra? rasi,
    }) => 
        Info(
            koot: koot ?? this.koot,
            nakshatra: nakshatra ?? this.nakshatra,
            rasi: rasi ?? this.rasi,
        );

    factory Info.fromJson(Map<String, dynamic> json) => Info(
        koot: json["koot"] == null ? null : Koot.fromJson(json["koot"]),
        nakshatra: json["nakshatra"] == null ? null : Nakshatra.fromJson(json["nakshatra"]),
        rasi: json["rasi"] == null ? null : Nakshatra.fromJson(json["rasi"]),
    );

    Map<String, dynamic> toJson() => {
        "koot": koot?.toJson(),
        "nakshatra": nakshatra?.toJson(),
        "rasi": rasi?.toJson(),
    };
}

class Koot {
    final String? varna;
    final String? vasya;
    final String? tara;
    final String? yoni;
    final String? grahaMaitri;
    final String? gana;
    final String? bhakoot;
    final String? nadi;

    Koot({
        this.varna,
        this.vasya,
        this.tara,
        this.yoni,
        this.grahaMaitri,
        this.gana,
        this.bhakoot,
        this.nadi,
    });

    Koot copyWith({
        String? varna,
        String? vasya,
        String? tara,
        String? yoni,
        String? grahaMaitri,
        String? gana,
        String? bhakoot,
        String? nadi,
    }) => 
        Koot(
            varna: varna ?? this.varna,
            vasya: vasya ?? this.vasya,
            tara: tara ?? this.tara,
            yoni: yoni ?? this.yoni,
            grahaMaitri: grahaMaitri ?? this.grahaMaitri,
            gana: gana ?? this.gana,
            bhakoot: bhakoot ?? this.bhakoot,
            nadi: nadi ?? this.nadi,
        );

    factory Koot.fromJson(Map<String, dynamic> json) => Koot(
        varna: json["varna"],
        vasya: json["vasya"],
        tara: json["tara"],
        yoni: json["yoni"],
        grahaMaitri: json["graha_maitri"],
        gana: json["gana"],
        bhakoot: json["bhakoot"],
        nadi: json["nadi"],
    );

    Map<String, dynamic> toJson() => {
        "varna": varna,
        "vasya": vasya,
        "tara": tara,
        "yoni": yoni,
        "graha_maitri": grahaMaitri,
        "gana": gana,
        "bhakoot": bhakoot,
        "nadi": nadi,
    };
}

class Nakshatra {
    final int? id;
    final String? name;
    final Lord? lord;
    final int? pada;

    Nakshatra({
        this.id,
        this.name,
        this.lord,
        this.pada,
    });

    Nakshatra copyWith({
        int? id,
        String? name,
        Lord? lord,
        int? pada,
    }) => 
        Nakshatra(
            id: id ?? this.id,
            name: name ?? this.name,
            lord: lord ?? this.lord,
            pada: pada ?? this.pada,
        );

    factory Nakshatra.fromJson(Map<String, dynamic> json) => Nakshatra(
        id: json["id"],
        name: json["name"],
        lord: json["lord"] == null ? null : Lord.fromJson(json["lord"]),
        pada: json["pada"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lord": lord?.toJson(),
        "pada": pada,
    };
}

class Lord {
    final int? id;
    final String? name;
    final String? vedicName;

    Lord({
        this.id,
        this.name,
        this.vedicName,
    });

    Lord copyWith({
        int? id,
        String? name,
        String? vedicName,
    }) => 
        Lord(
            id: id ?? this.id,
            name: name ?? this.name,
            vedicName: vedicName ?? this.vedicName,
        );

    factory Lord.fromJson(Map<String, dynamic> json) => Lord(
        id: json["id"],
        name: json["name"],
        vedicName: json["vedic_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "vedic_name": vedicName,
    };
}

class MangalDoshaDetails {
    final bool? hasDosha;
    final bool? hasException;
    final dynamic doshaType;
    final String? description;

    MangalDoshaDetails({
        this.hasDosha,
        this.hasException,
        this.doshaType,
        this.description,
    });

    MangalDoshaDetails copyWith({
        bool? hasDosha,
        bool? hasException,
        dynamic doshaType,
        String? description,
    }) => 
        MangalDoshaDetails(
            hasDosha: hasDosha ?? this.hasDosha,
            hasException: hasException ?? this.hasException,
            doshaType: doshaType ?? this.doshaType,
            description: description ?? this.description,
        );

    factory MangalDoshaDetails.fromJson(Map<String, dynamic> json) => MangalDoshaDetails(
        hasDosha: json["has_dosha"],
        hasException: json["has_exception"],
        doshaType: json["dosha_type"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "has_dosha": hasDosha,
        "has_exception": hasException,
        "dosha_type": doshaType,
        "description": description,
    };
}

class GunaMilan {
    final double? totalPoints;
    final double? maximumPoints;
    final List<Guna>? guna;

    GunaMilan({
        this.totalPoints,
        this.maximumPoints,
        this.guna,
    });

    GunaMilan copyWith({
        double? totalPoints,
        double? maximumPoints,
        List<Guna>? guna,
    }) => 
        GunaMilan(
            totalPoints: totalPoints ?? this.totalPoints,
            maximumPoints: maximumPoints ?? this.maximumPoints,
            guna: guna ?? this.guna,
        );

    factory GunaMilan.fromJson(Map<String, dynamic> json) => GunaMilan(
        totalPoints: json["total_points"]?.toDouble(),
        maximumPoints: json["maximum_points"]?.toDouble(),
        guna: json["guna"] == null ? [] : List<Guna>.from(json["guna"]!.map((x) => Guna.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_points": totalPoints,
        "maximum_points": maximumPoints,
        "guna": guna == null ? [] : List<dynamic>.from(guna!.map((x) => x.toJson())),
    };
}

class Guna {
    final int? id;
    final String? name;
    final String? girlKoot;
    final String? boyKoot;
    final double? maximumPoints;
    final double? obtainedPoints;
    final String? description;

    Guna({
        this.id,
        this.name,
        this.girlKoot,
        this.boyKoot,
        this.maximumPoints,
        this.obtainedPoints,
        this.description,
    });

    Guna copyWith({
        int? id,
        String? name,
        String? girlKoot,
        String? boyKoot,
        double? maximumPoints,
        double? obtainedPoints,
        String? description,
    }) => 
        Guna(
            id: id ?? this.id,
            name: name ?? this.name,
            girlKoot: girlKoot ?? this.girlKoot,
            boyKoot: boyKoot ?? this.boyKoot,
            maximumPoints: maximumPoints ?? this.maximumPoints,
            obtainedPoints: obtainedPoints ?? this.obtainedPoints,
            description: description ?? this.description,
        );

    factory Guna.fromJson(Map<String, dynamic> json) => Guna(
        id: json["id"],
        name: json["name"],
        girlKoot: json["girl_koot"],
        boyKoot: json["boy_koot"],
        maximumPoints: json["maximum_points"]?.toDouble(),
        obtainedPoints: json["obtained_points"]?.toDouble(),
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "girl_koot": girlKoot,
        "boy_koot": boyKoot,
        "maximum_points": maximumPoints,
        "obtained_points": obtainedPoints,
        "description": description,
    };
}

class Message {
    final String? type;
    final String? description;

    Message({
        this.type,
        this.description,
    });

    Message copyWith({
        String? type,
        String? description,
    }) => 
        Message(
            type: type ?? this.type,
            description: description ?? this.description,
        );

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        type: json["type"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "description": description,
    };
}
