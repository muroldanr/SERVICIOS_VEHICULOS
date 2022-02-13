import 'dart:convert';

List<ServicioTipo> servicioTipoFromJson(String str) => List<ServicioTipo>.from(json.decode(str).map((x) => ServicioTipo.fromJson(x)));

String servicioTipoToJson(List<ServicioTipo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServicioTipo {
    ServicioTipo({
        this.servicio,
        this.descripcion,
    });

    String? servicio;
    String? descripcion;

    factory ServicioTipo.fromJson(Map<String, dynamic> json) => ServicioTipo(
        servicio: (json["Servicio"]  != null) ? json["Servicio"] : "",
        descripcion: (json["Descripcion"] != null) ? json["Descripcion"] : "",
    );

    Map<String, dynamic> toJson() => {
        "Servicio": servicio,
        "Descripcion": descripcion,
    };
}
