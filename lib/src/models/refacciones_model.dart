// To parse this JSON data, do
//
//     final refacciones = refaccionesFromJson(jsonString);

import 'dart:convert';

List<Refacciones> refaccionesFromJson(String str) => List<Refacciones>.from(json.decode(str).map((x) => Refacciones.fromJson(x)));

String refaccionesToJson(List<Refacciones> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Refacciones {
    Refacciones({
        this.renglon,
        this.articulo,
        this.precio,
        this.compra,
    });

    int? renglon;
    String? articulo;
    double? precio;
    bool? compra;

    factory Refacciones.fromJson(Map<String, dynamic> json) => Refacciones(
        renglon: json["Renglon"] == null ? null : json["Renglon"],
        articulo: json["Articulo"] == null ? null : json["Articulo"],
        precio: json["Precio"] == null ? null : json["Precio"],
        compra: json["Compra"] == null ? null : json["Compra"],
    );

    Map<String, dynamic> toJson() => {
        "Renglon": renglon == null ? null : renglon,
        "Articulo": articulo == null ? null : articulo,
        "Precio": precio == null ? null : precio,
        "Compra": compra == null ? null : compra,
    };
}
