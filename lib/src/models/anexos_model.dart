// To parse this JSON data, do
//
//     final anexos = anexosFromJson(jsonString);

import 'dart:convert';

List<Anexos> anexosFromJson(String str) =>
    List<Anexos>.from(json.decode(str).map((x) => Anexos.fromJson(x)));

String anexosToJson(List<Anexos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Anexos {
  Anexos({
    this.categoria,
    this.descripcion,
    this.nombre,
    this.direccion,
  });

  String? categoria;
  String? descripcion;
  String? nombre;
  String? direccion;

  factory Anexos.fromJson(Map<String, dynamic> json) => Anexos(
        categoria: json["Categoria"] == null ? null : json["Categoria"],
        descripcion: json["Descripcion"] == null ? null : json["Descripcion"],
        nombre: json["Nombre"] == null ? null : json["Nombre"],
        direccion: json["Direccion"] == null ? null : json["Direccion"],
      );

  Map<String, dynamic> toJson() => {
        "Categoria": categoria == null ? null : categoria,
        "Descripcion": descripcion == null ? null : descripcion,
        "Nombre": nombre == null ? null : nombre,
        "Direccion": direccion == null ? null : direccion,
      };
}
