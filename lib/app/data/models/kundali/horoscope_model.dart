// To parse this JSON data, do
//
//     final horoscopeModel = horoscopeModelFromJson(jsonString);

import 'dart:convert';

HoroscopeModel horoscopeModelFromJson(String str) => HoroscopeModel.fromJson(json.decode(str));

String horoscopeModelToJson(HoroscopeModel data) => json.encode(data.toJson());

class HoroscopeModel {
    final String? status;
    final Data? data;

    HoroscopeModel({
        this.status,
        this.data,
    });

    HoroscopeModel copyWith({
        String? status,
        Data? data,
    }) => 
        HoroscopeModel(
            status: status ?? this.status,
            data: data ?? this.data,
        );

    factory HoroscopeModel.fromJson(Map<String, dynamic> json) => HoroscopeModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    final DateTime? datetime;
    final List<DailyPrediction>? dailyPredictions;

    Data({
        this.datetime,
        this.dailyPredictions,
    });

    Data copyWith({
        DateTime? datetime,
        List<DailyPrediction>? dailyPredictions,
    }) => 
        Data(
            datetime: datetime ?? this.datetime,
            dailyPredictions: dailyPredictions ?? this.dailyPredictions,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        datetime: json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
        dailyPredictions: json["daily_predictions"] == null ? [] : List<DailyPrediction>.from(json["daily_predictions"]!.map((x) => DailyPrediction.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "datetime": datetime?.toIso8601String(),
        "daily_predictions": dailyPredictions == null ? [] : List<dynamic>.from(dailyPredictions!.map((x) => x.toJson())),
    };
}

class DailyPrediction {
    final Sign? sign;
    final SignInfo? signInfo;
    final List<Prediction>? predictions;
    final List<Aspect>? aspects;
    final List<Transit>? transits;

    DailyPrediction({
        this.sign,
        this.signInfo,
        this.predictions,
        this.aspects,
        this.transits,
    });

    DailyPrediction copyWith({
        Sign? sign,
        SignInfo? signInfo,
        List<Prediction>? predictions,
        List<Aspect>? aspects,
        List<Transit>? transits,
    }) => 
        DailyPrediction(
            sign: sign ?? this.sign,
            signInfo: signInfo ?? this.signInfo,
            predictions: predictions ?? this.predictions,
            aspects: aspects ?? this.aspects,
            transits: transits ?? this.transits,
        );

    factory DailyPrediction.fromJson(Map<String, dynamic> json) => DailyPrediction(
        sign: json["sign"] == null ? null : Sign.fromJson(json["sign"]),
        signInfo: json["sign_info"] == null ? null : SignInfo.fromJson(json["sign_info"]),
        predictions: json["predictions"] == null ? [] : List<Prediction>.from(json["predictions"]!.map((x) => Prediction.fromJson(x))),
        aspects: json["aspects"] == null ? [] : List<Aspect>.from(json["aspects"]!.map((x) => Aspect.fromJson(x))),
        transits: json["transits"] == null ? [] : List<Transit>.from(json["transits"]!.map((x) => Transit.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "sign": sign?.toJson(),
        "sign_info": signInfo?.toJson(),
        "predictions": predictions == null ? [] : List<dynamic>.from(predictions!.map((x) => x.toJson())),
        "aspects": aspects == null ? [] : List<dynamic>.from(aspects!.map((x) => x.toJson())),
        "transits": transits == null ? [] : List<dynamic>.from(transits!.map((x) => x.toJson())),
    };
}

class Aspect {
    final Lord? planetOne;
    final Lord? planetTwo;
    final Lord? aspect;
    final String? effect;

    Aspect({
        this.planetOne,
        this.planetTwo,
        this.aspect,
        this.effect,
    });

    Aspect copyWith({
        Lord? planetOne,
        Lord? planetTwo,
        Lord? aspect,
        String? effect,
    }) => 
        Aspect(
            planetOne: planetOne ?? this.planetOne,
            planetTwo: planetTwo ?? this.planetTwo,
            aspect: aspect ?? this.aspect,
            effect: effect ?? this.effect,
        );

    factory Aspect.fromJson(Map<String, dynamic> json) => Aspect(
        planetOne: json["planet_one"] == null ? null : Lord.fromJson(json["planet_one"]),
        planetTwo: json["planet_two"] == null ? null : Lord.fromJson(json["planet_two"]),
        aspect: json["aspect"] == null ? null : Lord.fromJson(json["aspect"]),
        effect: json["effect"],
    );

    Map<String, dynamic> toJson() => {
        "planet_one": planetOne?.toJson(),
        "planet_two": planetTwo?.toJson(),
        "aspect": aspect?.toJson(),
        "effect": effect,
    };
}

class Lord {
    final int? id;
    final String? name;

    Lord({
        this.id,
        this.name,
    });

    Lord copyWith({
        int? id,
        String? name,
    }) => 
        Lord(
            id: id ?? this.id,
            name: name ?? this.name,
        );

    factory Lord.fromJson(Map<String, dynamic> json) => Lord(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class Prediction {
    final String? type;
    final String? prediction;
    final String? seek;
    final String? challenge;
    final String? insight;

    Prediction({
        this.type,
        this.prediction,
        this.seek,
        this.challenge,
        this.insight,
    });

    Prediction copyWith({
        String? type,
        String? prediction,
        String? seek,
        String? challenge,
        String? insight,
    }) => 
        Prediction(
            type: type ?? this.type,
            prediction: prediction ?? this.prediction,
            seek: seek ?? this.seek,
            challenge: challenge ?? this.challenge,
            insight: insight ?? this.insight,
        );

    factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        type: json["type"],
        prediction: json["prediction"],
        seek: json["seek"],
        challenge: json["challenge"],
        insight: json["insight"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "prediction": prediction,
        "seek": seek,
        "challenge": challenge,
        "insight": insight,
    };
}

class Sign {
    final int? id;
    final String? name;
    final Lord? lord;

    Sign({
        this.id,
        this.name,
        this.lord,
    });

    Sign copyWith({
        int? id,
        String? name,
        Lord? lord,
    }) => 
        Sign(
            id: id ?? this.id,
            name: name ?? this.name,
            lord: lord ?? this.lord,
        );

    factory Sign.fromJson(Map<String, dynamic> json) => Sign(
        id: json["id"],
        name: json["name"],
        lord: json["lord"] == null ? null : Lord.fromJson(json["lord"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lord": lord?.toJson(),
    };
}

class SignInfo {
    final String? modality;
    final String? triplicity;
    final String? quadruplicity;
    final String? unicodeSymbol;
    final String? icon;

    SignInfo({
        this.modality,
        this.triplicity,
        this.quadruplicity,
        this.unicodeSymbol,
        this.icon,
    });

    SignInfo copyWith({
        String? modality,
        String? triplicity,
        String? quadruplicity,
        String? unicodeSymbol,
        String? icon,
    }) => 
        SignInfo(
            modality: modality ?? this.modality,
            triplicity: triplicity ?? this.triplicity,
            quadruplicity: quadruplicity ?? this.quadruplicity,
            unicodeSymbol: unicodeSymbol ?? this.unicodeSymbol,
            icon: icon ?? this.icon,
        );

    factory SignInfo.fromJson(Map<String, dynamic> json) => SignInfo(
        modality: json["modality"],
        triplicity: json["triplicity"],
        quadruplicity: json["quadruplicity"],
        unicodeSymbol: json["unicode_symbol"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "modality": modality,
        "triplicity": triplicity,
        "quadruplicity": quadruplicity,
        "unicode_symbol": unicodeSymbol,
        "icon": icon,
    };
}

class Transit {
    final int? id;
    final String? name;
    final Sign? zodiac;
    final int? houseNumber;
    final bool? isRetrograde;

    Transit({
        this.id,
        this.name,
        this.zodiac,
        this.houseNumber,
        this.isRetrograde,
    });

    Transit copyWith({
        int? id,
        String? name,
        Sign? zodiac,
        int? houseNumber,
        bool? isRetrograde,
    }) => 
        Transit(
            id: id ?? this.id,
            name: name ?? this.name,
            zodiac: zodiac ?? this.zodiac,
            houseNumber: houseNumber ?? this.houseNumber,
            isRetrograde: isRetrograde ?? this.isRetrograde,
        );

    factory Transit.fromJson(Map<String, dynamic> json) => Transit(
        id: json["id"],
        name: json["name"],
        zodiac: json["zodiac"] == null ? null : Sign.fromJson(json["zodiac"]),
        houseNumber: json["house_number"],
        isRetrograde: json["is_retrograde"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "zodiac": zodiac?.toJson(),
        "house_number": houseNumber,
        "is_retrograde": isRetrograde,
    };
}
