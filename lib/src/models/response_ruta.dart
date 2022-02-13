// To parse this JSON data, do
//
//     final responseRuta = responseRutaFromJson(jsonString);

import 'dart:convert';

List<ResponseRuta> responseRutaFromJson(String str) => List<ResponseRuta>.from(
    json.decode(str).map((x) => ResponseRuta.fromJson(x)));

String responseRutaToJson(List<ResponseRuta> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponseRuta {
  ResponseRuta({
    this.ok,
    this.okRef,
    this.ruta,
  });

  dynamic ok;
  dynamic okRef;
  String? ruta;

  factory ResponseRuta.fromJson(Map<String, dynamic> json) => ResponseRuta(
        ok: json["Ok"],
        okRef: json["OkRef"],
        ruta: json["Ruta"] == null ? null : json["Ruta"],
      );

  Map<String, dynamic> toJson() => {
        "Ok": ok,
        "OkRef": okRef,
        "Ruta": ruta == null ? null : ruta,
      };
}
