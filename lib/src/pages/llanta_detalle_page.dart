import 'dart:async';

import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/models/llanta_detalle_model.dart';
import 'package:best_flutter_ui_templates/src/pages/actualizar_llanta.page.dart';
import 'package:best_flutter_ui_templates/src/pages/baja_llanta.dart';
import 'package:best_flutter_ui_templates/src/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalleLlantaPage extends StatefulWidget {
  final String id;
  final String numero;
  DetalleLlantaPage(this.id, this.numero);

  @override
  _DetalleLlantaPageState createState() =>
      _DetalleLlantaPageState(this.id, this.numero);
}

class _DetalleLlantaPageState extends State<DetalleLlantaPage> {
  final String id;
  final String numero;
  _DetalleLlantaPageState(this.id, this.numero);
  final formatCurrency = new NumberFormat.simpleCurrency();
  final imagenTruck = "assets/construccion/con-truck.png";
  final imagenMaqui = "assets/construccion/con-digger.png";
  LlantaDetalle detalle = new LlantaDetalle();

  @override
  void initState() {
    super.initState();
    _getDetalle();
  }

  _getDetalle() async {
    final httpProv = new HttpProvider();
    var res = await (httpProv.spWebLlantaInfo(numero, id)
        as FutureOr<List<LlantaDetalle>>);
    if (res[0] != null) {
      setState(() {
        detalle = res[0];
      });
    } else {
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text("No existe llanta en la posicion Actual"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: NavBarCustom("Información"),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            //  _servicioCard(),
            _servicioCardDetalle(),
            _botonDesasigna(),
            _botonBaja()
          ],
        )),
      ),
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
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      alignment: Alignment.center,
                      child: Text("",
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
                imagenTruck,
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

  Widget _servicioCardDetalle() {
    //print(newDateTimeObj2);

    //    var newDateTimeObj = new DateFormat().add_yMd().add_Hms().parse(fecha);

    final widgetTemp = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
          height: 600.0,
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
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getRenglon("Equipo", detalle.descripcion1),
                _getRenglon("Número económico", detalle.serie),
                _getRenglon("Posición", detalle.posicion),
                _getRenglon(
                    "Último cambio", _getDateFormat(detalle.ultimoCambio!)),
                _getRenglon("Km Inicial", detalle.kmInicial.toString()),
                Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Center(
                      child: Text(
                        "Datos Neumático Instalado",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                _getRenglon("Marca", detalle.marca),
                _getRenglon("Tipo", detalle.tipo),
                _getRenglon("Medida", detalle.medida),
                _getRenglon("Folio", detalle.llanta.toString()),
                _getRenglon(
                    "Última medición", _getDateFormat(detalle.ultimaMedicion!)),
                _getRenglon("Profundidad", detalle.profundidad.toString()),
                //_getRenglon("Motivo", solicitudPendiente.mov),
                //_getRenglon("O.C", "NULL"),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ],
    );

    return widgetTemp;
  }

  Widget _getRenglon(String value1, String? value2) {
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
                    value1 != null ? value1 : '',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.39,
                  child: Text(
                    value2 != null ? value2 : '',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.fade,
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

  Widget _getRenglonColor(String value1, String value2) {
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
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  alignment: Alignment.center,
                  child: Text("solicitudPendiente.estado",
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
                    onTap: () {})
              ]),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  String _getDateFormat(DateTime fecha) {
    try {
      var dia = fecha.day.toString();
      var mes = fecha.month.toString();
      var ano = fecha.year.toString();

      return dia + " / " + mes + " / " + ano;
    } catch (e) {
      return "";
    }
  }

  Widget _botonDesasigna() {
    return Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 20.0),
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
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ActualizarLlanta(
                            detalle.id.toString(),
                            detalle.descripcion1.toString(),
                            detalle.serie.toString(),
                            detalle.posicion.toString(),
                            detalle.ultimoCambio.toString(),
                            detalle.kmInicial.toString(),
                            detalle.marca.toString(),
                            detalle.tipo.toString(),
                            detalle.medida.toString(),
                            detalle.llanta.toString(),
                            detalle.ultimaMedicion.toString(),
                            detalle.profundidad.toString(),
                          ))),
              child: Center(
                child: Text(
                  "Desasigna",
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

  Widget _botonBaja() {
    return Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 7.0),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.red,
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
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BajarLLanta(
                            detalle.id.toString(),
                            detalle.descripcion1.toString(),
                            detalle.serie.toString(),
                            detalle.posicion.toString(),
                            detalle.ultimoCambio.toString(),
                            detalle.kmInicial.toString(),
                            detalle.marca.toString(),
                            detalle.tipo.toString(),
                            detalle.medida.toString(),
                            detalle.llanta.toString(),
                            detalle.ultimaMedicion.toString(),
                            detalle.profundidad.toString(),
                          ))),
              child: Center(
                child: Text(
                  "Baja",
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

  //builder: (_) => TareasServicioPage(solicitudPendiente),
}
