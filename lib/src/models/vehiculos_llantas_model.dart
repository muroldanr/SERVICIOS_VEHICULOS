// To parse this JSON data, do
//
//     final vehiculosLlantas = vehiculosLlantasFromJson(jsonString);

import 'dart:convert';

List<VehiculosLlantas> vehiculosLlantasFromJson(String str) =>
    List<VehiculosLlantas>.from(
        json.decode(str).map((x) => VehiculosLlantas.fromJson(x)));

String vehiculosLlantasToJson(List<VehiculosLlantas> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehiculosLlantas {
  VehiculosLlantas({
    this.id,
    this.serie,
    this.articulo,
    this.descripcion1,
    this.observaciones,
    this.posicion,
    this.marca,
    this.llanta,
    this.fechaCambio,
  });

  int? id;
  String? serie;
  String? articulo;
  String? descripcion1;
  dynamic observaciones;
  String? posicion;
  String? marca;
  int? llanta;
  dynamic fechaCambio;

  factory VehiculosLlantas.fromJson(Map<String, dynamic> json) =>
      VehiculosLlantas(
        id: json["ID"] == null ? null : json["ID"],
        serie: json["Serie"] == null ? null : json["Serie"],
        articulo: json["Articulo"] == null ? null : json["Articulo"],
        descripcion1:
            json["Descripcion1"] == null ? null : json["Descripcion1"],
        observaciones: json["Observaciones"],
        posicion: json["Posicion"] == null ? null : json["Posicion"],
        marca: json["Marca"] == null ? null : json["Marca"],
        llanta: json["Llanta"] == null ? null : json["Llanta"],
        fechaCambio: json["FechaCambio"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id == null ? null : id,
        "Serie": serie == null ? null : serie,
        "Articulo": articulo == null ? null : articulo,
        "Descripcion1": descripcion1 == null ? null : descripcion1,
        "Observaciones": observaciones,
        "Posicion": posicion == null ? null : posicion,
        "Marca": marca == null ? null : marca,
        "Llanta": llanta == null ? null : llanta,
        "FechaCambio": fechaCambio,
      };
}
