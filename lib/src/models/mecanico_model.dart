// To parse this JSON data, do
//
//     final mecanico = mecanicoFromJson(jsonString);

import 'dart:convert';

List<Mecanico> mecanicoFromJson(String str) =>
    List<Mecanico>.from(json.decode(str).map((x) => Mecanico.fromJson(x)));

String mecanicoToJson(List<Mecanico> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mecanico {
  Mecanico({
    this.agente,
    this.nombre,
  });

  String? agente;
  String? nombre;

  factory Mecanico.fromJson(Map<String, dynamic> json) => Mecanico(
        agente: json["Agente"] == null ? null : json["Agente"],
        nombre: json["Nombre"] == null ? null : json["Nombre"],
      );

  Map<String, dynamic> toJson() => {
        "Agente": agente == null ? null : agente,
        "Nombre": nombre == null ? null : nombre,
      };
}
