// To parse this JSON data, do
//
//     final llantasDisponibles = llantasDisponiblesFromJson(jsonString);

import 'dart:convert';

List<LlantasDisponibles> llantasDisponiblesFromJson(String str) =>
    List<LlantasDisponibles>.from(
        json.decode(str).map((x) => LlantasDisponibles.fromJson(x)));

String llantasDisponiblesToJson(List<LlantasDisponibles> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LlantasDisponibles {
  LlantasDisponibles({
    this.llanta,
    this.modelo,
    this.marca,
    this.medida,
    this.estado,
  });

  String? llanta;
  String? modelo;
  String? marca;
  String? medida;
  String? estado;

  factory LlantasDisponibles.fromJson(Map<String, dynamic> json) =>
      LlantasDisponibles(
        llanta: json["Llanta"] == null ? 'null' : json["Llanta"],
        modelo: json["Modelo"] == null ? 'null' : json["Modelo"],
        marca: json["Marca"] == null ? 'null' : json["Marca"],
        medida: json["Medida"] == null ? 'null' : json["Medida"],
        estado: json["Estado"] == null ? 'null' : json["Estado"],
      );

  Map<String, dynamic> toJson() => {
        "Llanta": llanta == null ? null : llanta,
        "Modelo": modelo == null ? null : modelo,
        "Marca": marca == null ? null : marca,
        "Medida": medida == null ? null : medida,
        "Estado": estado == null ? null : estado,
      };
}
