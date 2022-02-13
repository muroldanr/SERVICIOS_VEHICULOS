import 'dart:convert';

List<Origen> origenFromJson(String str) => List<Origen>.from(json.decode(str).map((x) => Origen.fromJson(x)));

String origenToJson(List<Origen> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Origen {
    Origen({
        this.origen,
    });

    String? origen;

    factory Origen.fromJson(Map<String, dynamic> json) => Origen(
        origen: json["Origen"] == null ? null : json["Origen"],
    );

    Map<String, dynamic> toJson() => {
        "Origen": origen == null ? null : origen,
    };
}
