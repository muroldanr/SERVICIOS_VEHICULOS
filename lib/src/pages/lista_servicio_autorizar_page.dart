import 'package:best_flutter_ui_templates/src/models/solicitud_autorizar_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaServiciosAutorizarPage extends StatelessWidget {
  final List<SolicitudAutorizar> listaServicios;
  final String tipoList;
  final ScrollController scrollController;
  final formatCurrency = new NumberFormat.simpleCurrency();
  final BuildContext context;

  ListaServiciosAutorizarPage(
      this.listaServicios, this.tipoList, this.scrollController, this.context);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
      children: _listaServicios(this.listaServicios, context),
    );
  }

  List<Widget> _listaServicios(
      List<SolicitudAutorizar> items, BuildContext context) {
    String imagenTruck = "assets/camioneta.png";
    String imagenMaqui = "assets/bull.jpg";

    final List<Widget> servicios = [];

    if (items.length <= 0) {
      return [];
    }

    listaServicios.forEach((item) {
      final widgetTemp = Stack(
        children: <Widget>[
          GestureDetector(
            /* onTap: () => _goToDetail(tipoList, item),*/
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
                      item.descripcionActivo,
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

  /*void _goToDetail(String tipo, SolicitudAutorizar item) {
    switch (tipo) {
      case 'Pendiente':
        Navigator.push(
          context,
          MaterialPageRoute(
           // builder: (_) => DetalleServicioPage(item),
          ),
        );
        break;

      case 'Autorizaciones':
        Navigator.push(
          context,
          MaterialPageRoute(
           // builder: (_) => DetalleAprobarTicket(item),
          ),
        );
        break;

      default:
        Navigator.push(
          context,
          MaterialPageRoute(
          //  builder: (_) => DetalleServicioPage(item),
          ),
        );
        break;
    }
  }*/
}
