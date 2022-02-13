// To parse this JSON data, do
//
//     final llantaDetalleLista = llantaDetalleListaFromJson(jsonString);

import 'dart:convert';

List<LlantaDetalleLista> llantaDetalleListaFromJson(String str) =>
    List<LlantaDetalleLista>.from(
        json.decode(str).map((x) => LlantaDetalleLista.fromJson(x)));

String llantaDetalleListaToJson(List<LlantaDetalleLista> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LlantaDetalleLista {
  LlantaDetalleLista({
    this.id,
    this.serie,
    this.articulo,
    this.descripcion1,
    this.observaciones,
    this.llanta,
    this.tipo,
    this.marca,
    this.medida,
    this.estado,
    this.posicion,
    this.kilometros,
    this.profundidad,
    this.presion,
    this.ultimoCambio,
    this.fechaCambio,
  });

  int? id;
  String? serie;
  String? articulo;
  dynamic descripcion1;
  String? observaciones;
  String? llanta;
  String? tipo;
  String? marca;
  String? medida;
  String? estado;
  String? posicion;
  int? kilometros;
  double? profundidad;
  double? presion;
  DateTime? ultimoCambio;
  DateTime? fechaCambio;

  factory LlantaDetalleLista.fromJson(Map<String, dynamic> json) =>
      LlantaDetalleLista(
        id: json["ID"] == null ? null : json["ID"],
        serie: json["Serie"] == null ? null : json["Serie"],
        articulo: json["Articulo"] == null ? null : json["Articulo"],
        descripcion1: json["Descripcion1"],
        observaciones:
            json["Observaciones"] == null ? null : json["Observaciones"],
        llanta: json["Llanta"] == null ? null : json["Llanta"],
        tipo: json["Tipo"] == null ? null : json["Tipo"],
        marca: json["Marca"] == null ? null : json["Marca"],
        medida: json["Medida"] == null ? null : json["Medida"],
        estado: json["Estado"] == null ? null : json["Estado"],
        posicion: json["Posicion"] == null ? null : json["Posicion"],
        kilometros: json["Kilometros"] == null ? null : json["Kilometros"],
        profundidad: json["Profundidad"] == null ? null : json["Profundidad"],
        presion: json["Presion"] == null ? null : json["Presion"],
        ultimoCambio: json["UltimoCambio"] == null
            ? null
            : DateTime.parse(json["UltimoCambio"]),
        fechaCambio: json["FechaCambio"] == null
            ? null
            : DateTime.parse(json["FechaCambio"]),
      );

  Map<String, dynamic> toJson() => {
        "ID": id == null ? null : id,
        "Serie": serie == null ? null : serie,
        "Articulo": articulo == null ? null : articulo,
        "Descripcion1": descripcion1,
        "Observaciones": observaciones == null ? null : observaciones,
        "Llanta": llanta == null ? null : llanta,
        "Tipo": tipo == null ? null : tipo,
        "Marca": marca == null ? null : marca,
        "Medida": medida == null ? null : medida,
        "Estado": estado == null ? null : estado,
        "Posicion": posicion == null ? null : posicion,
        "Kilometros": kilometros == null ? null : kilometros,
        "Profundidad": profundidad == null ? null : profundidad,
        "Presion": presion == null ? null : presion,
        "UltimoCambio":
            ultimoCambio == null ? null : ultimoCambio!.toIso8601String(),
        "FechaCambio":
            fechaCambio == null ? null : fechaCambio!.toIso8601String(),
      };
}
