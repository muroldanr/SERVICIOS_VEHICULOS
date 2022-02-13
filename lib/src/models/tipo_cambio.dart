import 'dart:convert';

List<TipoCambio> tipoCambioFromJson(String str) =>
    List<TipoCambio>.from(json.decode(str).map((x) => TipoCambio.fromJson(x)));

String tipoCambioToJson(List<TipoCambio> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TipoCambio {
  TipoCambio({
    this.tipoCambio,
  });

  double? tipoCambio;

  factory TipoCambio.fromJson(Map<String, dynamic> json) => TipoCambio(
        tipoCambio:
            json["TipoCambio"] == null ? null : json["TipoCambio"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "TipoCambio": tipoCambio == null ? null : tipoCambio,
      };
}
