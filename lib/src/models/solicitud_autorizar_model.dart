// To parse this JSON data, do
//
//     final solicitudAutorizar = solicitudAutorizarFromJson(jsonString);

import 'dart:convert';

List<SolicitudAutorizar> solicitudAutorizarFromJson(String str) => List<SolicitudAutorizar>.from(json.decode(str).map((x) => SolicitudAutorizar.fromJson(x)));

String solicitudAutorizarToJson(List<SolicitudAutorizar> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SolicitudAutorizar {
    SolicitudAutorizar({
        this.id,
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
        this.servicioSerie,
        this.servicioArticulo,
        this.grupo,
        this.importe,
        this.avanzarSituacion,
        this.estado,
        this.responsable,
        this.descripcionActivo,
        this.servicioTipoOrden,
    });

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
    String? situacionUsuario;
    String? agente;
    String? movTipo;
    String? servicioSerie;
    String? servicioArticulo;
    String? grupo;
    double? importe;
    bool? avanzarSituacion;
    String? estado;
    String? responsable;
    dynamic descripcionActivo;
    dynamic servicioTipoOrden;

    factory SolicitudAutorizar.fromJson(Map<String, dynamic> json) => SolicitudAutorizar(
        id: json["ID"] == null ? "" as int? : json["ID"],
        empresa: json["Empresa"] == null ? "" : json["Empresa"],
        sucursal: json["Sucursal"] == null ? "" as int? : json["Sucursal"],
        nombre: json["Nombre"] == null ? "" : json["Nombre"],
        fechaEmision: json["FechaEmision"] == null ? null : DateTime.parse(json["FechaEmision"]),
        mov: json["Mov"] == null ? "" : json["Mov"],
        movId: json["MovID"] == null ? "" : json["MovID"],
        estatus: json["Estatus"] == null ? "" : json["Estatus"],
        situacion: json["Situacion"] == null ? "" : json["Situacion"],
        situacionFecha: json["SituacionFecha"] == null ? null : DateTime.parse(json["SituacionFecha"]),
        situacionUsuario: json["SituacionUsuario"] == null ? "" : json["SituacionUsuario"],
        agente: json["Agente"] == null ? "" : json["Agente"],
        movTipo: json["MovTipo"] == null ? "" : json["MovTipo"],
        servicioSerie: json["ServicioSerie"] == null ? "" : json["ServicioSerie"],
        servicioArticulo: json["ServicioArticulo"] == null ? "" : json["ServicioArticulo"],
        grupo: json["Grupo"] == null ? "" : json["Grupo"],
        importe: json["Importe"] == null ? "" as double? : json["Importe"],
        avanzarSituacion: json["AvanzarSituacion"] == null ? "" as bool? : json["AvanzarSituacion"],
        estado: json["Estado"] == null ? "" : json["Estado"],
        responsable: json["Responsable"] == null ? "" : json["Responsable"],
        descripcionActivo: json["DescripcionActivo"] == null ? "" : json["DescripcionActivo"],
        servicioTipoOrden: json["ServicioTipoOrden"] == null ? "" : json["ServicioTipoOrden"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id == null ? "" : id,
        "Empresa": empresa == null ? "" : empresa,
        "Sucursal": sucursal == null ? "" : sucursal,
        "Nombre": nombre == null ? "" : nombre,
        "FechaEmision": fechaEmision == null ? "" : fechaEmision!.toIso8601String(),
        "Mov": mov == null ? "" : mov,
        "MovID": movId == null ? "" : movId,
        "Estatus": estatus == null ? "" : estatus,
        "Situacion": situacion == null ? "" : situacion,
        "SituacionFecha": situacionFecha == null ? "" : situacionFecha!.toIso8601String(),
        "SituacionUsuario": situacionUsuario == null ? "" : situacionUsuario,
        "Agente": agente == null ? "" : agente,
        "MovTipo": movTipo == null ? "" : movTipo,
        "ServicioSerie": servicioSerie == null ? "" : servicioSerie,
        "ServicioArticulo": servicioArticulo == null ? "" : servicioArticulo,
        "Grupo": grupo == null ? "" : grupo,
        "Importe": importe == null ? "" : importe,
        "AvanzarSituacion": avanzarSituacion == null ? "" : avanzarSituacion,
        "Estado": estado == null ? "" : estado,
        "Responsable": responsable == null ? "" : responsable,
        "DescripcionActivo": descripcionActivo,
        "ServicioTipoOrden": servicioTipoOrden,
    };
}
