// To parse this JSON data, do
//
//     final solicitudPendienteDetalle = solicitudPendienteDetalleFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

List<SolicitudPendienteDetalle> solicitudPendienteDetalleFromJson(String str) =>
    List<SolicitudPendienteDetalle>.from(
        json.decode(str).map((x) => SolicitudPendienteDetalle.fromJson(x)));

String solicitudPendienteDetalleToJson(List<SolicitudPendienteDetalle> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SolicitudPendienteDetalle {
  SolicitudPendienteDetalle({
    this.tipo,
    this.folio,
    this.fechaCaptura,
    this.solicitante,
    this.eco,
    this.ceco,
    this.mantenimiento,
    this.estatus,
    this.usuario,
    this.motivo,
    this.ordenCompra,
    this.avanzarSituacion,
    this.prioridad,
  });

  String? tipo;
  String? folio;
  dynamic fechaCaptura;
  String? solicitante;
  String? eco;
  String? ceco;
  String? mantenimiento;
  String? estatus;
  String? usuario;
  String? motivo;
  dynamic ordenCompra;
  bool? avanzarSituacion;
  String? prioridad;

  factory SolicitudPendienteDetalle.fromJson(Map<String, dynamic> json) =>
      SolicitudPendienteDetalle(
        tipo: json["Tipo"] != null ? json["Tipo"] : "",
        folio: json["Folio"] == null ? "" : json["Folio"],
        fechaCaptura: json["FechaCaptura"] == null
            ? ""
            : DateTime.parse(json["FechaCaptura"]),
        solicitante: json["Solicitante"] == null ? "" : json["Solicitante"],
        eco: json["ECO"] == null ? "" : json["ECO"],
        ceco: json["CECO"] == null ? "" : json["CECO"],
        mantenimiento:
            json["Mantenimiento"] == null ? "" : json["Mantenimiento"],
        estatus: json["Estatus"] == null ? "" : json["Estatus"],
        usuario: json["Usuario"] == null ? "" : json["Usuario"],
        motivo: json["Motivo"] == null ? "" : json["Motivo"],
        ordenCompra: json["OrdenCompra"],
        avanzarSituacion:
            json["AvanzarSituacion"] == null ? "" as bool? : json["AvanzarSituacion"],
        prioridad: json["Prioridad"] == null ? "" : json["Prioridad"],
      );

  Map<String, dynamic> toJson() => {
        "Tipo": tipo == null ? "" : tipo,
        "Folio": folio == null ? "" : folio,
        "FechaCaptura":
            fechaCaptura == null ? "" : fechaCaptura.toIso8601String(),
        "Solicitante": solicitante == null ? "" : solicitante,
        "ECO": eco == null ? "" : eco,
        "CECO": ceco == null ? "" : ceco,
        "Mantenimiento": mantenimiento == null ? "" : mantenimiento,
        "Estatus": estatus == null ? "" : estatus,
        "Usuario": usuario == null ? "" : usuario,
        "Motivo": motivo == null ? "" : motivo,
        "OrdenCompra": ordenCompra == null ? "" : ordenCompra,
        "AvanzarSituacion": avanzarSituacion == null ? "" : avanzarSituacion,
        "Prioridad": prioridad == null ? "" : prioridad,
      };

  String dateFin() {
    try {
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(fechaCaptura); // <-- Incoming date
      var outputFormat = DateFormat('MM/dd/yyyy');
      var outputDate = outputFormat.format(inputDate); // <-- Desired date
      return outputDate;
    } catch (e) {
      return "";
    }
  }
}
