import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/hotel_booking/hotel_app_theme.dart';
import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/models/activos_fijo_model.dart';
import 'package:best_flutter_ui_templates/src/models/operador_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_ruta.dart';
import 'package:best_flutter_ui_templates/src/models/servicio_tipo_model.dart';
import 'package:best_flutter_ui_templates/src/models/tipo_operacion.dart';
import 'package:best_flutter_ui_templates/src/models/tipo_orden_model.dart';
import 'package:best_flutter_ui_templates/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_switch/flutter_switch.dart';

class TicketFormulario extends StatefulWidget {
  final Function _function;
  final ScrollController scrollController = ScrollController();
  final CategoryType categoryType = CategoryType.ui;
  TicketFormulario(this._function);

  @override
  _TicketFormularioState createState() => _TicketFormularioState();
}

class _TicketFormularioState extends State<TicketFormulario> {
  ScrollController scrollController = ScrollController();
  CategoryType categoryType = CategoryType.ui;
  bool correctivo = false;
  bool maquinaria = false;
  String _observaciones = "";
  List<ActivosFijos> listaActivosFijos = [];
  List<Operador> listaOperadores = [];
  List<TipoOperacion> listaTipoOperacion = [];
  List<ServicioTipo> listaServicioTipo = [];
  final httpProv = new HttpProvider();
  String? _responsable = "";
  String? _operacionSelected = "";
  bool _horometroActivado = false;

  ActivosFijos? _opcionSeleccionadaActivo = new ActivosFijos();
  Operador? _opcionSeleccionadaOperador = new Operador();
  ServicioTipo? _opcionSeleccionadaServicioTipo = new ServicioTipo();
  TipoOperacion? _opcionSeleccionadaTipoOperacion = new TipoOperacion();
  TextEditingController _textKilometrosController = TextEditingController();

  File? imageFile;
  String? prioridad;
  String _tipoPrioridad = 'BAJA';
  bool _condicional = false;
  bool _condicionalBotones = false;
  bool _condicionalTipoOperacion = false;
  bool _mostrarTipoOperacion = false;
  bool? _stateBootones;
  bool _condicionalServicioTipo = false;
  PickedFile? _imageFile;
  dynamic _pickImageError;
  String? _ruta = null;
  String? _nameImage = '';
  bool decidir = false;
  String categoria = 'TRANSPORTE';
  String _solicitudRef = '';
  @override
  void initState() {
    super.initState();
    _getTipoOperacion();
    _getActivoFijo(false);
  }

  _getTipoOperacion() async {
    final List<TipoOperacion>? lista = await (httpProv.postTipoOperacion());

    if (lista!.length <= 0) {
      _opcionSeleccionadaTipoOperacion = null;
      listaTipoOperacion = [];
      _operacionSelected = "";
    } else {
      _opcionSeleccionadaTipoOperacion = lista[0];
      _operacionSelected = _opcionSeleccionadaTipoOperacion!.tipoOperacion;
      listaTipoOperacion = lista;
    }
  }

  _getActivoFijo(bool value) async {
    setState(() {
      categoria = 'TRANSPORTE';
    });
    if (value) {
      setState(() {
        categoria = 'MAQUINARIA';
      });
      _horometroActivado = true;
    } else {
      _horometroActivado = false;
    }

    final List<ActivosFijos>? lista = await (httpProv.getActivoFijo(categoria));

    if (lista!.length <= 0) {
      _opcionSeleccionadaActivo = null;
      listaActivosFijos = [];
      _responsable = "";
    } else {
      _responsable = _opcionSeleccionadaActivo!.responsableNombre;
      listaActivosFijos = lista;
      listaActivosFijos.insert(
          0,
          ActivosFijos(
              articulo: '',
              categoria: '',
              descripcion1: categoria.toString(),
              observaciones: '',
              responsable: '',
              responsableNombre: '',
              serie: 'SELECCIONAR ACTIVO FIJO'));
      print("SOY LA LISTA" + listaActivosFijos[0].descripcion1!);
      print("SOY LA LISTA" + listaActivosFijos[0].serie.toString());
      _opcionSeleccionadaActivo = listaActivosFijos[0];
    }

    setState(() {
      maquinaria = value;
    });
  }

  _getOperadores() async {
    String activoSeleccionado = "";
    log("ENTRO AQUI --uno-- " + _opcionSeleccionadaActivo!.serie.toString());

    if (_opcionSeleccionadaActivo!.serie.toString() ==
        "SELECCIONAR ACTIVO FIJO") {
      log("ENTRO AQUI IF " + _opcionSeleccionadaActivo!.serie.toString());
      activoSeleccionado = "";
    } else {
      log("ENTRO AQUI ELSE " + _opcionSeleccionadaActivo!.serie.toString());
      activoSeleccionado = _opcionSeleccionadaActivo!.serie.toString();
    }
    log("RESULTADO activoSeleccionado " + activoSeleccionado.toString());
    final List<Operador>? lista =
        await (httpProv.getOperadores(activoSeleccionado.toString()));

    if (lista!.length <= 0) {
      _opcionSeleccionadaOperador = null;
      listaOperadores = [];
    } else {
      listaOperadores = lista;
      _opcionSeleccionadaOperador = listaOperadores[0];
    }
  }

  _getServicioTipo(bool value) async {
    String? serie = _opcionSeleccionadaActivo!.serie;
    String? articulo = _opcionSeleccionadaActivo!.articulo;
    String tipo = 'Preventivo';
    if (value) {
      tipo = 'Mantenimiento';
    }

    final List<ServicioTipo>? lista =
        await (httpProv.getServicioTipo(serie, articulo, tipo));

    if (lista!.length <= 0) {
      _opcionSeleccionadaServicioTipo = null;
      listaServicioTipo = [];
    } else {
      _opcionSeleccionadaServicioTipo = lista[0];
      listaServicioTipo = lista;
    }
    setState(() {
      correctivo = value;
    });
  }

  _setVentaSolicitudCorrectivo(context) async {
    widget._function(true);
    String? serie = _opcionSeleccionadaActivo!.serie;
    String? articulo = _opcionSeleccionadaActivo!.articulo;
    String tipo = (correctivo == true) ? 'Mantenimiento' : 'Preventivo';
    String? tipoOrden = (correctivo == true)
        ? _opcionSeleccionadaTipoOperacion!.tipoOperacion
        : _opcionSeleccionadaServicioTipo!.descripcion;
    String? tipoClave = _opcionSeleccionadaServicioTipo!.servicio;
    String kilometros = _textKilometrosController.text.toString();
    String? operador = _opcionSeleccionadaOperador!.operador;

    print("ServicioSerie : " + serie.toString());
    print("ServicioArticulo : " + articulo.toString());
    print("ServicioTipoOrden : " + tipo.toString());
    print("TipoOperacion : " + tipoOrden.toString());
    print("ServicioTipo : " + tipoClave.toString());
    print("Observaciones : " + _observaciones.toString());
    print("Prioridad : " + _tipoPrioridad.toString());
    print("Kilometros : " + kilometros.toString());
    print("Operador : " + operador.toString());
    var now = new DateTime.now();
    var formatter = new DateFormat('dd_MM_yyyy');
    var formatterHora = new DateFormat('HH_mm');
    String today = formatter.format(now);
    String hora = formatterHora.format(now);

    final List<Response> lista = await httpProv.sptVentaSolicitud(
        serie!,
        articulo!,
        tipo,
        tipoOrden!,
        tipoClave!,
        _observaciones,
        _tipoPrioridad.toString(),
        kilometros.toString(),
        operador.toString());

    if (lista[0].ok != "null") {
      _showMessgeDialogoPreventivo(
          context, lista[0].ok.toString(), lista[0].okRef.toString());
      print("B: " + lista[0].okRef.toString());
      setState(() {
        _solicitudRef = lista[0].okRef.toString();
      });
    } else {
      try {
        if (lista[0].ok == "null" && _imageFile!.path != null) {
          print("MOVIMIENTO: " + lista[0].okRef.toString());
          print("MODULO ID: " + lista[0].moduloId.toString());
          print("ORDEN GENERADA: " + lista[0].ordenGenerada.toString());
          widget._function(false);
          String? nombre = lista[0].okRef.substring(0, 20);
          setState(() {
            _nameImage = nombre;
            _solicitudRef = lista[0].okRef.toString();
          });
          print("MOVIMIENTO: " + lista[0].okRef.toString());
          _getPahForImage(context, lista[0].okRef, lista[0].moduloId);
        }
      } catch (e) {
        setState(() {
          _solicitudRef = lista[0].okRef.toString();
        });
        _showMessgeDialogoPreventivo(
            context, lista[0].ok.toString(), lista[0].okRef.toString());
      }
    }
  }

  _setVentaSolicitudPreventivo(context) async {
    widget._function(true);
    String? serie = _opcionSeleccionadaActivo!.serie;
    String? articulo = _opcionSeleccionadaActivo!.articulo;
    String tipo = (correctivo == true) ? 'Mantenimiento' : 'Preventivo';
    String? tipoOrden = (correctivo == true)
        ? _opcionSeleccionadaTipoOperacion!.tipoOperacion
        : _opcionSeleccionadaServicioTipo!.descripcion;
    String? tipoClave = _opcionSeleccionadaServicioTipo!.servicio;
    String kilometros = _textKilometrosController.text.toString();
    String operador = _opcionSeleccionadaOperador!.operador.toString();
    print("ServicioSerie : " + serie.toString());
    print("ServicioArticulo : " + articulo.toString());
    print("ServicioTipoOrden : " + tipo.toString());
    print("TipoOperacion : " + tipoOrden.toString());
    print("ServicioTipo : " + tipoClave.toString());
    print("Observaciones : " + _observaciones.toString());
    print("Prioridad : " + _tipoPrioridad.toString());
    print("Kilometros : " + kilometros.toString());
    print("Operador: " + operador.toString());

    final List<Response> lista = await httpProv.sptVentaSolicitud(
        serie!,
        articulo!,
        tipo,
        tipoOrden!,
        tipoClave!,
        _observaciones,
        _tipoPrioridad.toString(),
        kilometros.toString(),
        operador.toString());

    if (lista.length <= 0) {
    } else {
      if (lista[0].ok != null) {
        setState(() {
          _solicitudRef = lista[0].okRef.toString();
        });
        _showMessgeDialogoPreventivo(
            context, lista[0].ok.toString(), lista[0].okRef.toString());
      } else {
        setState(() {
          _solicitudRef = lista[0].okRef.toString();
        });
        widget._function(false);
        _showMessgeDialogoCorrectivo(context, lista[0].okRef);
      }
    }
  }

  _getPahForImage(context, messageResponse, moduloId) async {
    widget._function(true);
    print("MODULO ID : " + moduloId.toString());
    final List<ResponseRuta>? res =
        await (httpProv.spWebRutaAlmacenarAnexos(moduloId.toString()));

    if (res!.isNotEmpty) {
      if (res[0].okRef == null && res[0].ruta != null) {
        widget._function(false);
        setState(() {
          _ruta = res[0].ruta;
        });
        sendImage(context, messageResponse, moduloId);
      } else {
        /* setState(() {
          _saving = false;
        });*/
      }
    }
  }

  Future<void> sendImage(context, messageResponse, moduloId) async {
    widget._function(true);

    /*
    print("RUTA : " + _ruta);
    print('Original path: ${_imageFile.path}');
    String dir = path.dirname(_imageFile.path);
    String newPath = path.join(dir, _nameImage + '.jpg');
    print('New path: $newPath');
    File(_imageFile.path).renameSync(newPath);
    print('ARchivo: ${_imageFile.path}');*/

    print(moduloId.toString());
    List<int>? bytes = null;
    String ext = "";
    String mimeType = "";

    bytes = File(_imageFile!.path).readAsBytesSync();
    ext = '.jpg';
    mimeType = "image/jpeg";

    String img64 = base64Encode(bytes);
    String movString = messageResponse.substring(0, 20);
    String idMovString = messageResponse.substring(20, 24);

    int idMov = int.parse(idMovString);
    String fileType = "data:image/jpeg;base64," + img64;

    print("MOV STRING: " + movString);
    print("MOV ID: " + idMovString);

    var res = await (httpProv.anexos(
        idMov, _ruta, movString, _nameImage! + ext, ext, mimeType, fileType));

    if (res!.ok == "null" || res!.ok == null) {
      saveRutaERP(context, messageResponse, moduloId);
      widget._function(false);
    } else if (res.ok == "-1" || res.ok == -1) {
      saveRutaERP(context, messageResponse, moduloId);
      widget._function(false);
    } else {
      print("hasta aquì lleguè");
      widget._function(false);
    }

    /*var res = await httpProv.upload(File(newPath), _ruta);
    print(res);
    if (res) {
      widget._function(false);
      saveRutaERP(context, messageResponse, moduloId);
    } else {
      widget._function(false);
    }*/
  }

  saveRutaERP(context, messageResponse, moduloId) async {
    widget._function(true);

    String? idMovString = messageResponse.substring(21, 24);

    var res = await (httpProv.spWebAnexoMovServicio(
        moduloId.toString(),
        idMovString.toString() + "_" + _nameImage! + '.jpg',
        _ruta! + "/" + idMovString.toString() + "_" + _nameImage! + '.jpg',
        'Imagen'));

    print(_ruta! + "/" + idMovString.toString() + "_" + _nameImage! + '.jpg');

    if (res!.isNotEmpty) {
      if (res[0].ok == "null" || res[0].ok == null) {
        print("respuesta okRef : " + res[0].okRef.toString());
        widget._function(false);
        setState(() {
          _ruta = null;
          _nameImage = null;
          _imageFile = null;
        });
        _showMessgeDialogoPreventivo(
            context, messageResponse, res[0].okRef.toString());
      } else {
        print("saveRutaERP  ELSE: " + res[0].ok);
        widget._function(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: !_condicional,
                    title: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 2),
                        child: Row(
                          children: <Widget>[
                            _condicional
                                ? Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.airport_shuttle_outlined,
                                            color: Color(0xff000000), size: 40),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.40,
                                          child: FlutterSwitch(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.50,
                                            height: 20.0,
                                            toggleSize: 30.0,
                                            value: maquinaria,
                                            borderRadius: 30.0,
                                            activeColor: Colors.green,
                                            padding: 1.0,
                                            onToggle: (bool value) {
                                              _getActivoFijo(value);
                                            },
                                          ),
                                        ),
                                        Icon(Icons.build_circle,
                                            color: Color(0xff000000), size: 40),
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: Center(
                                      child: Text(
                                        'VEHÍCULO / MAQUINARIA',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          letterSpacing: 0.27,
                                          color:
                                              DesignCourseAppTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        )),
                    children: [
                      _condicional
                          ? Text("")
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, top: 4, bottom: 4),
                              child: Column(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, top: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(Icons.airport_shuttle_outlined,
                                                color: Color(0xff000000),
                                                size: 40),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.60,
                                              child: FlutterSwitch(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.50,
                                                height: 20.0,
                                                toggleSize: 30.0,
                                                value: maquinaria,
                                                borderRadius: 30.0,
                                                activeColor: Colors.green,
                                                padding: 1.0,
                                                onToggle: (bool value) {
                                                  _getActivoFijo(value);
                                                },
                                              ),
                                            ),
                                            Icon(Icons.build_circle,
                                                color: Color(0xff000000),
                                                size: 40),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Divider(),
                                  ],
                                )
                              ]),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            (_condicional == false)
                ? Center(
                    child: SizedBox(height: 1.0),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 16),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                HotelAppTheme.buildLightTheme().backgroundColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(38.0),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: const Offset(0, 2),
                                  blurRadius: 8.0),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 0.0),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 10, bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        "ACTIVO FIJO SELECCIONADO",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            letterSpacing: 0.27,
                                            //overflow: TextOverflow.ellipsis,
                                            color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 10, bottom: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                        child: Text(
                                      _opcionSeleccionadaActivo!.serie! +
                                          "-" +
                                          _opcionSeleccionadaActivo!
                                              .descripcion1
                                              .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0,
                                        letterSpacing: 0.27,
                                        color: DesignCourseAppTheme.darkerText,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 16,
                                        right: 16,
                                        bottom: 15),
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "SELECCIONA OPERADOR",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              letterSpacing: 0.27,
                                              color: Colors.green,
                                            ),
                                          ),
                                          //_getDropdownActivosFijos(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Center(child: _getDropdownOperadores()),
                                ],
                              ),
                            ]),
                          ),
                        ),
                        Positioned(
                          right: 0.0,
                          bottom: 15.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _responsable = "";
                                _condicional = false;
                              });
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                radius: 14.0,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 4, top: 4, bottom: 4),
                  child: Column(children: [
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: (_condicional)
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 0.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _horometroActivado == true
                                                ? "HOROMETRAJE"
                                                : "KILOMETRAJE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              letterSpacing: 0.27,
                                              color: DesignCourseAppTheme
                                                  .darkerText,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0,
                                                  right: 20.0,
                                                  left: 5.0,
                                                  bottom: 5.0),
                                              child: TextField(
                                                autofocus: false,
                                                controller:
                                                    _textKilometrosController,
                                                //autofocus: true,
                                                onChanged: (valor) =>
                                                    setState(() {}),
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor: Colors.green,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  hintText: "Cantidad ",
                                                  labelText:
                                                      _horometroActivado == true
                                                          ? "Horómetro "
                                                          : "Kilometros",
                                                  suffix:
                                                      _horometroActivado == true
                                                          ? Text("Hrs")
                                                          : Text("Kms"),
                                                  focusColor: Colors.green,
                                                  hoverColor: Colors.green,
                                                  fillColor: Colors.green,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : _condicional
                                ? SizedBox(height: 0.1)
                                : _getDropdownActivosFijos(),
                        children: [SizedBox(height: 0.1)],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 4, right: 4, top: 4, bottom: 4),
                  child: Column(children: [
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: _condicionalTipoOperacion
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Color(0xff000000),
                                    size: 40,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    child: FlutterSwitch(
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      height: 20.0,
                                      toggleSize: 30.0,
                                      value: correctivo,
                                      borderRadius: 30.0,
                                      activeColor: Colors.green,
                                      padding: 1.0,
                                      onToggle: (bool value) {
                                        _getServicioTipo(value);
                                        setState(() {
                                          decidir = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Icon(Icons.car_repair,
                                      color: Color(0xff000000), size: 40),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, top: 5.0, bottom: 2),
                                child: Row(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        'PREVENTIVO / CORRECTIVO',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          letterSpacing: 0.27,
                                          color:
                                              DesignCourseAppTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                        children: [
                          _condicionalTipoOperacion
                              ? SizedBox(height: 1.0)
                              : Stack(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 0, bottom: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.date_range,
                                              color: Color(0xff000000),
                                              size: 40,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.60,
                                              child: FlutterSwitch(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.50,
                                                height: 20.0,
                                                toggleSize: 30.0,
                                                value: correctivo,
                                                borderRadius: 30.0,
                                                activeColor: Colors.green,
                                                padding: 1.0,
                                                onToggle: (bool value) {
                                                  _getServicioTipo(value);
                                                  setState(() {
                                                    decidir = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            Icon(Icons.car_repair,
                                                color: Color(0xff000000),
                                                size: 40),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            correctivo
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 5.0, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HotelAppTheme.buildLightTheme().backgroundColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(38.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey,
                              offset: const Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 4, right: 4, top: 4, bottom: 4),
                        child: Column(children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              initiallyExpanded: false,
                              title: correctivo
                                  ? Column(
                                      children: [
                                        _condicionalTipoOperacion
                                            ? _crearObrevaciones()
                                            : _getDropdownTipoOperacion(),
                                      ],
                                    )
                                  : correctivo && _condicionalTipoOperacion
                                      ? Column(
                                          children: [
                                            SizedBox(height: 1.0),
                                          ],
                                        )
                                      : SizedBox(height: 1.0),
                              children: [
                                correctivo
                                    ? Column(
                                        children: [
                                          Divider(),
                                          //_crearObrevaciones(),
                                        ],
                                      )
                                    : correctivo && _condicionalTipoOperacion
                                        ? Column(
                                            children: [
                                              Text(""),
                                            ],
                                          )
                                        : Text(""),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HotelAppTheme.buildLightTheme().backgroundColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(38.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey,
                              offset: const Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 4, right: 4, top: 4, bottom: 4),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            initiallyExpanded: false,
                            title:
                                Column(children: [_getDropdownServicioTipo()]),
                            children: [SizedBox(height: 1.0)],
                          ),
                        ),
                      ),
                    ),
                  ),
            (_condicionalTipoOperacion)
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 16),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                HotelAppTheme.buildLightTheme().backgroundColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(38.0),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: const Offset(0, 2),
                                  blurRadius: 8.0),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 0.0),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 15),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      "NOMENCLATURA : ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        letterSpacing: 0.27,
                                        color: DesignCourseAppTheme.darkerText,
                                      ),
                                    )),
                                    Expanded(
                                        child: Text(
                                      _opcionSeleccionadaTipoOperacion!
                                          .tipoOperacion
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        letterSpacing: 0.27,
                                        color: DesignCourseAppTheme.darkerText,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                        Positioned(
                          right: 0.0,
                          bottom: 15.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _responsable = "";
                                _condicionalTipoOperacion = false;
                              });
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                radius: 14.0,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
                : (correctivo == false && _condicionalServicioTipo == true)
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 10, bottom: 16),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: HotelAppTheme.buildLightTheme()
                                    .backgroundColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(38.0),
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: const Offset(0, 2),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 36),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(
                                        "TIPO ",
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          letterSpacing: 0.27,
                                          color:
                                              DesignCourseAppTheme.darkerText,
                                        ),
                                      )),
                                      Expanded(
                                          child: Text(
                                        _opcionSeleccionadaServicioTipo!
                                            .descripcion
                                            .toString(),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          letterSpacing: 0.10,
                                          color:
                                              DesignCourseAppTheme.darkerText,
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            Positioned(
                              right: 0.0,
                              bottom: 15.0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _responsable = "";
                                    _condicionalServicioTipo = false;
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                    radius: 14.0,
                                    backgroundColor: Colors.grey,
                                    child:
                                        Icon(Icons.close, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
                    : Center(
                        child: SizedBox(height: 1.0),
                      ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey,
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 4, right: 4, top: 4, bottom: 4),
                  child: Column(children: [
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 15),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Prioridad",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  letterSpacing: 0.27,
                                  color: DesignCourseAppTheme.darkerText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                getButtonUI(CategoryType.ui,
                                    categoryType == CategoryType.ui),
                                const SizedBox(
                                  width: 16,
                                ),
                                getButtonUI(CategoryType.coding,
                                    categoryType == CategoryType.coding),
                                const SizedBox(
                                  width: 16,
                                ),
                                getButtonUI(CategoryType.basic,
                                    categoryType == CategoryType.basic),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Center(
              child: Row(
                children: [
                  Container(
                    width: correctivo
                        ? MediaQuery.of(context).size.width * 0.50
                        : 0,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: correctivo
                            ? FloatingActionButton(
                                heroTag: "btn_camara",
                                onPressed: () {
                                  _showChoiceDialog(context);
                                },
                                child: Icon(Icons.camera_alt),
                                backgroundColor: Colors.green,
                              )
                            : Container()),
                  ),
                  Container(
                    width: correctivo
                        ? MediaQuery.of(context).size.width * 0.50
                        : MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: FloatingActionButton(
                        heroTag: "btn_listo",
                        onPressed: () {
                          if (_textKilometrosController.text.isNotEmpty &&
                              _opcionSeleccionadaActivo != null &&
                              _opcionSeleccionadaServicioTipo != null &&
                              _opcionSeleccionadaOperador!.operador != null &&
                              correctivo) {
                            _setVentaSolicitudCorrectivo(context);
                          } else if (_textKilometrosController
                                  .text.isNotEmpty &&
                              _opcionSeleccionadaActivo != null &&
                              _opcionSeleccionadaServicioTipo != null &&
                              _opcionSeleccionadaOperador!.operador != null &&
                              correctivo == false) {
                            _setVentaSolicitudPreventivo(context);
                          }
                        },
                        child: Icon(Icons.check_box_rounded),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: correctivo ? _decideImageView() : Container(),
            ),
          ],
        )
      ],
    ));
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown(List<TipoOrden> data) {
    List<DropdownMenuItem<String>> lista = [];
    data.forEach((item) {
      lista.add(DropdownMenuItem(
        child: Text(item.tipoOperacion!),
        value: item.tipoOperacion,
      ));
    });

    return lista;
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("Selecciona"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextButton.icon(
                  label: Text('Galeria'),
                  icon: Icon(Icons.photo_album),
                  onPressed: () {
                    widget._function(true);
                    _openGalery(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xffd30051),
                    primary: Colors.white,
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontStyle: FontStyle.normal),
                  ),
                ),
                SizedBox(height: 15.0),
                TextButton.icon(
                  label: Text('Càmara'),
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    _openCamera(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    primary: Colors.white,
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontStyle: FontStyle.normal),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMessgeDialogoCorrectivo(context, text) {
    print("Solicitud Ticket A");
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: new Text("Solicitud Ticket"),
          content: new Text(_solicitudRef),
          actions: <Widget>[
            new TextButton(
                onPressed: () {
                  if (correctivo) {
                    setState(() {
                      _condicional = false;
                      _textKilometrosController.text = "";
                      correctivo = false;
                      _observaciones = "";
                      _condicionalTipoOperacion = false;
                      imageFile = null;
                    });
                  } else {
                    setState(() {
                      _condicional = false;
                      _textKilometrosController.text = "";
                      _observaciones = "";
                      _condicionalTipoOperacion = false;
                      imageFile = null;
                    });
                  }
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
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

  Future<void> _showMessgeDialogoPreventivo(
      context, text, messageResponseImage) {
    print("Solicitud Ticket B");
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: new Text("Solicitud Ticket"),
          content: new Text(_solicitudRef),
          actions: <Widget>[
            new TextButton(
                onPressed: () {
                  if (correctivo) {
                    setState(() {
                      _condicional = false;
                      _textKilometrosController.text = "";
                      correctivo = false;
                      _observaciones = "";
                      _condicionalTipoOperacion = false;
                      imageFile = null;
                      maquinaria = false;
                    });
                  } else {
                    setState(() {
                      _condicional = false;
                      _textKilometrosController.text = "";
                      correctivo = false;
                      _observaciones = "";
                      _condicionalTipoOperacion = false;
                      imageFile = null;
                    });
                  }
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
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

  void _openGalery(BuildContext context) async {
    widget._function(true);
    try {
      final picture = await ImagePicker().getImage(
        source: ImageSource.gallery,
      );
      setState(() {
        _imageFile = picture;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
    widget._function(false);
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    widget._function(true);
    try {
      final picture = await ImagePicker()
          .getImage(source: ImageSource.camera, imageQuality: 40);
      setState(() {
        _imageFile = picture;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      _showChoiceDialog(context);
    }
    widget._function(false);
    Navigator.of(context).pop();
  }

  Widget _decideImageView() {
    return _imageFile != null
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(File(_imageFile!.path)),
                    fit: BoxFit.fitWidth),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              child: Text("No hay Imagenes Seleccionadas"),
            ),
          );
  }

  Widget _getDropdownOperadores() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                child: DropdownButton<Operador>(
                  isExpanded: true,
                  value: _opcionSeleccionadaOperador,
                  hint: Text("Selecciona ..."),
                  onChanged: (Operador? newValue) {
                    String? responsable =
                        newValue!.operador!.isNotEmpty ? newValue.nombre : "";
                    setState(() {
                      _opcionSeleccionadaOperador = newValue;
                      _responsable = responsable;
                    });
                  },
                  items: listaOperadores.map((Operador operador) {
                    String descripcion = (operador.operador!.isNotEmpty)
                        ? operador.nombre!
                        : "Sin descripcion";
                    return new DropdownMenuItem<Operador>(
                      value: operador,
                      child: Text(
                        operador.operador! + " - " + descripcion,
                        style: TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDropdownActivosFijos() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Center(
                child: DropdownButton<ActivosFijos>(
                  isExpanded: true,
                  value: _opcionSeleccionadaActivo,
                  hint: Text("Selecciona ..."),
                  onChanged: (ActivosFijos? newValue) {
                    String? responsable =
                        newValue!.responsableNombre!.isNotEmpty
                            ? newValue.responsableNombre
                            : "";
                    setState(() {
                      _opcionSeleccionadaActivo = newValue;
                      _responsable = responsable;
                      _condicional = true;
                    });
                    _getOperadores();
                    _getServicioTipo(decidir);
                  },
                  items: listaActivosFijos.map((ActivosFijos activofijo) {
                    String descripcion = (activofijo.descripcion1!.isNotEmpty)
                        ? activofijo.descripcion1!
                        : "Sin descripcion";
                    return new DropdownMenuItem<ActivosFijos>(
                      value: activofijo,
                      child: Text(
                        activofijo.serie! + " - " + descripcion,
                        style: TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDropdownTipoOperacion() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "NOMENCLATURA",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.darkerText,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: DropdownButton<TipoOperacion>(
                  isExpanded: true,
                  value: _opcionSeleccionadaTipoOperacion,
                  hint: Text("Selecciona ..."),
                  onChanged: (TipoOperacion? newValue) {
                    String responsable = newValue!.tipoOperacion!.isNotEmpty
                        ? newValue.tipoOperacion.toString()
                        : "";
                    setState(() {
                      _opcionSeleccionadaTipoOperacion = newValue;
                      _condicionalTipoOperacion = true;
                    });
                  },
                  items: listaTipoOperacion.map((TipoOperacion operacion) {
                    String? descripcion = (operacion.tipoOperacion!.isNotEmpty)
                        ? operacion.tipoOperacion
                        : "Sin descripcion";
                    return new DropdownMenuItem<TipoOperacion>(
                      value: operacion,
                      child: Text(
                        operacion.tipoOperacion!,
                        style: TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getDropdownServicioTipo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "TIPO ",
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            letterSpacing: 0.27,
            color: DesignCourseAppTheme.darkerText,
          ),
        ),
        DropdownButton<ServicioTipo>(
          value: _opcionSeleccionadaServicioTipo,
          hint: Text("Selecciona ..."),
          onChanged: (ServicioTipo? newValue) {
            setState(() {
              _opcionSeleccionadaServicioTipo = newValue;
              _condicionalServicioTipo = false;
            });
          },
          items: listaServicioTipo.map((ServicioTipo servicioTipo) {
                return new DropdownMenuItem<ServicioTipo>(
                  value: servicioTipo,
                  child: new Text(
                    servicioTipo.descripcion!,
                    style: new TextStyle(color: Colors.black),
                  ),
                );
              }).toList() ??
              [],
        )
      ],
    );
  }

  Widget _crearObrevaciones() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 5.0, right: 20.0, left: 20.0, bottom: 0.0),
      child: correctivo
          ? TextField(
              autofocus: _condicionalTipoOperacion ? true : false,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.green,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                hintText: 'Falla presentada',
                labelText: 'Falla presentada',
                focusColor: Colors.green,
                hoverColor: Colors.green,
                fillColor: Colors.green,
              ),
              onChanged: (valor) => setState(() {
                    _observaciones = valor;
                  }))
          : Center(),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = 'Baja';
    if (CategoryType.ui == categoryTypeData) {
      txt = 'Baja';
    } else if (CategoryType.coding == categoryTypeData) {
      txt = 'Media';
    } else if (CategoryType.basic == categoryTypeData) {
      txt = 'Alta';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? Colors.green : DesignCourseAppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: Colors.black)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
                _condicionalBotones = true;
              });
              _cacharPrioridad();
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.27,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _cacharPrioridad() {
    print(categoryType.toString());

    switch (categoryType.toString()) {
      case 'CategoryType.ui':
        _tipoPrioridad = 'BAJA';

        break;
      case 'CategoryType.coding':
        _tipoPrioridad = 'MEDIA';

        break;
      case 'CategoryType.basic':
        _tipoPrioridad = 'ALTA';

        break;
      default:
    }
    print("PRIORIDAD BUENA : " + _tipoPrioridad.toString());
  }
}

enum CategoryType {
  ui,
  coding,
  basic,
}
