import 'package:best_flutter_ui_templates/fitness_app/utils/DAWidgets.dart';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'detalle_aprobar_page.dart';
import 'detalle_servicio_page.dart';

class ListaServiciosPage extends StatelessWidget {
  final List<SolicitudPendiente>? listaServicios;
  final String tipoList;
  final formatCurrency = new NumberFormat.simpleCurrency();
  final BuildContext context;
  String imagenTruck = "assets/camioneta.png";
  String imagenMaqui = "assets/bull.jpg";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ListaServiciosPage(this.listaServicios, this.tipoList, this.context);
  String imagenPesos = "assets/peso.png";
  String imagenDolar = "assets/dollar.png";
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return DaScaffoldLoading(
      isLoading: _saving,
      keyLoading: _scaffoldKey,
      children: [_getBody()],
    );
  }

  Widget _getBody() {
    return ListView.builder(
      itemCount: this.listaServicios!.length,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      itemBuilder: (context, i) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () => _goToDetail(tipoList, this.listaServicios![i]),
            child: Container(
              margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(68.0),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //(item.responsable == "") ? Center() :
                    Text(
                      this.listaServicios![i].servicioSerie!,
                      style: TextStyle(
                          fontSize: 19.0, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      this.listaServicios![i].centroCostos!,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                    (this.listaServicios![i].servicioTipoOrden == "PREVENTIVO")
                        ? Center()
                        : Text(
                            '${formatCurrency.format(this.listaServicios![i].importe)}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w400)),
                    (this.listaServicios![i].servicioTipoOrden == "PREVENTIVO")
                        ? Text("",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w400))
                        : Text(
                            this.listaServicios![i].moneda == null
                                ? ""
                                : this.listaServicios![i].moneda!,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w400)),

                    /*
                    (this.listaServicios[i].moneda == "Pesos")
                        ? Image.asset(
                            imagenPesos,
                            fit: BoxFit.contain,
                            height: 20.0,
                          )
                        : Image.asset(
                            imagenDolar,
                            fit: BoxFit.contain,
                            height: 20.0,
                          ),*/
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5.0),
                          width: 145.0,
                          decoration: BoxDecoration(
                            color: _getColor(this.listaServicios![i].estado),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(this.listaServicios![i].estado!,
                              style: TextStyle(
                                  color: _getColorText(
                                      this.listaServicios![i].estado),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20.0,
            top: 5.0,
            bottom: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    this.listaServicios![i].mov!.contains("Transporte")
                        ? imagenTruck
                        : imagenMaqui,
                    width: 100,
                    fit: BoxFit.fitWidth,
                  ),
                  Text(
                    this.listaServicios![i].grupo!,
                    style:
                        TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Folio : " + this.listaServicios![i].movId!,
                    style:
                        TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      shrinkWrap: true,
    );
  }

  List<Widget> _listaServicios(
      List<SolicitudPendiente> items, BuildContext context) {
    String imagenTruck = "assets/camioneta.png";
    String imagenMaqui = "assets/bull.jpg";

    final List<Widget> servicios = [];

    if (items.length <= 0) {
      return [];
    }

    listaServicios!.forEach((item) {
      final widgetTemp = Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () => _goToDetail(tipoList, item),
            child: Container(
              margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(68.0),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //(item.responsable == "") ? Center() :
                    Text(
                      item.responsable!,
                      style: TextStyle(
                          fontSize: 19.0, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.descripcionActivo!,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                    (item.servicioTipoOrden == "Preventivo")
                        ? Center()
                        : Text('${formatCurrency.format(item.importe)}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w400)),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5.0),
                          width: 145.0,
                          decoration: BoxDecoration(
                            color: _getColor(item.estado),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(item.estado!,
                              style: TextStyle(
                                  color: _getColorText(item.estado),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20.0,
            top: 5.0,
            bottom: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.asset(
                    item.mov!.contains("Transporte") ? imagenTruck : imagenMaqui,
                    width: 100,
                    fit: BoxFit.fitWidth,
                  ),
                  Text(
                    item.grupo!,
                    style:
                        TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Folio : " + item.movId!,
                    style:
                        TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
        ],
      );

      servicios..add(widgetTemp);
    });

    return servicios;
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
      case "OM REVISION":
        return Colors.orange[600];
        break;
      case "OM CONCLUIDO":
        return Colors.green[300];
        break;

      default:
        return Colors.grey;
        break;
    }
  }

  Color _getColorText(String? status) {
    switch (status) {
      case "EN APROBACION":
        return Colors.white;
        break;
      case "CERRADA":
        return Colors.white;
        break;
      case "PROCESO":
        return Colors.black;
        break;
      case "RECHAZADA":
        return Colors.white;
        break;
      case "APROBADA":
        return Colors.white;
        break;
      case "OM REVISION":
        return Colors.white;
        break;
      case "OM CONCLUIDO":
        return Colors.white;
        break;

      default:
        return Colors.grey;
        break;
    }
  }

  void _goToDetail(String tipo, SolicitudPendiente item) {
    switch (tipo) {
      case 'Pendiente':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleServicioPage(item),
          ),
        );
        break;

      case 'Autorizaciones':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleAprobarTicket(item),
          ),
        );
        break;

      default:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleServicioPage(item),
          ),
        );
        break;
    }
  }
}
