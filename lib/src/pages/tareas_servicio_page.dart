import 'dart:async';

import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/models/actividad_model.dart';
import 'package:best_flutter_ui_templates/src/models/mecanico_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_model.dart';
import 'package:best_flutter_ui_templates/src/utils/utils.dart';
import 'package:best_flutter_ui_templates/src/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';

class TareasServicioPage extends StatefulWidget {
  final SolicitudPendiente solicitud;
  TareasServicioPage(this.solicitud);

  @override
  _TareasServicioPageState createState() => _TareasServicioPageState(solicitud);
}

class _TareasServicioPageState extends State<TareasServicioPage> {
  SolicitudPendiente solicitudPendiente;
  _TareasServicioPageState(this.solicitudPendiente);

  final httpProv = new HttpProvider();
  List<Actividad>? listActividad;
  int? activateCard;
  String _fInicial = '';
  String _fFinal = '';
  String _hInicial = '';
  String _hFinal = '';
  String _fInicialRequest = '';
  String _hInicialRequest = '';
  String _fFinalRequest = '';
  String _hFinalRequest = '';
  String? _timeInicial;
  String? _timeFinal;
  late TimeOfDay _timeInicialController;
  late TimeOfDay _timeFinalController;

  List<Mecanico> listaMecanicos = [];
  TextEditingController _textKilometrosController = TextEditingController();
  String? _mecanicoSelected = "";
  int? _rid;
  String? today;

  TextEditingController _inputFechaInicialController =
      new TextEditingController();

  TextEditingController _inputHoraInicialController =
      new TextEditingController();

  TextEditingController _inputFechaFinalController =
      new TextEditingController();

  TextEditingController _inputHoraFinalController = new TextEditingController();

  TextEditingController _inputChoferController = new TextEditingController();
  Mecanico? _opcionSeleccionadaMecanico = new Mecanico();
  int? _referenciaInicialToFinalAno;
  int? _referenciaInicialToFinalMes;
  int? _referenciaInicialToFinalDia;

  int? _diaCondicional;
  int? _mesCondicional;
  int? _anoCondicional;
  String? _fechaFinalNewFormato;

  var _hInicialForRequest;
  DateTime fechaCondicional = new DateTime.now();

  @override
  void initState() {
    super.initState();

    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    var formatterHora = new DateFormat('HH:mm');
    today = formatter.format(now);
    String hora = formatterHora.format(now);
    _diaCondicional = fechaCondicional.day;
    _mesCondicional = fechaCondicional.month;
    _anoCondicional = fechaCondicional.year;
    _getListaMecanicos();
    _inputFechaInicialController.text = today!;
    _inputFechaFinalController.text = today!;
    _inputHoraInicialController.text = hora;
    _inputHoraFinalController.text = hora;
    _timeInicialController = TimeOfDay.now();
    _timeFinalController = TimeOfDay.now();
    _timeInicial = generarHoraSQL(DateTime.now());
    _timeFinal = generarHoraSQL(DateTime.now());
    _fFinalRequest = generarFecha(DateTime.now());
    _fInicialRequest = generarFecha(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBarCustom("Detalle de Orden"),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                height: MediaQuery.of(context).size.height * 0.17,
                child: _buscarMecanico()),
            Container(
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                height: MediaQuery.of(context).size.height * 0.14,
                child: _getMedicionDesgaste()),
            Container(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Stack(
                  children: [_getTituloActividades()],
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          _sendRequest();
        },
      ),
    );
  }

  Widget _getTituloActividades() {
    return Container(
      child: Column(
        children: [
          Text("Lista de Actividades",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
          SizedBox(
            height: 10.0,
          ),
          _listaDeActividades()
        ],
      ),
    );
  }

  _listaDeActividades() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.54,
      child: _listActividades(solicitudPendiente.id, context),
    );
  }

  //_opcionSeleccionadaMecanico
  _sendRequest() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');
    var formatterHora = new DateFormat('HH:mm');
    String today = formatter.format(now);
    String hora = formatterHora.format(now);
    print("ID : " + solicitudPendiente.id.toString());
    print("TareaRealizadas : " + " ");
    print("FechaInicio : " + today + " " + hora);
    print("FechaFin : " + today + " " + hora);
    print("Agente : " + _opcionSeleccionadaMecanico!.agente.toString());
    print("Kilometros : " + _textKilometrosController.text.toString());

    final List<Response>? resp = await (httpProv.spWebVentaActualizarOM(
        solicitudPendiente.id.toString(),
        "", //TRABAJO REALIZADO
        "01/01/1990", //FECHA_INICIAL
        "01/01/1990", //FECHAFINAL
        _opcionSeleccionadaMecanico!.agente.toString(),
        _textKilometrosController.text.toString()));
    if (resp!.length >= 0) {
      if (resp[0].ok == null) {
        _showMessgeDialog(context, resp[0].okRef);
      } else {
        _showMessgeDialog(context, resp[0].okRef);
      }
    }
  }

  _getListaMecanicos() async {
    final List<Mecanico>? lista = await (httpProv.spWebAgenteMecanico());

    if (lista!.length <= 0) {
      _opcionSeleccionadaMecanico = null;
      listaMecanicos = [];
      _mecanicoSelected = "";
    } else {
      _opcionSeleccionadaMecanico = lista[0];
      _mecanicoSelected = _opcionSeleccionadaMecanico!.agente;
      listaMecanicos = lista;
    }
  }

  Widget _buscarMecanico() {
    return Container(
      width: double.maxFinite,
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
      child: Column(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 100, top: 10, bottom: 2),
                          child: Row(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  child: Text("ASIGNA MECÁNICO",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: Center(
                        child: DropdownButton<Mecanico>(
                          isExpanded: true,
                          value: _opcionSeleccionadaMecanico,
                          hint: Text("Selecciona ..."),
                          onChanged: (Mecanico? newValue) {
                            setState(() {
                              _opcionSeleccionadaMecanico = newValue;
                            });
                          },
                          items: listaMecanicos.map((Mecanico mecanico) {
                            String nombreMecanico = (mecanico.nombre != null)
                                ? mecanico.nombre.toString()
                                : "Sin descripcion";
                            return new DropdownMenuItem<Mecanico>(
                              value: mecanico,
                              child: Text(
                                (mecanico.nombre != null)
                                    ? mecanico.nombre.toString()
                                    : "Sin descripcion",
                                style: TextStyle(color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    /*
                    Container(
                      width: MediaQuery.of(context).size.width * 0.70,
                      height: 260.0,
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: _getListaMecanicos(context),
                    ),*/
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _getMedicionDesgaste() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(top: 10.0),
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  solicitudPendiente.grupo == "MAQUINARIA"
                      ? "HOROMETRAJE"
                      : "KILOMETRAJE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, right: 5.0, left: 5.0, bottom: 5.0),
                    child: TextField(
                      autofocus: true,
                      controller: _textKilometrosController,
                      //autofocus: true,
                      onChanged: (valor) => setState(() {}),
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Cantidad ",
                        labelText: solicitudPendiente.grupo == "MAQUINARIA"
                            ? "Horómetro "
                            : "Kilometros",
                        suffix: solicitudPendiente.grupo == "MAQUINARIA"
                            ? Text("Hrs")
                            : Text("Kms"),
                        focusColor: Colors.green,
                        hoverColor: Colors.green,
                        fillColor: Colors.green,
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  /*
  Widget _getListaMecanicos(BuildContext context) {
    return FutureBuilder(
      future: httpProv.spWebAgenteMecanico(),
      builder: (BuildContext context, AsyncSnapshot<List<Mecanico>> snapshot) {
        if (snapshot.hasData) {
          return ListView(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20.0, bottom: 0.0),
              children: _listProveedor(snapshot.data, context));
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
  */

  Future<void> _showMessgeDialog(BuildContext context, String? text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(text == null ? "Actualizado con èxito." : text),
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
      _seguirRegresando();
    } else {
      SystemNavigator.pop();
    }
  }

  _seguirRegresando() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Widget _listActividades(int? movId, BuildContext context) {
    return FutureBuilder(
      future: httpProv.spWebArtActividadLista(movId.toString()),
      builder:
          (BuildContext context, AsyncSnapshot<List<Actividad>?> snapshot) {
        if (snapshot.hasData) {
          return ListView(
              padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
              children: _listActividad(snapshot.data!, context));
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  List<Widget> _listActividad(List<Actividad> items, BuildContext context) {
    final List<Widget> servicios = [];

    items
      ..asMap().forEach((index, item) {
        final widgetTemp = Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                item.estado == 1
                    ? _mostrarAlertInfo(context, item.fechaInicio,
                        item.horaInicio, item.fechaFin, item.horaFin)
                    : _mostrarAlertInputs(context, item.rid);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                height: index == activateCard ? 360.0 : 100,
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
                    padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: Text(
                                  item.actividad!,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Switch(
                                  value: item.estado == 1 ? true : false,
                                  onChanged: (value) {
                                    if (value) {
                                      item.estado == 1
                                          ? _mostrarAlertInfo(
                                              context,
                                              generarFecha(item.fechaInicio),
                                              item.horaInicio,
                                              generarFecha(item.fechaFin),
                                              item.horaFin)
                                          : _mostrarAlertInputs(
                                              context, item.rid);
                                    }
                                    setState(() {
                                      //activateItem =false;
                                    });
                                  },
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                )),
                          ],
                        ),
                        index == activateCard
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _inputFechaInicio(context),
                                      _inputHoraInicio(context),
                                      _inputFechaFinal(context),
                                      _inputHoraFinal(context),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    )),
              ),
            ),
          ],
        );

        servicios..add(widgetTemp);
      });

    return servicios;
  }

  void _mostrarAlertInfo(
      BuildContext context, fechaInicio, horaInicio, fechaFin, horaFin) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              scrollable: true,
              title: Text('Fecha - Hora '),
              content: Container(
                child: Column(
                  children: [
                    _getRenglon(
                        'Inicial: ',
                        fechaInicio.toString().replaceAll("T00:00:00", " ") +
                            " " +
                            horaInicio),
                    _getRenglon(
                        'Final :',
                        fechaFin.toString().replaceAll("T00:00:00", " ") +
                            " " +
                            horaFin)
                  ],
                ),
              ));
        });
  }

  Widget _getRenglon(String value1, String value2) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
            Container(
              width: 90,
              child: Text(
                value1,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 130,
              child: Text(
                value2,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                maxLines: 2,
                overflow: TextOverflow.fade,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  void _mostrarAlertInputs(BuildContext context, rid) {
    setState(() {
      _rid = rid;
    });
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              scrollable: true,
              title: Text('Seleccionar'),
              content: Container(
                child: Column(
                  children: [
                    _inputFechaInicio(context),
                    SizedBox(height: 20.0),
                    _inputHoraInicio(context),
                    SizedBox(height: 20.0),
                    _inputFechaFinal(context),
                    SizedBox(height: 20.0),
                    _inputHoraFinal(context),
                    SizedBox(height: 20.0),
                    _botonTerminar(context),
                  ],
                ),
              ));
        });
  }

  Widget _inputFechaInicio(BuildContext context) {
    return TextField(
        controller: _inputFechaInicialController,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            hintText: 'Fecha De Inicio',
            labelText: 'Fecha De Inicio',
            //suffixIcon: Icon(Icons.)
            icon: Icon(Icons.calendar_today)),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDateInicial(context);
        });
  }

  _selectDateInicial(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      setState(() {
        _inputFechaInicialController.text = generarFechaVistaNew(picked);
        _fInicialRequest = generarFecha(picked);
      });
      print("fecha inicial request " + _fInicialRequest.toString());
    }
  }

  Widget _inputHoraInicio(BuildContext context) {
    return TextField(
        enableInteractiveSelection: false,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            hintText: _timeInicial,
            labelText: _timeInicial,
            //suffixIcon: Icon(Icons.)
            icon: Icon(Icons.alarm)),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectHoraInicial(context);
        });
  }

  _selectHoraInicial(BuildContext context) async {
    TimeOfDay ti = await (showTimePicker(
        context: context,
        initialTime: _timeInicialController) as FutureOr<TimeOfDay>);
    String timeInicial =
        generarHoraSQL(DateTime(2000, 21, 01, ti.hour, ti.minute));

    if (timeInicial != null) {
      setState(() {
        _timeInicial = timeInicial;
      });
    }
  }

  _selectHoraFinal(BuildContext context) async {
    TimeOfDay tf = await (showTimePicker(
        context: context,
        initialTime: _timeFinalController) as FutureOr<TimeOfDay>);
    String timeFinal =
        generarHoraSQL(DateTime(2000, 21, 01, tf.hour, tf.minute));
    if (timeFinal != null) {
      setState(() {
        _timeFinal = timeFinal;
      });
    }
  }

  Widget _inputFechaFinal(BuildContext context) {
    return TextField(
        controller: _inputFechaFinalController,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            hintText: 'Fecha De Fin',
            labelText: 'Fecha De Fin',
            //suffixIcon: Icon(Icons.)
            icon: Icon(Icons.calendar_today)),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDateFinal(context);
        });
  }

  _selectDateFinal(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(
            _referenciaInicialToFinalAno == null
                ? _anoCondicional!
                : _referenciaInicialToFinalAno!,
            _referenciaInicialToFinalMes == null
                ? _mesCondicional!
                : _referenciaInicialToFinalMes!,
            _referenciaInicialToFinalDia == null
                ? _diaCondicional!
                : _referenciaInicialToFinalDia!),
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      var now = picked;
      var formatter = new DateFormat('dd/MM/yyyy');
      String fechaFinal = formatter.format(now);
      String formatoDia = fechaFinal.substring(0, 2);
      String formatoMes = fechaFinal.substring(3, 5);
      String formatoAno = fechaFinal.substring(6, 10);
      setState(() {
        _fechaFinalNewFormato = formatoAno + formatoMes + formatoDia;
      });

      setState(() {
        _inputFechaFinalController.text = generarFechaVistaNew(picked);
        _fFinalRequest = generarFecha(picked);
      });
      print("fecha final request " + _fFinalRequest);
    }
  }

  Widget _inputHoraFinal(BuildContext context) {
    return TextField(
        enableInteractiveSelection: false,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            hintText: _timeFinal,
            labelText: _timeFinal,
            //suffixIcon: Icon(Icons.)
            icon: Icon(Icons.alarm)),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectHoraFinal(context);
        });
  }

  Widget _botonTerminar(context) {
    return ButtonBar(
      children: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          color: Colors.red,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(); // To do
          },
        ),
        FlatButton(
          child: Text('OK'),
          color: Colors.green,
          onPressed: () {
            _confirmarFechasHoras(context);
          },
        ),
      ],
    );
  }

  _confirmarFechasHoras(BuildContext context) async {
    String requestD = _fFinalRequest + " " + _timeFinal!;
    String requestA = _fInicialRequest + " " + _timeInicial!;

    final httpProv = new HttpProvider();
    var res = await httpProv.confirmarInputsDate(_rid, requestD, requestA);
    print("PUESTA confirmarInputsDate: " + res.toString());
    Navigator.of(context, rootNavigator: true).pop(res);
    setState(() {});
  }
}
//PREVENTIVO PROCESO
