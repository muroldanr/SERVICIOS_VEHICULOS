// To parse this JSON data, do
//
//     final llantaDetalle = llantaDetalleFromJson(jsonString);

import 'dart:convert';

import 'dart:ffi';

List<LlantaDetalle> llantaDetalleFromJson(String str) =>
    List<LlantaDetalle>.from(
        json.decode(str).map((x) => LlantaDetalle.fromJson(x)));

String llantaDetalleToJson(List<LlantaDetalle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LlantaDetalle {
  LlantaDetalle({
    this.id,
    this.descripcion1,
    this.serie,
    this.posicion,
    this.ultimoCambio,
    this.marca,
    this.tipo,
    this.medida,
    this.llanta,
    this.kmInicial,
    this.ultimaMedicion,
    this.profundidad,
  });

  int? id;
  String? descripcion1;
  String? serie;
  String? posicion;
  DateTime? ultimoCambio;
  String? marca;
  String? tipo;
  String? medida;
  String? llanta;
  int? kmInicial;
  DateTime? ultimaMedicion;
  double? profundidad;

  factory LlantaDetalle.fromJson(Map<dynamic, dynamic> json) => LlantaDetalle(
        id: json["ID"] == null ? "" as int? : json["ID"],
        descripcion1: json["Descripcion1"] == null ? "" : json["Descripcion1"],
        serie: json["Serie"] == null ? "" : json["Serie"],
        posicion: json["Posicion"] == null ? "" : json["Posicion"],
        ultimoCambio: json["UltimoCambio"] == null
            ? "" as DateTime?
            : DateTime.parse(json["UltimoCambio"]),
        marca: json["Marca"] == null ? "" : json["Marca"],
        tipo: json["Tipo"] == null ? "" : json["Tipo"],
        medida: json["Medida"] == null ? "" : json["Medida"],
        llanta: json["Llanta"] == null ? "" : json["Llanta"],
        kmInicial: json["KmInicial"] == null ? 0 : json["KmInicial"],
        ultimaMedicion: json["UltimaMedicion"] == null
            ? null
            : DateTime.parse(json["UltimaMedicion"]),
        profundidad: json["Profundidad"] == null ? "" as double? : json["Profundidad"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id == null ? null : id,
        "Descripcion1": descripcion1 == null ? null : descripcion1,
        "Serie": serie == null ? null : serie,
        "Posicion": posicion == null ? null : posicion,
        "UltimoCambio":
            ultimoCambio == null ? null : ultimoCambio!.toIso8601String(),
        "Marca": marca == null ? null : marca,
        "Tipo": tipo == null ? null : tipo,
        "Medida": medida == null ? null : medida,
        "Llanta": llanta == null ? null : llanta,
        "KmInicial": kmInicial == null ? null : kmInicial,
        "UltimaMedicion":
            ultimaMedicion == null ? null : ultimaMedicion!.toIso8601String(),
        "Profundidad": profundidad == null ? null : profundidad,
      };
}
