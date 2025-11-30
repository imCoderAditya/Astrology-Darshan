// To parse this JSON data, do
//
//     final kundaliModel = kundaliModelFromJson(jsonString);

import 'dart:convert';

KundaliModel kundaliModelFromJson(String str) =>
    KundaliModel.fromJson(json.decode(str));

String kundaliModelToJson(KundaliModel data) => json.encode(data.toJson());

class KundaliModel {
  final String? name;
  final KundliData? kundliData;

  KundaliModel({this.name, this.kundliData});

  KundaliModel copyWith({String? name, KundliData? kundliData}) => KundaliModel(
    name: name ?? this.name,
    kundliData: kundliData ?? this.kundliData,
  );

  factory KundaliModel.fromJson(Map<String, dynamic> json) => KundaliModel(
    name: json["name"],
    kundliData:
        json["kundliData"] == null
            ? null
            : KundliData.fromJson(json["kundliData"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "kundliData": kundliData?.toJson(),
  };
}

class KundliData {
  final String? status;
  final Data? data;

  KundliData({this.status, this.data});

  KundliData copyWith({String? status, Data? data}) =>
      KundliData(status: status ?? this.status, data: data ?? this.data);

  factory KundliData.fromJson(Map<String, dynamic> json) => KundliData(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  final NakshatraDetails? nakshatraDetails;
  final MangalDosha? mangalDosha;
  final List<YogaDetail>? yogaDetails;
  final List<DashaPeriod>? dashaPeriods;
  final DashaBalance? dashaBalance;

  Data({
    this.nakshatraDetails,
    this.mangalDosha,
    this.yogaDetails,
    this.dashaPeriods,
    this.dashaBalance,
  });

  Data copyWith({
    NakshatraDetails? nakshatraDetails,
    MangalDosha? mangalDosha,
    List<YogaDetail>? yogaDetails,
    List<DashaPeriod>? dashaPeriods,
    DashaBalance? dashaBalance,
  }) => Data(
    nakshatraDetails: nakshatraDetails ?? this.nakshatraDetails,
    mangalDosha: mangalDosha ?? this.mangalDosha,
    yogaDetails: yogaDetails ?? this.yogaDetails,
    dashaPeriods: dashaPeriods ?? this.dashaPeriods,
    dashaBalance: dashaBalance ?? this.dashaBalance,
  );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    nakshatraDetails:
        json["nakshatra_details"] == null
            ? null
            : NakshatraDetails.fromJson(json["nakshatra_details"]),
    mangalDosha:
        json["mangal_dosha"] == null
            ? null
            : MangalDosha.fromJson(json["mangal_dosha"]),
    yogaDetails:
        json["yoga_details"] == null
            ? []
            : List<YogaDetail>.from(
              json["yoga_details"]!.map((x) => YogaDetail.fromJson(x)),
            ),
    dashaPeriods:
        json["dasha_periods"] == null
            ? []
            : List<DashaPeriod>.from(
              json["dasha_periods"]!.map((x) => DashaPeriod.fromJson(x)),
            ),
    dashaBalance:
        json["dasha_balance"] == null
            ? null
            : DashaBalance.fromJson(json["dasha_balance"]),
  );

  Map<String, dynamic> toJson() => {
    "nakshatra_details": nakshatraDetails?.toJson(),
    "mangal_dosha": mangalDosha?.toJson(),
    "yoga_details":
        yogaDetails == null
            ? []
            : List<dynamic>.from(yogaDetails!.map((x) => x.toJson())),
    "dasha_periods":
        dashaPeriods == null
            ? []
            : List<dynamic>.from(dashaPeriods!.map((x) => x.toJson())),
    "dasha_balance": dashaBalance?.toJson(),
  };
}

class DashaBalance {
  final Lord? lord;
  final String? duration;
  final String? description;

  DashaBalance({this.lord, this.duration, this.description});

  DashaBalance copyWith({Lord? lord, String? duration, String? description}) =>
      DashaBalance(
        lord: lord ?? this.lord,
        duration: duration ?? this.duration,
        description: description ?? this.description,
      );

  factory DashaBalance.fromJson(Map<String, dynamic> json) => DashaBalance(
    lord: json["lord"] == null ? null : Lord.fromJson(json["lord"]),
    duration: json["duration"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "lord": lord?.toJson(),
    "duration": duration,
    "description": description,
  };
}

class Lord {
  final int? id;
  final String? name;
  final String? vedicName;

  Lord({this.id, this.name, this.vedicName});

  Lord copyWith({int? id, String? name, String? vedicName}) => Lord(
    id: id ?? this.id,
    name: name ?? this.name,
    vedicName: vedicName ?? this.vedicName,
  );

  factory Lord.fromJson(Map<String, dynamic> json) =>
      Lord(id: json["id"], name: json["name"]!, vedicName: json["vedic_name"]!);

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "vedic_name": vedicName,
  };
}

class DashaPeriod {
  final int? id;
  final String? name;
  final DateTime? start;
  final DateTime? end;
  final List<DashaPeriod>? antardasha;
  final List<DashaPeriod>? pratyantardasha;

  DashaPeriod({
    this.id,
    this.name,
    this.start,
    this.end,
    this.antardasha,
    this.pratyantardasha,
  });

  DashaPeriod copyWith({
    int? id,
    String? name,
    DateTime? start,
    DateTime? end,
    List<DashaPeriod>? antardasha,
    List<DashaPeriod>? pratyantardasha,
  }) => DashaPeriod(
    id: id ?? this.id,
    name: name ?? this.name,
    start: start ?? this.start,
    end: end ?? this.end,
    antardasha: antardasha ?? this.antardasha,
    pratyantardasha: pratyantardasha ?? this.pratyantardasha,
  );

  factory DashaPeriod.fromJson(Map<String, dynamic> json) => DashaPeriod(
    id: json["id"],
    name: json["name"]!,
    start: json["start"] == null ? null : DateTime.parse(json["start"]),
    end: json["end"] == null ? null : DateTime.parse(json["end"]),
    antardasha:
        json["antardasha"] == null
            ? []
            : List<DashaPeriod>.from(
              json["antardasha"]!.map((x) => DashaPeriod.fromJson(x)),
            ),
    pratyantardasha:
        json["pratyantardasha"] == null
            ? []
            : List<DashaPeriod>.from(
              json["pratyantardasha"]!.map((x) => DashaPeriod.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "start": start?.toIso8601String(),
    "end": end?.toIso8601String(),
    "antardasha":
        antardasha == null
            ? []
            : List<dynamic>.from(antardasha!.map((x) => x.toJson())),
    "pratyantardasha":
        pratyantardasha == null
            ? []
            : List<dynamic>.from(pratyantardasha!.map((x) => x.toJson())),
  };
}

class MangalDosha {
  final bool? hasDosha;
  final String? description;
  final bool? hasException;
  final dynamic type;
  final List<dynamic>? exceptions;
  final List<dynamic>? remedies;

  MangalDosha({
    this.hasDosha,
    this.description,
    this.hasException,
    this.type,
    this.exceptions,
    this.remedies,
  });

  MangalDosha copyWith({
    bool? hasDosha,
    String? description,
    bool? hasException,
    dynamic type,
    List<dynamic>? exceptions,
    List<dynamic>? remedies,
  }) => MangalDosha(
    hasDosha: hasDosha ?? this.hasDosha,
    description: description ?? this.description,
    hasException: hasException ?? this.hasException,
    type: type ?? this.type,
    exceptions: exceptions ?? this.exceptions,
    remedies: remedies ?? this.remedies,
  );

  factory MangalDosha.fromJson(Map<String, dynamic> json) => MangalDosha(
    hasDosha: json["has_dosha"],
    description: json["description"],
    hasException: json["has_exception"],
    type: json["type"],
    exceptions:
        json["exceptions"] == null
            ? []
            : List<dynamic>.from(json["exceptions"]!.map((x) => x)),
    remedies:
        json["remedies"] == null
            ? []
            : List<dynamic>.from(json["remedies"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "has_dosha": hasDosha,
    "description": description,
    "has_exception": hasException,
    "type": type,
    "exceptions":
        exceptions == null ? [] : List<dynamic>.from(exceptions!.map((x) => x)),
    "remedies":
        remedies == null ? [] : List<dynamic>.from(remedies!.map((x) => x)),
  };
}

class NakshatraDetails {
  final ChandraRasi? nakshatra;
  final ChandraRasi? chandraRasi;
  final ChandraRasi? sooryaRasi;
  final Zodiac? zodiac;
  final AdditionalInfo? additionalInfo;

  NakshatraDetails({
    this.nakshatra,
    this.chandraRasi,
    this.sooryaRasi,
    this.zodiac,
    this.additionalInfo,
  });

  NakshatraDetails copyWith({
    ChandraRasi? nakshatra,
    ChandraRasi? chandraRasi,
    ChandraRasi? sooryaRasi,
    Zodiac? zodiac,
    AdditionalInfo? additionalInfo,
  }) => NakshatraDetails(
    nakshatra: nakshatra ?? this.nakshatra,
    chandraRasi: chandraRasi ?? this.chandraRasi,
    sooryaRasi: sooryaRasi ?? this.sooryaRasi,
    zodiac: zodiac ?? this.zodiac,
    additionalInfo: additionalInfo ?? this.additionalInfo,
  );

  factory NakshatraDetails.fromJson(Map<String, dynamic> json) =>
      NakshatraDetails(
        nakshatra:
            json["nakshatra"] == null
                ? null
                : ChandraRasi.fromJson(json["nakshatra"]),
        chandraRasi:
            json["chandra_rasi"] == null
                ? null
                : ChandraRasi.fromJson(json["chandra_rasi"]),
        sooryaRasi:
            json["soorya_rasi"] == null
                ? null
                : ChandraRasi.fromJson(json["soorya_rasi"]),
        zodiac: json["zodiac"] == null ? null : Zodiac.fromJson(json["zodiac"]),
        additionalInfo:
            json["additional_info"] == null
                ? null
                : AdditionalInfo.fromJson(json["additional_info"]),
      );

  Map<String, dynamic> toJson() => {
    "nakshatra": nakshatra?.toJson(),
    "chandra_rasi": chandraRasi?.toJson(),
    "soorya_rasi": sooryaRasi?.toJson(),
    "zodiac": zodiac?.toJson(),
    "additional_info": additionalInfo?.toJson(),
  };
}

class AdditionalInfo {
  final String? deity;
  final String? ganam;
  final String? symbol;
  final String? animalSign;
  final String? nadi;
  final String? color;
  final String? bestDirection;
  final String? syllables;
  final String? birthStone;
  final String? gender;
  final String? planet;
  final String? enemyYoni;

  AdditionalInfo({
    this.deity,
    this.ganam,
    this.symbol,
    this.animalSign,
    this.nadi,
    this.color,
    this.bestDirection,
    this.syllables,
    this.birthStone,
    this.gender,
    this.planet,
    this.enemyYoni,
  });

  AdditionalInfo copyWith({
    String? deity,
    String? ganam,
    String? symbol,
    String? animalSign,
    String? nadi,
    String? color,
    String? bestDirection,
    String? syllables,
    String? birthStone,
    String? gender,
    String? planet,
    String? enemyYoni,
  }) => AdditionalInfo(
    deity: deity ?? this.deity,
    ganam: ganam ?? this.ganam,
    symbol: symbol ?? this.symbol,
    animalSign: animalSign ?? this.animalSign,
    nadi: nadi ?? this.nadi,
    color: color ?? this.color,
    bestDirection: bestDirection ?? this.bestDirection,
    syllables: syllables ?? this.syllables,
    birthStone: birthStone ?? this.birthStone,
    gender: gender ?? this.gender,
    planet: planet ?? this.planet,
    enemyYoni: enemyYoni ?? this.enemyYoni,
  );

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
    deity: json["deity"],
    ganam: json["ganam"],
    symbol: json["symbol"],
    animalSign: json["animal_sign"],
    nadi: json["nadi"],
    color: json["color"],
    bestDirection: json["best_direction"],
    syllables: json["syllables"],
    birthStone: json["birth_stone"],
    gender: json["gender"],
    planet: json["planet"]!,
    enemyYoni: json["enemy_yoni"],
  );

  Map<String, dynamic> toJson() => {
    "deity": deity,
    "ganam": ganam,
    "symbol": symbol,
    "animal_sign": animalSign,
    "nadi": nadi,
    "color": color,
    "best_direction": bestDirection,
    "syllables": syllables,
    "birth_stone": birthStone,
    "gender": gender,
    "planet": planet,
    "enemy_yoni": enemyYoni,
  };
}

class ChandraRasi {
  final int? id;
  final String? name;
  final Lord? lord;
  final int? pada;

  ChandraRasi({this.id, this.name, this.lord, this.pada});

  ChandraRasi copyWith({int? id, String? name, Lord? lord, int? pada}) =>
      ChandraRasi(
        id: id ?? this.id,
        name: name ?? this.name,
        lord: lord ?? this.lord,
        pada: pada ?? this.pada,
      );

  factory ChandraRasi.fromJson(Map<String, dynamic> json) => ChandraRasi(
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

class Zodiac {
  final int? id;
  final String? name;

  Zodiac({this.id, this.name});

  Zodiac copyWith({int? id, String? name}) =>
      Zodiac(id: id ?? this.id, name: name ?? this.name);

  factory Zodiac.fromJson(Map<String, dynamic> json) =>
      Zodiac(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class YogaDetail {
  final String? name;
  final String? description;
  final List<YogaList>? yogaList;

  YogaDetail({this.name, this.description, this.yogaList});

  YogaDetail copyWith({
    String? name,
    String? description,
    List<YogaList>? yogaList,
  }) => YogaDetail(
    name: name ?? this.name,
    description: description ?? this.description,
    yogaList: yogaList ?? this.yogaList,
  );

  factory YogaDetail.fromJson(Map<String, dynamic> json) => YogaDetail(
    name: json["name"],
    description: json["description"],
    yogaList:
        json["yoga_list"] == null
            ? []
            : List<YogaList>.from(
              json["yoga_list"]!.map((x) => YogaList.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "yoga_list":
        yogaList == null
            ? []
            : List<dynamic>.from(yogaList!.map((x) => x.toJson())),
  };
}

class YogaList {
  final String? name;
  final bool? hasYoga;
  final String? description;

  YogaList({this.name, this.hasYoga, this.description});

  YogaList copyWith({String? name, bool? hasYoga, String? description}) =>
      YogaList(
        name: name ?? this.name,
        hasYoga: hasYoga ?? this.hasYoga,
        description: description ?? this.description,
      );

  factory YogaList.fromJson(Map<String, dynamic> json) => YogaList(
    name: json["name"],
    hasYoga: json["has_yoga"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "has_yoga": hasYoga,
    "description": description,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
