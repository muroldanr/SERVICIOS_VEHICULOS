import 'dart:async';

import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_detalle_model.dart';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_model.dart';
import 'package:best_flutter_ui_templates/src/pages/causa_falla_page.dart';
import 'package:best_flutter_ui_templates/src/pages/home_page.dart';
import 'package:best_flutter_ui_templates/src/pages/tareas_servicio_page.dart';
import 'package:best_flutter_ui_templates/src/utils/DAWidgets.dart';
import 'package:best_flutter_ui_templates/src/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'causa_falla_validar_page.dart';

class DetalleServicioPage extends StatefulWidget {
  final SolicitudPendiente solicitud;
  DetalleServicioPage(this.solicitud);

  @override
  _DetalleServicioPageState createState() =>
      _DetalleServicioPageState(solicitud);
}

class _DetalleServicioPageState extends State<DetalleServicioPage> {
  SolicitudPendiente solicitudPendiente;
  _DetalleServicioPageState(this.solicitudPendiente);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formatCurrency = new NumberFormat.simpleCurrency();
  final imagenTruck = "assets/construccion/con-truck.png";
  final imagenMaqui = "assets/construccion/con-digger.png";
  SolicitudPendienteDetalle detalle = new SolicitudPendienteDetalle();
  late SharedPreferences prefs;
  bool? _procesar = false;
  bool? _afectar = false;
  bool _tituloBoton = false;
  bool _saving = false;
  final httpProv = new HttpProvider();

  @override
  void initState() {
    super.initState();
    _getPreferences();
    _getDetalle();
  }

  _getDetalle() async {
    var res = await (httpProv
            .detalleServicioFromJson(solicitudPendiente.id.toString())
        as FutureOr<List<SolicitudPendienteDetalle>>);
    if (res.isNotEmpty) {
      if (res[0] != null) {
        setState(() {
          detalle = res[0];
        });
      } else {
        print("Error en la Consulta");
      }
    }

    print(detalle.tipo);
  }

  _getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _procesar = prefs.getBool("Procesar");
      _afectar = prefs.getBool("Afectar");
    });
  }

  @override
  Widget build(BuildContext context) {
    return DaScaffoldLoading(
      isLoading: _saving,
      keyLoading: _scaffoldKey,
      children: <Widget>[
        Scaffold(
          appBar: NavBarCustom(solicitudPendiente.mov),
          body: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              //  _servicioCard(),
              _servicioCardDetalle(context),
              _botonIr(),
            ],
          )),
        ),
      ],
    );
  }

  Widget _servicioCard() {
    final widgetTemp = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
          height: 130.0,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 5.0,
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(140.0, 15.0, 15.0, 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /* Column(children: <Widget>[
                      Text(
                          'Importe : ${formatCurrency.format(solicitudPendiente.importe)}',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600)),
                    ])*/
                  ],
                ),
                //Text("FOLIO : " + solicitudPendiente.movId.toString(), style:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600)),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: 120.0,
                      decoration: BoxDecoration(
                        color: _getColor(solicitudPendiente.estado),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(solicitudPendiente.estado!,
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.0)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 20.0,
          top: 5.0,
          bottom: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                solicitudPendiente.mov!.contains("Transporte")
                    ? imagenTruck
                    : imagenMaqui,
                width: 60,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        )
      ],
    );

    return widgetTemp;
  }

  Widget _servicioCardDetalle(context) {
    var dia = solicitudPendiente.fechaEmision!.day.toString();
    var mes = solicitudPendiente.fechaEmision!.month.toString();
    var ano = solicitudPendiente.fechaEmision!.year.toString();

    //print(newDateTimeObj2);

    //    var newDateTimeObj = new DateFormat().add_yMd().add_Hms().parse(fecha);

    final widgetTemp = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
          height: 550.0,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(65.0),
                  topRight: Radius.circular(25.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 5.0,
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _getRenglon(
                    "Tipo", (detalle.tipo == null) ? "" : detalle.tipo!),
                _getRenglon(
                    "Folio", (detalle.folio == null) ? "" : detalle.folio!),
                _getRenglon("Fecha captura", dia + "/" + mes + "/" + ano),
                _getRenglon(
                    "Solicitante",
                    (detalle.solicitante == null)
                        ? "No Asignado"
                        : detalle.solicitante!),
                _getRenglon("ECO", (detalle.eco == null) ? "" : detalle.eco!),
                _getRenglon(
                    "CECO", (detalle.ceco == null) ? "" : detalle.ceco!),
                /* _getRenglon("Mantenimiento",(detalle.mantenimiento == null) ? "" : detalle.mantenimiento),*/
                _getRenglon("Operador",
                    (detalle.usuario == null) ? "" : detalle.usuario!),
                _getRenglonColor("Estatus",
                    (detalle.estatus == null) ? "" : detalle.estatus),
                _getRenglon("Falla presentada",
                    (detalle.motivo == null) ? "" : detalle.motivo!),
                _getRenglon("Prioridad",
                    (detalle.prioridad == null) ? "" : detalle.prioridad!),
                //_getRenglonVerAnexos(),
                /* _getRenglon("O.C",
                    (detalle.ordenCompra == null) ? "" : detalle.ordenCompra),*/
                /* _getRenglon(
                    "Importe",
                    (solicitudPendiente.importe == null)
                        ? ""
                        : formatCurrency.format(solicitudPendiente.importe)),*/
                //_getRenglon("Motivo", solicitudPendiente.mov),
                //_getRenglon("O.C", "NULL"),
              ],
            ),
          ),
        ),
      ],
    );

    return widgetTemp;
  }

  Widget _getRenglon(String value1, String value2) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: Text(
                    value1,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.39,
                  child: Text(
                    value2,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  Widget _getRenglonColor(String value1, String? value2) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    value1,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  width: 120.0,
                  decoration: BoxDecoration(
                    color: _getColor(solicitudPendiente.estado),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(solicitudPendiente.estado!,
                      style: TextStyle(color: Colors.white, fontSize: 14.0)),
                ),
              ]),
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  Widget _getRenglonWithAction(String value1, String value2) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    value1,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  alignment: Alignment.centerRight,
                  child: Text(
                    value2,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
              Column(children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.green,
                      size: 20.0,
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TareasServicioPage(solicitudPendiente),
                    ),
                  ),
                )
              ]),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  changeTitleButtonActulizarDatos() {
    setState(() {
      _tituloBoton = true;
    });
  }

  Widget _botonIr() {
    String titulo = "";
    Function? nextOption;
    bool soloBoton = false;

    if (solicitudPendiente.servicioTipoOrden == "PREVENTIVO") {
      switch (solicitudPendiente.estado) {
        case "EN APROBACION":
          titulo = "";
          break;
        case "CERRADA":
          titulo = "";
          break;
        case "PROCESO":
          if (_afectar!) {
            titulo = "Actualizar Datos"; //Operar Solicitud
            nextOption = (_) => TareasServicioPage(solicitudPendiente);
          }
          break;
        case "RECHAZADA":
          titulo = "";
          break;
        case "APROBADA":
          if (_afectar!) {
            titulo = "Generar Orden";
            nextOption = _generarOrdenMantenimiento;
            soloBoton = true;
          }
          break;
        case "OM CONCLUIDO":
          if (_afectar!) {
            titulo = "Operar Solicitud";
            nextOption = _generarConsumoInterno;
            soloBoton = true;
          }
          break;
        default:
          titulo = "";
          break;
      }
    } else {
      switch (solicitudPendiente.estado) {
        case "EN APROBACION":
          if (solicitudPendiente.importe! <= 0) {
            if (_procesar!) {
              titulo = "Calcular Presupuesto";
              nextOption = (_) => CausaFalla(solicitudPendiente);
            }
          } else {
            titulo = "";
          }
          break;
        case "CERRADA":
          titulo = "";
          break;
        case "PROCESO":
          if (_afectar!) {
            titulo = "Actualizar Datos";
            nextOption = (_) => CausaFallaValidar(solicitudPendiente);
            soloBoton = false;
          }
          break;
        case "RECHAZADA":
          titulo = "";
          break;
        case "APROBADA":
          if (_afectar!) {
            titulo = "Generar Orden";
            nextOption = _generarOrdenMantenimiento;
            soloBoton = true;
          }
          break;
        case "OM CONCLUIDO":
          if (_afectar!) {
            titulo = "Generar Consumo";
            nextOption = _generarConsumoInterno;
            soloBoton = true;
          }
          break;

        default:
          titulo = "";
          break;
      }
    }

    if (titulo == "") {
      return Container();
    }

    return Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 28),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 8,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              highlightColor: Colors.transparent,
              onTap: (!soloBoton)
                  ? () => (Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: nextOption as Widget Function(BuildContext),
                        ),
                      ))
                  : nextOption as void Function()?,
              child: Center(
                child: Text(
                  titulo,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ));
  }

  Color? _getColor(String? status) {
    switch (status) {
      case "EN APROBACION":
        return Colors.grey[600];
        break;
      case "CERRADA":
        return Colors.blue[600];
        break;
      case "PROCESO":
        return Colors.yellow[600];
        break;
      case "RECHAZADA":
        return Colors.red[600];
        break;
      case "APROBADA":
        return Colors.green[600];
        break;
      case "APROBADA":
        return Colors.green[600];
        break;
      case "APROBADA":
        return Colors.green[600];
        break;

      default:
        return Colors.grey;
        break;
    }
  }

  _generarOrdenMantenimiento() async {
    setState(() {
      _saving = true;
    });
    print("ID : " + solicitudPendiente.id.toString());
    final List<Response>? resp = await (httpProv
        .spWebGenerarOrdenMatto(solicitudPendiente.id.toString()));
    if (resp!.length >= 0) {
      if (resp[0].ok == null || resp[0].ok == "null") {
        setState(() {
          _saving = false;
        });
        _showMessgeDialog(
            context, "Generada Correctamente \n" + resp[0].ordenGenerada!);
      } else {
        setState(() {
          _saving = false;
        });
        _showMessgeDialog(context, resp[0].okRef);
      }
    }
  }

  _generarConsumoInterno() async {
    setState(() {
      _saving = true;
    });
    print("HOLA HUMANO : " + solicitudPendiente.id.toString());
    final List<Response> resp = await (httpProv.spWebGenerarConsumoInterno(
        solicitudPendiente.id.toString()) as FutureOr<List<Response>>);
    if (resp.length >= 0) {
      if (resp[0].ok == null || resp[0].ok == "null") {
        setState(() {
          _saving = false;
        });
        _showMessgeDialog(
            context, "Generada Correctamente \n" + resp[0].ordenGenerada!);
      } else {
        setState(() {
          _saving = false;
        });
        _showMessgeDialog(context, resp[0].okRef);
      }
    }
  }

  Future<void> _showMessgeDialog(BuildContext context, String? text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: new Text(
              text == null || text == "null" ? "Realizado con èxito" : text),
          actions: <Widget>[
            new TextButton(
                onPressed: () {
                  _regresar();
                },
                child: new Text("Ok"))
          ],
        );
      },
    );
  }

  _regresar() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  //builder: (_) => TareasServicioPage(solicitudPendiente),
}
