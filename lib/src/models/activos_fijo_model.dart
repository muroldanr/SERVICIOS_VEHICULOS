import 'dart:convert';

List<ActivosFijos> activosFijosFromJson(String str) => List<ActivosFijos>.from(json.decode(str).map((x) => ActivosFijos.fromJson(x)));

String activosFijosToJson(List<ActivosFijos> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ActivosFijos {
    ActivosFijos({
        this.serie,
        this.articulo,
        this.descripcion1,
        this.categoria,
        this.observaciones,
        this.responsable,
        this.responsableNombre,
    });

    String? serie;
    String? articulo;
    String? descripcion1;
    String? categoria;
    String? observaciones;
    String? responsable;
    String? responsableNombre;

    factory ActivosFijos.fromJson(Map<String, dynamic> json) => ActivosFijos(
        serie: json["Serie"] == null ? "" : json["Serie"],
        articulo: json["Articulo"],
        descripcion1: json["Descripcion1"] == null ? "" :  json["Descripcion1"] ,
        categoria: json["Categoria"],
        observaciones: json["Observaciones"],
        responsable: json["Responsable"],
        responsableNombre: json["ResponsableNombre"],
    );

    Map<String, dynamic> toJson() => {
        "Serie": serie,
        "Articulo": articulo,
        "Descripcion1": descripcion1,
        "Categoria": categoria,
        "Observaciones": observaciones,
        "Responsable": responsable,
        "ResponsableNombre": responsableNombre,
    };
}
