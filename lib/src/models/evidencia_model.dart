// To parse this JSON data, do
//
//     final evidencia = evidenciaFromJson(jsonString);

import 'dart:convert';

List<Evidencia> evidenciaFromJson(String str) =>
    List<Evidencia>.from(json.decode(str).map((x) => Evidencia.fromJson(x)));

String evidenciaToJson(List<Evidencia> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Evidencia {
  Evidencia({
    this.id,
    this.renglon,
    this.concepto,
    this.categoria,
    this.categoriaDesc,
    this.valor,
    this.comentarios,
    this.tieneAnexo,
  });

  int? id;
  int? renglon;
  String? concepto;
  String? categoria;
  String? categoriaDesc;
  String? valor;
  String? comentarios;
  bool? tieneAnexo;

  factory Evidencia.fromJson(Map<String, dynamic> json) => Evidencia(
        id: json["ID"] == null ? "" as int? : json["ID"],
        renglon: json["Renglon"] == null ? "" as int? : json["Renglon"],
        concepto: json["Concepto"] == null ? "" : json["Concepto"],
        categoria: json["Categoria"] == null ? "" : json["Categoria"],
        categoriaDesc:
            json["CategoriaDesc"] == null ? "" : json["CategoriaDesc"],
        valor: json["Valor"] == null ? "" : json["Valor"],
        comentarios: json["Comentarios"] == null ? "" : json["Comentarios"],
        tieneAnexo: json["TieneAnexo"] == null ? false : json["TieneAnexo"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id == null ? null : id,
        "Renglon": renglon == null ? null : renglon,
        "Concepto": concepto == null ? null : concepto,
        "Categoria": categoria == null ? null : categoria,
        "CategoriaDesc": categoriaDesc == null ? null : categoriaDesc,
        "Valor": valor == null ? null : valor,
        "Comentarios": comentarios == null ? null : comentarios,
        "TieneAnexo": comentarios == null ? false : tieneAnexo,
      };
}
