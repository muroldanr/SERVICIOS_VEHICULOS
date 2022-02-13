import 'dart:async';
import 'dart:ffi';

import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/src/models/causa_model.dart';
import 'package:best_flutter_ui_templates/src/models/descripcion_model.dart';
import 'package:best_flutter_ui_templates/src/models/mecanico_model.dart';
import 'package:best_flutter_ui_templates/src/models/origen_model.dart';
import 'package:best_flutter_ui_templates/src/models/refacciones_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_model.dart';
import 'package:best_flutter_ui_templates/src/pages/home_page.dart';
import 'package:best_flutter_ui_templates/src/utils/utils.dart';
import 'package:best_flutter_ui_templates/src/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CausaFallaValidar extends StatefulWidget {
  final SolicitudPendiente solicitud;
  CausaFallaValidar(this.solicitud);

  @override
  _CausaFallaValidarState createState() => _CausaFallaValidarState(solicitud);
}

class _CausaFallaValidarState extends State<CausaFallaValidar> {
  SolicitudPendiente solicitudPendiente;
  _CausaFallaValidarState(
    this.solicitudPendiente,
  );

  bool closeTopController = false;
  final httpProv = new HttpProvider();
  Origen? _opcionSeleccionadaOrigen = new Origen();
  Causa? _opcionSeleccionadaCausaOrigen = new Causa();
  TextEditingController _inputDescripcionCausaController =
      new TextEditingController();
  TextEditingController _inputRefaccionesController =
      new TextEditingController();
  TextEditingController _inputImporteController = new TextEditingController();
  TextEditingController _fechaInicialController = new TextEditingController();
  TextEditingController _fechaFinalController = new TextEditingController();
  TextEditingController _textKilometrosController = TextEditingController();
  Mecanico? _opcionSeleccionadaMecanico = new Mecanico();
  DateTime now = new DateTime.now();
  final formatCurrency = new NumberFormat.simpleCurrency();

  late Descripcion descripcion;
  String? descripcionArt;
  String? importe;
  String? _fecha;
  String? _descripcionProbelma;
  String? _timeInicial;
  String? _timeFinal;
  late TimeOfDay _timeInicialController;
  late TimeOfDay _timeFinalController;

  List<Origen> listaOrigen = [];
  List<Causa> listaCausaOrigen = [];
  List<Refacciones> listaRefacciones = [];
  List<Mecanico> listaMecanicos = [];
  String? _mecanicoSelected = "";
  String _fechaInicialRequest = "";
  String _fechaFinalRequest = "";

  int? _referenciaInicialToFinalAno;
  int? _referenciaInicialToFinalMes;
  int? _referenciaInicialToFinalDia;

  int? _diaCondicional;
  int? _mesCondicional;
  int? _anoCondicional;
  DateTime fechaCondicional = new DateTime.now();

  DateTime fechaInicial = new DateTime.now();
  DateTime fechaFinal = new DateTime.now();

  @override
  void initState() {
    super.initState();

    // _fechaInicialRequest = generarFechaSQL(DateTime.now());ANTES DEL API
    // _fechaFinalRequest = generarFechaSQL(DateTime.now()); ANTES DEL API

    _fechaInicialRequest = generarFechaVista(fechaInicial.day.toString(),
        fechaInicial.month.toString(), fechaInicial.year.toString());
    _fechaFinalRequest = generarFechaVista(fechaFinal.day.toString(),
        fechaFinal.month.toString(), fechaFinal.year.toString());
    print(_fechaInicialRequest);
    print(generarHoraSQL(DateTime.now()));
    _timeInicial = generarHoraSQL(DateTime.now());
    _timeFinal = generarHoraSQL(DateTime.now());

    _getCausaOrigen();
    _getListaMecanicos();
    descripcion = new Descripcion();
    _fecha = _getDateFormat(now);
    _fechaInicialController.text = _fecha!;
    _fechaFinalController.text = _fecha!;
    _timeInicialController = TimeOfDay.now();
    _timeFinalController = TimeOfDay.now();
    _diaCondicional = fechaCondicional.day;
    _mesCondicional = fechaCondicional.month;
    _anoCondicional = fechaCondicional.year;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: true,
      appBar: NavBarCustom("Refacciones Utilizadas"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _cardMecanico(),
            _getMedicionDesgaste(),
            _trabajoRealizado(),
            _fechaHoraInicio(),
            _fechaHoraFin(),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Refacciones Utilizadas",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: _listaRefacciones(listaRefacciones, context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          _sendRequest();
        },
      ),
    ));
  }

  _sendRequest() async {
    print("fechaInicial:  " + _fechaInicialRequest + " " + _timeInicial!);
    print(
      "fechaFinal:  " + _fechaFinalRequest + " " + _timeFinal!,
    );
    final List<Response>? resp = await (httpProv.spWebVentaActualizarOM(
        solicitudPendiente.id.toString(),
        _descripcionProbelma.toString(),
        _fechaInicialRequest + " " + _timeInicial!,
        _fechaFinalRequest + " " + _timeFinal!,
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

  Future<void> _showMessgeDialog(BuildContext context, String? text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: new Text(text == null ? 'Actulizado con éxito.' : text),
          actions: <Widget>[
            new TextButton(
                onPressed: () {
                  _regresar();
                },
                child: new Text("OK"))
          ],
        );
      },
    );
  }

  _regresar() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      _actualizarBoton();
    } else {
      SystemNavigator.pop();
    }
  }

  _actualizarBoton() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Widget _fechaHoraInicio() {
    return Container(
        margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                        controller: _fechaInicialController,
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            hintText: _fechaInicialController.text,
                            labelText: 'Fecha Inicio',
                            prefixIcon: Icon(Icons.calendar_today)),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _selectDateInicio(context);
                        }),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(10.0, 20.0, 15.0, 5.0),
                      width: 2.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                      )),
                  Flexible(
                      child: TextField(
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              hintText: _timeInicial,
                              labelText: _timeInicial,
                              prefixIcon: Icon(Icons.access_time)),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            _selectTimeInicial(context);
                          })),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _fechaHoraFin() {
    return Container(
        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: TextField(
                        controller: _fechaFinalController,
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            hintText: _fechaFinalController.text,
                            labelText: 'Fecha Fin',
                            prefixIcon: Icon(Icons.calendar_today)),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _selectDateFin(context);
                        }),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(10.0, 20.0, 15.0, 5.0),
                      width: 2.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                      )),
                  Flexible(
                      child: TextField(
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              hintText: _timeFinal,
                              prefixIcon: Icon(Icons.access_alarm)),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            _selectTimeFinal(context);
                          })),
                ],
              ),
            ],
          ),
        ));
  }

  _selectTimeInicial(BuildContext context) async {
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

  _selectTimeFinal(BuildContext context) async {
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

  _selectDateInicio(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      var now = picked;
      var formatter = new DateFormat('dd/MM/yyyy');
      String fechaInicial = formatter.format(now);
      print("FECHA INICIAL : " + fechaInicial);
      String formatoDia = fechaInicial.substring(0, 2);
      String formatoMes = fechaInicial.substring(3, 5);
      String formatoAno = fechaInicial.substring(6, 10);
      print("FORMATO DIA : " + formatoAno);
      print("FORMATO MES : " + formatoMes);
      print("FORMATO ANO : " + formatoDia);

      var dia = picked.day.toString();
      var mes = picked.month.toString();
      var ano = picked.year.toString();
      var hour = picked.hour.toString();
      var min = picked.minute.toString();
      var second = picked.second.toString();
      _referenciaInicialToFinalAno = picked.year;
      _referenciaInicialToFinalMes = picked.month;
      _referenciaInicialToFinalDia = picked.day;
      print("_referenciaInicialToFinalAno :" +
          _referenciaInicialToFinalAno.toString());
      print("_referenciaInicialToFinalMes :" +
          _referenciaInicialToFinalMes.toString());
      print("_referenciaInicialToFinalDia :" +
          _referenciaInicialToFinalDia.toString());
      print("FECHA INICO : " +
          dia +
          "-" +
          mes +
          "-" +
          ano +
          "-" +
          hour +
          "-" +
          min +
          "-" +
          second);
      setState(() {
        _fechaInicialController.text = generarFechaVista(dia, mes, ano);
        //_fechaInicialRequest = formatoAno + formatoMes + formatoDia; // ANTES DEL API
        _fechaInicialRequest = generarFechaVista(dia, mes, ano);
      });
      print("FECHA INICIAL NEW FORMATO : " + _fechaInicialRequest);
    }
  }

  _selectDateFin(BuildContext context) async {
    print("_referenciaInicialToFinalAno: " +
        _referenciaInicialToFinalAno.toString());
    print("_referenciaInicialToFinalMes: " +
        _referenciaInicialToFinalMes.toString());
    print("_referenciaInicialToFinalDia: " +
        _referenciaInicialToFinalDia.toString());
    print("dia" + _diaCondicional.toString());
    print("mes" + _mesCondicional.toString());
    print("ano" + _anoCondicional.toString());

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
      String fechaInicial = formatter.format(now);
      print("FECHA INICIAL : " + fechaInicial);
      String formatoDia = fechaInicial.substring(0, 2);
      String formatoMes = fechaInicial.substring(3, 5);
      String formatoAno = fechaInicial.substring(6, 10);
      print("FORMATO DIA : " + formatoAno);
      print("FORMATO MES : " + formatoMes);
      print("FORMATO ANO : " + formatoDia);

      var dia = picked.day.toString();
      var mes = picked.month.toString();
      var ano = picked.year.toString();
      var hour = picked.hour.toString();
      var min = picked.minute.toString();
      print("FECHA FIN  : " + dia + "-" + mes + "-" + ano);
      setState(() {
        _fechaFinalController.text = generarFechaVista(dia, mes, ano);
        //_fechaFinalRequest = formatoAno + formatoMes + formatoDia;
        _fechaFinalRequest = generarFechaVista(dia, mes, ano);
      });
      print("FECHA INICIAL NEW FORMATO : " + _fechaFinalRequest);
    }
  }

  Widget _trabajoRealizado() {
    return Container(
        margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
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
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              //autofocus: true,
              onChanged: (valor) => setState(() {
                _descripcionProbelma = valor.toString();
              }),
              keyboardType: TextInputType.text,
              cursorColor: Colors.green,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "Descripción del trabajo",
                labelText: "Trabajo Realizado",
                focusColor: Colors.green,
                hoverColor: Colors.green,
                fillColor: Colors.green,
              ),
            )));
  }

  Widget _cardMecanico() {
    return Container(
        margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
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
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "ASIGNA MECÁNICO",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
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
                          String? nombreMecanico = (mecanico.nombre!.isNotEmpty)
                              ? mecanico.nombre
                              : "Sin descripcion";
                          return new DropdownMenuItem<Mecanico>(
                            value: mecanico,
                            child: Text(
                              mecanico.nombre!,
                              style: TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  _setListRefacciones() async {
    final List<Refacciones> listaRef =
        await (httpProv.spWebSolicitudArtLista(solicitudPendiente.id.toString())
            as FutureOr<List<Refacciones>>);

    if (listaRef.length <= 0) {
    } else {
      if (listaRef[0].articulo != null) {
        setState(() {
          listaRefacciones = listaRef;
        });
      } else {
        setState(() {
          listaRefacciones = [];
        });
      }
    }
  }

  _setNewRefacciones() async {
    if (_inputRefaccionesController.text.isNotEmpty &&
        _inputImporteController.text.isNotEmpty) {
      final List<Response> listaRef = await (httpProv.spWebSolicitudArt(
          solicitudPendiente.id.toString(),
          _inputRefaccionesController.text,
          _inputImporteController.text,
          false) as FutureOr<List<Response>>);

      if (listaRef.length <= 0) {
      } else {
        if (listaRef[0].ok == null) {
          _setListRefacciones();
          setState(() {
            _inputImporteController.text = "";
            _inputRefaccionesController.text = "";
          });
        } else {}
      }
    }
  }

  Widget _servicioCardDetalle() {
    final widgetTemp = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
          height: 500.0,
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
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Descripción de la falla",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      onSaved: (value) {
                        descripcion.descripcion = value;
                      },
                      controller: _inputDescripcionCausaController,
                      decoration: const InputDecoration(
                        hintText:
                            'Describa la falla, tiene hasta 280 caracteres',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'El campo no puede ser vacio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Causa Origen",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    _getDropdownSistemaOrigen(),
                    SizedBox(height: 20.0),
                    Text(
                      "Sistema Origen",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20.0),
                    _getDropdownOrigen(),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                            controller: _inputRefaccionesController,
                            onSaved: (value) {
                              descripcionArt = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Refacciones utilizadas',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'El campo no puede ser vacio';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(5),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _inputImporteController,
                            onSaved: (value) {
                              importe = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Importe',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'El campo no puede ser vacio';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          padding: EdgeInsets.all(12),
                          child: OutlineButton(
                              child: new Text("+"),
                              onPressed: () => {
                                    _setNewRefacciones(),
                                  },
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0))),
                        ),
                      ],
                    ),
                  ])),
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
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    value2,
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

  _getCausaOrigen() async {
    final List<Causa> lista =
        await (httpProv.spWebServicioCausaLista() as FutureOr<List<Causa>>);

    if (lista.length <= 0) {
      _opcionSeleccionadaCausaOrigen = null;
      this.setState(() {
        listaCausaOrigen = [];
      });
    } else {
      _opcionSeleccionadaCausaOrigen = lista.first;
      this.setState(() {
        listaCausaOrigen = lista;
      });
    }
    _getSistemaOrigen();
  }

  _getSistemaOrigen() async {
    final List<Origen> lista =
        await (httpProv.spWebServicioOrigenLista() as FutureOr<List<Origen>>);

    if (lista.length <= 0) {
      _opcionSeleccionadaOrigen = null;
      listaOrigen = [];
    } else {
      _opcionSeleccionadaOrigen = lista.first;
      listaOrigen = lista;
    }
    _setListRefacciones();
  }

  Widget _getDropdownOrigen() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: DropdownButton<Origen>(
                isExpanded: true,
                value: _opcionSeleccionadaOrigen,
                hint: Text("Selecciona ..."),
                onChanged: (Origen? newValue) {
                  setState(() {
                    _opcionSeleccionadaOrigen = newValue;
                  });
                },
                items: listaOrigen.map((Origen origen) {
                  String? descripcion = (origen.origen!.isNotEmpty)
                      ? origen.origen
                      : "Sin descripcion";
                  return new DropdownMenuItem<Origen>(
                    value: origen,
                    child: new Text(
                      origen.origen!,
                      style: new TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDropdownSistemaOrigen() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: DropdownButton<Causa>(
                isExpanded: true,
                value: _opcionSeleccionadaCausaOrigen,
                hint: Text("Selecciona ..."),
                onChanged: (Causa? newValue) {
                  setState(() {
                    _opcionSeleccionadaCausaOrigen = newValue;
                  });
                },
                items: listaCausaOrigen.map((Causa causa) {
                  String? descripcion = (causa.causa!.isNotEmpty)
                      ? causa.causa
                      : "Sin descripcion";
                  return new DropdownMenuItem<Causa>(
                    value: causa,
                    child: new Text(
                      causa.causa!,
                      style: new TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _listaRefacciones(
      List<Refacciones> items, BuildContext context) {
    final List<Widget> servicios = [];

    if (items.length <= 0) {
      return [];
    }

    items.forEach((item) {
      final widgetTemp = Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
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
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 15.0, 15.0),
                child:
                    //(item.responsable == "") ? Center() :
                    Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  _getRow(item.articulo!, 0.30),
                  _getRow(formatCurrency.format(item.precio), 0.40),
                  Checkbox(
                    value: item.compra,
                    onChanged: (newValue) {
                      _actualizarArticulo(item, newValue);
                    },
                    //  <-- leading Checkbox
                  )
                ]),
              ),
            ),
          ),
        ],
      );

      servicios..add(widgetTemp);
    });

    return servicios;
  }

  Widget _getRow(String text, double porcent) {
    return Container(
      width: MediaQuery.of(context).size.width * porcent,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  _actualizarArticulo(Refacciones item, bool? option) async {
    final List<Response> lista = await (httpProv.spWebActualizarSolicitudArt(
            solicitudPendiente.id, item.renglon, option)
        as FutureOr<List<Response>>);

    if (lista.length <= 0) {
    } else {
      if (lista[0].ok == null) {
        _getCausaOrigen();
      } else {
        //  _openSnackBarWithoutAction(context ,lista[0].okRef) ;
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

  Widget _getMedicionDesgaste() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
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
}
//CORRECTIVO PROCESO
