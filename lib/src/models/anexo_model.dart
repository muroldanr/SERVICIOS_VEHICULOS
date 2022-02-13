// To parse this JSON data, do
//
//     final anexo = anexoFromJson(jsonString);

import 'dart:convert';

List<Anexo> anexoFromJson(String str) =>
    List<Anexo>.from(json.decode(str).map((x) => Anexo.fromJson(x)));

String anexoToJson(List<Anexo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Anexo {
  Anexo({
    this.rama,
    this.id,
    this.idr,
    this.nombre,
    this.direccion,
    this.icono,
    this.tipo,
    this.comentario,
    this.sucursal,
    this.cfd,
    this.binFile,
  });

  String? rama;
  int? id;
  int? idr;
  String? nombre;
  String? direccion;
  int? icono;
  String? tipo;
  dynamic comentario;
  int? sucursal;
  bool? cfd;
  String? binFile;

  factory Anexo.fromJson(Map<String, dynamic> json) => Anexo(
        rama: json["Rama"] == null ? null : json["Rama"],
        id: json["ID"] == null ? null : json["ID"],
        idr: json["IDR"] == null ? null : json["IDR"],
        nombre: json["Nombre"] == null ? null : json["Nombre"],
        direccion: json["Direccion"] == null ? null : json["Direccion"],
        icono: json["Icono"] == null ? null : json["Icono"],
        tipo: json["Tipo"] == null ? null : json["Tipo"],
        comentario: json["Comentario"],
        sucursal: json["Sucursal"] == null ? null : json["Sucursal"],
        cfd: json["CFD"] == null ? null : json["CFD"],
        binFile: json["binFile"] == null ? null : json["binFile"],
      );

  Map<String, dynamic> toJson() => {
        "Rama": rama == null ? null : rama,
        "ID": id == null ? null : id,
        "IDR": idr == null ? null : idr,
        "Nombre": nombre == null ? null : nombre,
        "Direccion": direccion == null ? null : direccion,
        "Icono": icono == null ? null : icono,
        "Tipo": tipo == null ? null : tipo,
        "Comentario": comentario,
        "Sucursal": sucursal == null ? null : sucursal,
        "CFD": cfd == null ? null : cfd,
        "binFile": binFile == null ? null : binFile,
      };
}
