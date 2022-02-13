// To parse this JSON data, do
//
//     final equipoTransporte = equipoTransporteFromJson(jsonString);

import 'dart:convert';

List<EquipoTransporte> equipoTransporteFromJson(String str) =>
    List<EquipoTransporte>.from(
        json.decode(str).map((x) => EquipoTransporte.fromJson(x)));

String equipoTransporteToJson(List<EquipoTransporte> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EquipoTransporte {
  EquipoTransporte({
    this.id,
    this.serie,
    this.articulo,
    this.descripcion1,
    this.observaciones,
    this.responsable,
    this.responsableNombre,
  });

  int? id;
  String? serie;
  String? articulo;
  String? descripcion1;
  dynamic observaciones;
  dynamic responsable;
  String? responsableNombre;

  factory EquipoTransporte.fromJson(Map<String, dynamic> json) =>
      EquipoTransporte(
        id: json["ID"] == null ? "" as int? : json["ID"],
        serie: json["Serie"] == null ? "" : json["Serie"],
        articulo: json["Articulo"] == null ? "" : json["Articulo"],
        descripcion1:
            json["Descripcion1"] == null ? "" : json["Descripcion1"],
        observaciones: json["Observaciones"],
        responsable: json["Responsable"],
        responsableNombre: json["ResponsableNombre"] == null
            ? ""
            : json["ResponsableNombre"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id == null ? null : id,
        "Serie": serie == null ? null : serie,
        "Articulo": articulo == null ? null : articulo,
        "Descripcion1": descripcion1 == null ? null : descripcion1,
        "Observaciones": observaciones,
        "Responsable": responsable,
        "ResponsableNombre":
            responsableNombre == null ? null : responsableNombre,
      };
}
