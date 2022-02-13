// To parse this JSON data, do
//
//     final response = responseFromJson(jsonString);

import 'dart:convert';

List<Response> responseFromJson(String str) =>
    List<Response>.from(json.decode(str).map((x) => Response.fromJson(x)));

Response responseFromJsonOne(String str) => Response.fromJson(json.decode(str));

String responseToJson(List<Response> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Response {
  Response(
      {this.ok,
      this.okRef,
      this.ordenGenerada,
      this.moduloId,
      this.ruta,
      this.archivo,
      this.mensaje});

  dynamic ok;
  dynamic okRef;
  String? ordenGenerada;
  int? moduloId;
  dynamic ruta;
  String? archivo;
  String? mensaje;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        ok: json["Ok"] == null ? "null" : json["Ok"],
        okRef: json["OkRef"],
        ordenGenerada:
            json["OrdenGenerada"] == "" ? null : json["OrdenGenerada"],
        moduloId: json["ModuloID"] == null ? 0 : json["ModuloID"],
        ruta: json["Ruta"] == null ? "" : json["Ruta"],
        archivo: json["Archivo"] == null ? null : json["Archivo"],
        mensaje: json["Mensaje"] == null ? "" : json["Mensaje"],
      );

  Map<String, dynamic> toJson() => {
        "Ok": ok,
        "OkRef": okRef,
        "OrdenGenerada": ordenGenerada == null ? null : ordenGenerada,
        "ModuloID": moduloId == null ? null : moduloId,
        "Ruta": ruta == null ? null : ruta,
        "Archivo": archivo == null ? null : archivo,
        "Mensaje": mensaje == null ? null : mensaje,
      };
}
