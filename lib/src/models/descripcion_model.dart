// To parse this JSON data, do
//
//     final descripcion = descripcionFromJson(jsonString);

import 'dart:convert';

List<Descripcion> descripcionFromJson(String str) => List<Descripcion>.from(json.decode(str).map((x) => Descripcion.fromJson(x)));

String descripcionToJson(List<Descripcion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Descripcion {
    Descripcion({
        this.descripcion,
        this.origenCausa,
        this.sistemaOrigen,
        this.refacciones,
    });

    String? descripcion;
    String? origenCausa;
    String? sistemaOrigen;
    String? refacciones;

    factory Descripcion.fromJson(Map<String, dynamic> json) => Descripcion(
        descripcion: json["Descripcion"] == null ? null : json["Descripcion"],
        origenCausa: json["OrigenCausa"] == null ? null : json["OrigenCausa"],
        sistemaOrigen: json["SistemaOrigen"] == null ? null : json["SistemaOrigen"],
        refacciones: json["Refacciones"] == null ? null : json["Refacciones"],
    );

    Map<String, dynamic> toJson() => {
        "Descripcion": descripcion == null ? null : descripcion,
        "OrigenCausa": origenCausa == null ? null : origenCausa,
        "SistemaOrigen": sistemaOrigen == null ? null : sistemaOrigen,
        "Refacciones": refacciones == null ? null : refacciones,
    };
}
