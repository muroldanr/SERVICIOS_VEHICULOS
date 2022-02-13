// To parse this JSON data, do
//
//     final proveedor = proveedorFromJson(jsonString);

import 'dart:convert';

List<Proveedor> proveedorFromJson(String str) =>
    List<Proveedor>.from(json.decode(str).map((x) => Proveedor.fromJson(x)));

String proveedorToJson(List<Proveedor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Proveedor {
  Proveedor({
    this.proveedor,
    this.nombre,
  });

  String? proveedor;
  String? nombre;

  factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        proveedor: json["Proveedor"] == null ? null : json["Proveedor"],
        nombre: json["Nombre"] == null ? null : json["Nombre"],
      );

  Map<String, dynamic> toJson() => {
        "Proveedor": proveedor == null ? null : proveedor,
        "Nombre": nombre == null ? null : nombre,
      };
}
