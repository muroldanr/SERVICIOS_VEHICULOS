// To parse this JSON data, do
//
//     final llantaPlantilla = llantaPlantillaFromJson(jsonString);

import 'dart:convert';

List<LlantaPlantilla> llantaPlantillaFromJson(String str) =>
    List<LlantaPlantilla>.from(
        json.decode(str).map((x) => LlantaPlantilla.fromJson(x)));

String llantaPlantillaToJson(List<LlantaPlantilla> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LlantaPlantilla {
  LlantaPlantilla({
    this.eje,
    this.izqExt,
    this.izqInt,
    this.derInt,
    this.derExt,
  });

  int? eje;
  String? izqExt;
  String? izqInt;
  String? derInt;
  String? derExt;

  factory LlantaPlantilla.fromJson(Map<String, dynamic> json) =>
      LlantaPlantilla(
        eje: json["Eje"] == null ? null : json["Eje"],
        izqExt: json["IzqExt"],
        izqInt: json["IzqInt"] == null ? null : json["IzqInt"],
        derInt: json["DerInt"] == null ? null : json["DerInt"],
        derExt: json["DerExt"],
      );

  Map<String, dynamic> toJson() => {
        "Eje": eje == null ? null : eje,
        "IzqExt": izqExt,
        "IzqInt": izqInt == null ? null : izqInt,
        "DerInt": derInt == null ? null : derInt,
        "DerExt": derExt,
      };
}
