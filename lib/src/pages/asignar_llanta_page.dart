import 'dart:async';

import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/models/equipo_transporte_model.dart';
import 'package:best_flutter_ui_templates/src/models/llanta_disponble_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/pages/home_page.dart';
import 'package:best_flutter_ui_templates/src/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:best_flutter_ui_templates/src/utils/DAWidgets.dart';

class AsignarLlantaPage extends StatefulWidget {
  final EquipoTransporte? vehiculo;
  final String posicion;

  AsignarLlantaPage(this.vehiculo, this.posicion);

  @override
  _AsignarLlantaPageState createState() =>
      _AsignarLlantaPageState(vehiculo, posicion);
}

class _AsignarLlantaPageState extends State<AsignarLlantaPage> {
  EquipoTransporte? vehiculo;
  String posicion;
  _AsignarLlantaPageState(this.vehiculo, this.posicion);
  List<LlantasDisponibles> llantasDisponibles = [];
  LlantasDisponibles? _opcionSeleccionadaLlanta;
  TextEditingController _inputFechaController = new TextEditingController();
  TextEditingController _inputFechaDelCambioController =
      new TextEditingController();
  TextEditingController _inputNeumaticoController = new TextEditingController();
  DateTime now = new DateTime.now();
  String? _fecha;
  String? _motivo;
  String? _descripcion;
  late String _kilometraje;
  bool _saving = false; //
  String? _neumaticoSelected = "";
  String _modeloSeleccionado = "";
  String _neumatico = "";
  List<LlantasDisponibles> llantasDisponiblesBuscado = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DaScaffoldLoading(
        isLoading: _saving,
        keyLoading: _scaffoldKey,
        children: <Widget>[
          Scaffold(
            appBar: NavBarCustom(
                vehiculo!.id.toString() + " - " + vehiculo!.articulo!),
            body: Container(
              child: _cardAsignarNeumatico(),
            ),
          ),
        ]);
  }

  @override
  void initState() {
    super.initState();
    _getListLlantas();
    setState(() {
      _fecha = _getDateFormat(now);
      _inputFechaController.text = _fecha!;
    });
  }

  _getListLlantas() async {
    final httpProv = new HttpProvider();
    var res = await (httpProv.spWebLlantaDisponibleLista('')
        as FutureOr<List<LlantasDisponibles>>);

    if (res.isNotEmpty) {
      setState(() {
        llantasDisponibles = res;
      });
    } else {
      llantasDisponibles = [];
    }
  }

  Widget _getDropdownLlantas() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: DropdownButton<LlantasDisponibles>(
                isExpanded: true,
                value: _opcionSeleccionadaLlanta,
                hint: Text("Selecciona ..."),
                onChanged: (LlantasDisponibles? newValue) {
                  setState(() {
                    _opcionSeleccionadaLlanta = newValue;
                  });
                },
                items: llantasDisponibles
                    .map((LlantasDisponibles llantaDisponible) {
                  return new DropdownMenuItem<LlantasDisponibles>(
                    value: llantaDisponible,
                    child: new Text(
                      llantaDisponible.llanta.toString() +
                          " - " +
                          llantaDisponible.marca.toString() +
                          " - " +
                          llantaDisponible.medida.toString(),
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

  Widget _cardAsignarNeumatico() {
    final widgetTemp = SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 20.0, 5.0),
            height: 550.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 5.0,
                  ),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //_getDropdownLlantas(),
                _widgetBucarNeumatico(),
                Divider(),
                _getRenglonNeumatico(),
                _getRenglonUno("NECESITO CAMBIARLO"),
                //_getRenglonTitulo("Motivo"),
                _getRenglonMotivo("Motivo"),
                //_getRenglonTitulo("Observaciones"),
                //_getRenglonDescripcion("Descripción del Problema"),
                _getRenglonKm("Km Inicial"),
                _botonAlta(),
                // _getRenglonEvidencias(),
              ],
            ),
          ),
        ],
      ),
    );

    return widgetTemp;
  }

  Widget _widgetBucarNeumatico() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.50,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, right: 5.0, left: 5.0, bottom: 5.0),
                  child: Text(
                    "Buscar Neumático",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.50,
                      color: DesignCourseAppTheme.darkerText,
                    ),
                  )),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.30,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, right: 5.0, left: 5.0, bottom: 5.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      _showChoiceDialogo(context);
                    },
                    backgroundColor: Colors.green,
                    child: Icon(Icons.search),
                  )),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Future<void> _showChoiceDialogo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Center(
                  child: Text("Selecciona un Neumático"),
                ),
                content: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  child: TextFormField(
                                    controller: _inputNeumaticoController,
                                    onSaved: (value) {
                                      _neumaticoSelected = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Buscar Neumático',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.10,
                                    child: GestureDetector(
                                      onTap: () {
                                        _requestBuscarNeumatico(context);
                                        FocusScopeNode currentFocus =
                                            FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                      },
                                      child: Icon(Icons.search),
                                    )),
                              ],
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      initiallyExpanded: true,
                                      title: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 2),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Center(
                                                  child: Container(
                                                    child: Text("Neumáticos"),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.70,
                                          height: 260.0,
                                          margin: EdgeInsets.only(bottom: 15.0),
                                          child: _getListaNeumaticos(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  new TextButton(
                      onPressed: () {
                        _regresar();
                      },
                      child: new Text("Cancelar")),
                ],
              );
            },
          );
        });
  }

  _requestBuscarNeumatico(BuildContext context) async {
    final httpProv = new HttpProvider();

    final List<LlantasDisponibles>? lista = await (httpProv
        .spWebLlantaDisponibleLista(_inputNeumaticoController.text.isEmpty
            ? ''
            : _inputNeumaticoController.text.toString()));

    if (lista!.isNotEmpty) {
      setState(() {
        _opcionSeleccionadaLlanta = lista[0];
        llantasDisponiblesBuscado = lista;
      });
    } else {
      llantasDisponiblesBuscado = [];
      _opcionSeleccionadaLlanta = null;
    }
  }

  Widget _getListaNeumaticos(BuildContext context) {
    final httpProv = new HttpProvider();
    return FutureBuilder(
      future: httpProv.spWebLlantaDisponibleLista(
          _inputNeumaticoController.text.isEmpty
              ? ''
              : _inputNeumaticoController.text.toString()),
      builder: (BuildContext context,
          AsyncSnapshot<List<LlantasDisponibles>?> snapshot) {
        if (snapshot.hasData) {
          return ListView(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20.0, bottom: 0.0),
              children: _listNeumatico(snapshot.data!, context));
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  _regresar() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }

  List<Widget> _listNeumatico(
      List<LlantasDisponibles> items, BuildContext context) {
    final List<Widget> neumatico = [];

    items
      ..asMap().forEach((index, item) {
        final widgetTemp = Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: GestureDetector(
                onTap: () {
                  print("NEUMATICO LLANTA : " + item.llanta.toString());
                  print("NEUMATICO MARCA : " + item.marca.toString());
                  setState(() {
                    _modeloSeleccionado =
                        item.llanta.toString() + " - " + item.marca.toString();
                    _neumatico = item.llanta.toString();
                  });
                  print(_modeloSeleccionado.toString());
                  if (Navigator.canPop(context)) {
                    Navigator.pop(
                      context,
                    );
                  }
                  // _regresarDos(item.proveedor.toString(), item.nombre.toString());
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 8.0),
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
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item.llanta! + " - " + item.marca!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          letterSpacing: 0.15,
                          color: DesignCourseAppTheme.darkerText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
          ],
        );

        neumatico..add(widgetTemp);
      });

    return neumatico;
  }

  Widget _getRenglonUno(value1) {
    var now = DateTime.now();
    var dt = DateTime(now.day, now.month, now.year);
    String _formattetime = DateFormat.yMMM().format(dt);

    return Container(
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Flexible(
                          child: Padding(
                          padding: const EdgeInsets.all( 10.0),
                          child: TextField(
                            //autofocus: true,
                            onChanged: (valor) => setState(() {
                              valor = vehiculo.id.toString();
                            }),
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.green,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),),
                              hintText: vehiculo.id.toString(),
                              labelText: vehiculo.id.toString() +" - "+vehiculo.articulo,
                              enabled: false,
                              focusColor: Colors.green,
                              hoverColor: Colors.green,
                              fillColor: Colors.green,
                            ),
                          )
                        ),
                      ),*/
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                    controller: _inputFechaController,
                    enableInteractiveSelection: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: 'Fecha',
                        labelText: 'Fecha',
                        //suffixIcon: Icon(Icons.)
                        prefixIcon: Icon(Icons.calendar_today)),
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _selectDate(context);
                    }),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _getRenglonTitulo(value1) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Center(
                      child: Text(
                        value1,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget _getRenglonNeumatico() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, right: 5.0, left: 5.0, bottom: 5.0),
                  child: TextField(
                    //autofocus: true,
                    onChanged: (valor) => setState(() {
                      _motivo = valor.toString();
                    }),
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.green,
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Neumático',
                      labelText: _modeloSeleccionado.isEmpty
                          ? 'Selecciona Neumático'
                          : _modeloSeleccionado,
                      focusColor: Colors.green,
                      hoverColor: Colors.green,
                      fillColor: Colors.green,
                    ),
                  )),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _getRenglonMotivo(value1) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, right: 5.0, left: 5.0, bottom: 5.0),
                  child: TextField(
                    //autofocus: true,
                    onChanged: (valor) => setState(() {
                      _motivo = valor.toString();
                    }),
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: value1,
                      labelText: value1,
                      focusColor: Colors.green,
                      hoverColor: Colors.green,
                      fillColor: Colors.green,
                    ),
                  )),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _getRenglonDescripcion(value1) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, right: 5.0, left: 5.0, bottom: 5.0),
                  child: TextField(
                    //autofocus: true,
                    onChanged: (valor) => setState(() {
                      _descripcion = valor.toString();
                    }),
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: value1,
                      labelText: value1,
                      focusColor: Colors.green,
                      hoverColor: Colors.green,
                      fillColor: Colors.green,
                    ),
                  )),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _getRenglonKm(value1) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, right: 5.0, left: 5.0, bottom: 5.0),
                  child: TextField(
                    //autofocus: true,
                    onChanged: (valor) => setState(() {
                      _kilometraje = valor;
                    }),
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: value1,
                      labelText: value1,
                      focusColor: Colors.green,
                      hoverColor: Colors.green,
                      fillColor: Colors.green,
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  /*Widget _getRenglonEvidencias() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.50,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: FloatingActionButton(
            onPressed: () {
              _showChoiceDialog(context);
            },
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );
  }*/

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime.now(),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      var dia = picked.day.toString();
      var mes = picked.month.toString();
      var ano = picked.year.toString();
      print("FECHA  : " + dia + "-" + mes + "-" + ano);
      var fecha = dia + "-" + mes + "-" + ano;
      setState(() {
        _fecha = fecha.toString();
        _inputFechaController.text = _fecha!;
      });
    }
  }

  Widget _botonAlta() {
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
              onTap: () => _altaLlanta(),
              child: Center(
                child: Text(
                  "Alta",
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

  _altaLlanta() async {
    _saving = true;
    print("AQUI");
    print(vehiculo!.id.toString());
    print(_neumatico.toString());
    print(int.parse(posicion));
    print(_motivo.toString());
    print(int.parse(_kilometraje));

    final httpProv = new HttpProvider();
    var res = await (httpProv.spWebAsignaLlanta(
        vehiculo!.id.toString(),
        _neumatico.toString(),
        int.parse(posicion),
        _motivo.toString(),
        int.parse(_kilometraje),
        "0.0") as FutureOr<List<Response>>);
    _saving = true;

    _showMessgeDialogAsigna(context, res[0].okRef.toString());
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

  Future<void> _showMessgeDialogAsigna(context, messageResponseImage) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: new Text("Solicitud Ticket"),
          content: new Text('$messageResponseImage'),
          actions: <Widget>[
            new TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(),
                    ),
                  );
                },
                child: new Text("Ok"))
          ],
        );
      },
    );
  }
}
