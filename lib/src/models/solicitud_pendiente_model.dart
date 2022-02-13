// To parse this JSON data, do
//
//     final solicitudPendiente = solicitudPendienteFromJson(jsonString);

import 'dart:convert';

List<SolicitudPendiente> solicitudPendienteFromJson(String str) =>
    List<SolicitudPendiente>.from(
        json.decode(str).map((x) => SolicitudPendiente.fromJson(x)));

String solicitudPendienteToJson(List<SolicitudPendiente> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SolicitudPendiente {
  SolicitudPendiente(
      {this.id,
      this.empresa,
      this.sucursal,
      this.nombre,
      this.fechaEmision,
      this.mov,
      this.movId,
      this.estatus,
      this.situacion,
      this.situacionFecha,
      this.situacionUsuario,
      this.agente,
      this.movTipo,
      this.centroCostos,
      this.servicioSerie,
      this.servicioArticulo,
      this.grupo,
      this.importe,
      this.avanzarSituacion,
      this.estado,
      this.responsable,
      this.descripcionActivo,
      this.servicioTipoOrden,
      this.moneda,
      this.solicitudID});

  int? id;
  String? empresa;
  int? sucursal;
  String? nombre;
  DateTime? fechaEmision;
  String? mov;
  String? movId;
  String? estatus;
  String? situacion;
  DateTime? situacionFecha;
  dynamic situacionUsuario;
  dynamic agente;
  String? movTipo;
  String? centroCostos;
  String? servicioSerie;
  String? servicioArticulo;
  String? grupo;
  double? importe;
  dynamic avanzarSituacion;
  String? estado;
  String? responsable;
  String? descripcionActivo;
  String? servicioTipoOrden;
  String? moneda;
  int? solicitudID;

  factory SolicitudPendiente.fromJson(Map<String, dynamic> json) =>
      SolicitudPendiente(
        id: json["ID"] == null ? "" as int? : json["ID"],
        empresa: json["Empresa"] == null ? "" : json["Empresa"],
        sucursal: json["Sucursal"] == null ? "" as int? : json["Sucursal"],
        nombre: json["Nombre"] == null ? "" : json["Nombre"],
        fechaEmision: json["FechaEmision"] == null
            ? "" as DateTime?
            : DateTime.parse(json["FechaEmision"]),
        mov: json["Mov"] == null ? "" : json["Mov"],
        movId: json["MovID"] == null ? "" : json["MovID"],
        estatus: json["Estatus"] == null ? "" : json["Estatus"],
        situacion: json["Situacion"] == null ? "" : json["Situacion"],
        situacionFecha: json["SituacionFecha"] == null
            ? null
            : DateTime.parse(json["SituacionFecha"]),
        situacionUsuario: json["SituacionUsuario"],
        agente: json["Agente"],
        movTipo: json["MovTipo"] == null ? "" : json["MovTipo"],
        centroCostos: json["CentroCostos"] == null ? "" : json["CentroCostos"],
        servicioSerie:
            json["ServicioSerie"] == null ? "" : json["ServicioSerie"],
        servicioArticulo:
            json["ServicioArticulo"] == null ? "" : json["ServicioArticulo"],
        grupo: json["Grupo"] == null ? "" : json["Grupo"],
        importe: json["Importe"] == null ? "" as double? : json["Importe"],
        avanzarSituacion: json["AvanzarSituacion"],
        estado: json["Estado"] == null ? "" : json["Estado"],
        responsable: json["Responsable"] == null ? "" : json["Responsable"],
        descripcionActivo:
            json["DescripcionActivo"] == null ? "" : json["DescripcionActivo"],
        servicioTipoOrden:
            json["ServicioTipoOrden"] == null ? "" : json["ServicioTipoOrden"],
        moneda: json["Moneda"] == null ? "" : json["Moneda"],
        solicitudID: json["SolicitudID"] == null ? 0 : json["SolicitudID"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id == null ? "" : id,
        "Empresa": empresa == null ? "" : empresa,
        "Sucursal": sucursal == null ? "" : sucursal,
        "Nombre": nombre == null ? "" : nombre,
        "FechaEmision":
            fechaEmision == null ? "" : fechaEmision!.toIso8601String(),
        "Mov": mov == null ? "" : mov,
        "MovID": movId == null ? "" : movId,
        "Estatus": estatus == null ? "" : estatus,
        "Situacion": situacion == null ? "" : situacion,
        "SituacionFecha":
            situacionFecha == null ? "" : situacionFecha!.toIso8601String(),
        "SituacionUsuario": situacionUsuario,
        "Agente": agente,
        "MovTipo": movTipo == null ? "" : movTipo,
        "CentroCostos": centroCostos == null ? "" : centroCostos,
        "ServicioSerie": servicioSerie == null ? "" : servicioSerie,
        "ServicioArticulo": servicioArticulo == null ? "" : servicioArticulo,
        "Grupo": grupo == null ? "" : grupo,
        "Importe": importe == null ? "" : importe,
        "AvanzarSituacion": avanzarSituacion,
        "Estado": estado == null ? "" : estado,
        "Responsable": responsable == null ? "" : responsable,
        "DescripcionActivo": descripcionActivo == null ? "" : descripcionActivo,
        "ServicioTipoOrden": servicioTipoOrden == null ? "" : servicioTipoOrden,
        "Moneda": moneda == null ? "" : moneda,
        "SolicitudID": solicitudID == null ? "" : solicitudID
      };
}
