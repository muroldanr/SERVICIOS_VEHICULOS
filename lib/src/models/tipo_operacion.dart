// To parse this JSON data, do
//
//     final tipoOperacion = tipoOperacionFromJson(jsonString);

import 'dart:convert';

List<TipoOperacion> tipoOperacionFromJson(String str) =>
    List<TipoOperacion>.from(
        json.decode(str).map((x) => TipoOperacion.fromJson(x)));

String tipoOperacionToJson(List<TipoOperacion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TipoOperacion {
  TipoOperacion({
    this.tipoOperacion,
  });

  String? tipoOperacion;

  factory TipoOperacion.fromJson(Map<String, dynamic> json) => TipoOperacion(
        tipoOperacion:
            json["TipoOperacion"] == null ? null : json["TipoOperacion"],
      );

  Map<String, dynamic> toJson() => {
        "TipoOperacion": tipoOperacion == null ? null : tipoOperacion,
      };
}
