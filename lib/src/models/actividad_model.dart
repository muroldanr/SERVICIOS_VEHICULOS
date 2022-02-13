// To parse this JSON data, do
//
//     final actividad = actividadFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

List<Actividad> actividadFromJson(String str) =>
    List<Actividad>.from(json.decode(str).map((x) => Actividad.fromJson(x)));

String actividadToJson(List<Actividad> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Actividad {
  Actividad({
    this.rid,
    this.actividad,
    this.estado,
    this.fechaInicio,
    this.horaInicio,
    this.fechaFin,
    this.horaFin,
  });

  int? rid;
  String? actividad;
  int? estado;
  dynamic? fechaInicio;
  dynamic? horaInicio;
  dynamic? fechaFin;
  dynamic? horaFin;

  factory Actividad.fromJson(Map<String, dynamic> json) => Actividad(
        rid: json["RID"] != null ? json["RID"] : 0,
        actividad: json["Actividad"] != null ? json["Actividad"] : "",
        estado: json["Estado"] != null ? json["Estado"] : 0,
        fechaInicio: json["FechaInicio"] != null ? json["FechaInicio"] : "",
        horaInicio: json["HoraInicio"] != null ? json["HoraInicio"] : "",
        fechaFin: json["FechaFin"] != null ? json["FechaFin"] : "",
        horaFin: json["HoraFin"] != null ? json["HoraFin"] : "",
      );

  Map<String, dynamic> toJson() => {
        "RID": rid,
        "Actividad": actividad,
        "Estado": estado,
        "FechaInicio": fechaInicio,
        "HoraInicio": horaInicio,
        "FechaFin": fechaFin,
        "HoraFin": horaFin,
      };

  String dateFin() {
    try {
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(fechaFin); // <-- Incoming date
      var outputFormat = DateFormat('MM/dd/yyyy');
      var outputDate = outputFormat.format(inputDate); // <-- Desired date
      return outputDate;
    } catch (e) {
      return "";
    }
  }

  String dateInicio() {
    try {
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(fechaInicio); // <-- Incoming date
      var outputFormat = DateFormat('MM/dd/yyyy');
      var outputDate = outputFormat.format(inputDate); // <-- Desired date
      return outputDate;
    } catch (e) {
      return "";
    }
  }

  String dateFormat(String date) {
    var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var inputDate = inputFormat.parse(date); // <-- Incoming date
    var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
    var outputDate = outputFormat.format(inputDate); // <-- Desired date
    return outputDate; // 12/31/2000 11:59 PM
  }
}
