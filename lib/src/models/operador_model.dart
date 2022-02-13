import 'dart:convert';

List<Operador> operadorFromJson(String str) =>
    List<Operador>.from(json.decode(str).map((x) => Operador.fromJson(x)));

String operadorToJson(List<Operador> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Operador {
  Operador({
    this.operador,
    this.nombre,
  });

  String? operador;
  String? nombre;

  factory Operador.fromJson(Map<String, dynamic> json) => Operador(
        operador: json["Operador"] == null ? null : json["Operador"],
        nombre: json["Nombre"] == null ? null : json["Nombre"],
      );

  Map<String, dynamic> toJson() => {
        "Operador": operador == null ? null : operador,
        "Nombre": nombre == null ? null : nombre,
      };
}
