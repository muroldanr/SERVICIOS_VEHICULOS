import 'dart:convert';

List<Causa> causaFromJson(String str) => List<Causa>.from(json.decode(str).map((x) => Causa.fromJson(x)));

String causaToJson(List<Causa> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Causa {
    Causa({
        this.causa,
    });

    String? causa;

    factory Causa.fromJson(Map<String, dynamic> json) => Causa(
        causa: json["Causa"] == null ? null : json["Causa"],
    );

    Map<String, dynamic> toJson() => {
        "Causa": causa == null ? null : causa,
    };
}
