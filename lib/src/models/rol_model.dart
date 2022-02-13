// To parse this JSON data, do
//
//     final rol = rolFromJson(jsonString);

import 'dart:convert';

List<Rol> rolFromJson(String str) =>
    List<Rol>.from(json.decode(str).map((x) => Rol.fromJson(x)));

String rolToJson(List<Rol> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rol {
  Rol({
    this.levantar,
    this.procesar,
    this.afectar,
    this.consultar,
    this.lLantas,
    this.autorizar,
  });

  bool? levantar;
  bool? procesar;
  bool? afectar;
  bool? consultar;
  bool? lLantas;
  bool? autorizar;

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
        levantar: json["Levantar"] == null ? false : json["Levantar"],
        procesar: json["Procesar"] == null ? false : json["Procesar"],
        afectar: json["Afectar"] == null ? false : json["Afectar"],
        consultar: json["Consultar"] == null ? false : json["Consultar"],
        lLantas: json["LLantas"] == null ? false : json["LLantas"],
        autorizar: json["Autorizar"] == null ? false : json["Autorizar"],
      );

  Map<String, dynamic> toJson() => {
        "Levantar": levantar == null ? null : levantar,
        "Procesar": procesar == null ? null : procesar,
        "Afectar": afectar == null ? null : afectar,
        "Consultar": consultar == null ? null : consultar,
        "LLantas": lLantas == null ? null : lLantas,
        "Autorizar": autorizar == null ? null : autorizar,
      };
}
