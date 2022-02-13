import 'dart:async';
import 'dart:convert';

import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/models/llanta_detalle_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_ruta.dart';
import 'package:best_flutter_ui_templates/src/pages/home_page.dart';
import 'package:best_flutter_ui_templates/src/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:best_flutter_ui_templates/src/utils/DAWidgets.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class ActualizarLlanta extends StatefulWidget {
  final String id;
  final String descripcion1;
  final String serie;
  final String posicion;
  final String ultimoCambio;
  final String kmInicial;

  final String marca;
  final String tipo;
  final String medida;
  final String llanta;
  final String ultimaMedicion;
  final String profundida;

  ActualizarLlanta(
      this.id,
      this.descripcion1,
      this.serie,
      this.posicion,
      this.ultimoCambio,
      this.kmInicial,
      this.marca,
      this.tipo,
      this.medida,
      this.llanta,
      this.ultimaMedicion,
      this.profundida);

  @override
  _ActualizarLlantaState createState() => _ActualizarLlantaState(
      this.id,
      this.descripcion1,
      this.serie,
      this.posicion,
      this.ultimoCambio,
      this.kmInicial,
      this.marca,
      this.tipo,
      this.medida,
      this.llanta,
      this.ultimaMedicion,
      this.profundida);
}

class _ActualizarLlantaState extends State<ActualizarLlanta> {
  final String id;
  final String descripcion1;
  final String serie;
  final String posicion;
  final String ultimoCambio;
  final String kmInicial;
  final String marca;
  final String tipo;
  final String medida;
  final String llanta;
  final String ultimaMedicion;
  final String profundida;

  _ActualizarLlantaState(
      this.id,
      this.descripcion1,
      this.serie,
      this.posicion,
      this.ultimoCambio,
      this.kmInicial,
      this.marca,
      this.tipo,
      this.medida,
      this.llanta,
      this.ultimaMedicion,
      this.profundida);
  String imagenAppBar = "assets/background2.jpg";
  File? imageFile;
  LlantaDetalle detalle = new LlantaDetalle();
  String? _fecha;
  String? _descripcion;
  int? _kilometraje;
  int? _profundidad;
  PickedFile? _imageFile;
  dynamic _pickImageError;
  String? _ruta;
  String? _nameImage = '';
  bool _saving = false; // Para estatus loading
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _inputFechaController = new TextEditingController();

  TextEditingController _kilometrajeFinal = new TextEditingController();

  TextEditingController _motivo = new TextEditingController();

  TextEditingController _inputFechaDelCambioController =
      new TextEditingController();
  final httpProv = new HttpProvider();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: DaScaffoldLoading(
        isLoading: _saving,
        keyLoading: _scaffoldKey,
        children: <Widget>[
          Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: NavBarCustom("Desasignar Neumático"),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _cardCambiarNeumatico(),
                      _getRenglonTitulo("Adjuntar Foto"),
                      _getRenglonEvidencias(),
                      _botonDesasignar(),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //_getDetalle();
  }

  _getDetalle() async {
    final httpProv = new HttpProvider();
    var res = await (httpProv.spWebLlantaInfo(id, posicion));
    if (res![0] != null) {
      setState(() {
        detalle = res[0];
      });
      print("SOY EL DETALLE DE LA LLANTA: " + detalle.toString());
    } else {
      print("Error en la Consulta");
    }

    print(detalle.tipo);
  }

  Widget _cardCambiarNeumatico() {
    final widgetTemp = SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 20.0, 5.0),
            padding: const EdgeInsets.only(top: 10.0),
            height: _imageFile != null ? 650.0 : 470.0,
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
                _getRenglonTitulo("CAPTURAR DATOS"),
                _getRenglonUnoTitulos("ECO", "Posición"),
                _getRenglon(serie.toString(), posicion.toString()),
                //_getRenglonTitulo("Motivo"),
                _getRenglonUnoTitulos("Km Inicial", "KM Final"),
                _getRenglonKmInicial(kmInicial.toString(), "KM Final"),
                //_getRenglonKmFinal("Km Final", "Medición Final"),
                _getRenglonTitulo("Motivo"),
                _getRenglonMotivo("Descripción del Motivo"),
                //_getRenglonTitulo("Observaciones"),
                //_getRenglonDescripcion("Descripción del Problema"),
                _getRenglonTitulo("Anexos"),
                Center(
                  child: _decideImageView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return widgetTemp;
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
            padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 3.0),
            child: Container(
              child: Text("No hay Imagenes Seleccionadas"),
            ),
          );
  }

  Widget _cardCambiarNeumaticoAutorizaciones() {
    final widgetTemp = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          height: 100.0,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.0),
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                  topRight: Radius.circular(0.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 5.0,
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getRenglonAutorizacionesTitle("Autorizaciones"),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ],
    );

    return widgetTemp;
  }

  Widget _getRenglonUnoTitulos(value1, value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Center(
              child: Text(value1,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
            )),
        Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Center(
              child: Text(value2,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
            )),
      ],
    );
  }

  Widget _getRenglon(value1, value2) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        //autofocus: true,
                        enabled: false,
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
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        //autofocus: true,
                        enabled: false,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: value2,
                          labelText: value2,
                          focusColor: Colors.green,
                          hoverColor: Colors.green,
                          fillColor: Colors.green,
                        ),
                      )),
                ),
              ]),
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  Widget _getRenglonUno(value1, value2) {
    //var now = DateTime.now().toUtc();
    //var dt = DateTime(now.day, now.month, now.year);
    var dia = DateTime.now().day;
    var mes = DateTime.now().month;
    var ano = DateTime.now().year;

    String _formattetime =
        dia.toString() + "/" + mes.toString() + "/" + ano.toString();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  child: TextField(
                enabled: false,
                textAlign: TextAlign.right,
                //autofocus: true,
                onChanged: (valor) => setState(() {}),
                keyboardType: TextInputType.number,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "",
                  labelText: value1 == "" ? "" : value1,
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(color: Colors.green),
                  focusColor: Colors.green,
                  hoverColor: Colors.green,
                  fillColor: Colors.green,
                ),
              )),
              Flexible(
                  child: TextField(
                enabled: false,
                textAlign: TextAlign.right,
                //autofocus: true,
                onChanged: (valor) => setState(() {}),
                keyboardType: TextInputType.number,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "",
                  labelText: value2 == "" ? "" : value2,
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(color: Colors.green),
                  focusColor: Colors.green,
                  hoverColor: Colors.green,
                  fillColor: Colors.green,
                ),
              )),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _getRenglonTitulo(value1) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Center(
                  child: Text(
                    value1,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
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
                    controller: _motivo,

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

  Widget _getRenglonKmInicial(value1, value2) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        //autofocus: true,
                        enabled: false,
                        onChanged: (valor) => setState(() {
                          _kilometraje = valor as int;
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
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny('\.'),
                        LengthLimitingTextInputFormatter(8)
                      ],
                      keyboardType: TextInputType.number,
                      controller: _kilometrajeFinal,
                      decoration: const InputDecoration(
                        hintText: 'Km Final',
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
                ),
              ]),
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  Widget _getRenglonKmFinal(value1, value2) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        //autofocus: true,
                        onChanged: (valor) => setState(() {
                          _kilometraje = valor as int;
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
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        //autofocus: true,
                        onChanged: (valor) => setState(() {
                          _profundidad = valor as int;
                        }),
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: value2,
                          labelText: value2,
                          focusColor: Colors.green,
                          hoverColor: Colors.green,
                          fillColor: Colors.green,
                        ),
                      )),
                ),
              ]),
            ],
          ),
        ),
        Divider()
      ],
    );
  }

  Widget _getRenglonEvidencias() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.50,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
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
                    setState(() {
                      _saving = true;
                    });
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

  void _openGalery(BuildContext context) async {
    setState(() {
      _saving = true;
    });
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
    setState(() {
      _saving = false;
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    setState(() {
      _saving = true;
    });
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
    }
    setState(() {
      _saving = false;
    });
    Navigator.of(context).pop();
  }
  /*

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
  

  Widget _getRenglonCalendario(String value1) {
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
                  child: TextField(
                      controller: _inputFechaDelCambioController,
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: 'Fecha',
                          labelText: 'Fecha',
                          //suffixIcon: Icon(Icons.)
                          icon: Icon(Icons.calendar_today)),
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _selectDate(context);
                      }),
                ),
              ]),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
  */

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

  Widget _getRenglonAutorizacionesTitle(String value1) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Center(
                child: Text(
                  value1,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ),
      ],
    );
  }

  Widget _botonDesasignar() {
    String titulo = "Desasignar";
    Widget boton = Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 40),
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
              onTap: () => {
                if (_motivo.text != null && _kilometrajeFinal.text != null)
                  {_requestDesasignaLLanta()}
                else
                  {_alertTextError(context)}
              },
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
    return boton;
  }

  _requestDesasignaLLanta() async {
    print("Unidad: " + id.toString());
    print("Asignacion: " + posicion.toString());
    print("Causa: " + _motivo.text.toString());
    print("Comentario: " + "");
    print("Kilometros: " + _kilometrajeFinal.text.toString());
    print("Profundidad: " + "");
    print("Serie: " + serie.toString());
    print("Llanta: " + llanta.toString());

    int entID = int.parse(id.toString());
    int entPosicion = int.parse(posicion.toString());
    int entKilometraje = int.parse(_kilometrajeFinal.text.toString());

    final httpProv = new HttpProvider();
    final List<Response>? lista = await (httpProv.spWebDesasignaLlanta(
      entID,
      entPosicion,
      _motivo.text.toString(),
      "",
      entKilometraje,
      1,
    ));

    if (lista![0].ok == "null" || lista[0].ok == null) {
      print("ok: " + lista[0].ok.toString());
      print("okRef: " + lista[0].okRef.toString());
      print("moduloID:" + lista[0].moduloId.toString());
      _alertTextDesasigna(context);
      //_openSnackBarWithoutAction(context, "LLanta Desasignada Correctamente !");
    } else {
      print("Error...");
    }
  }

  Future<void> _alertTextError(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Center(child: Text("Ningun campo puede ser vacio")),
            actions: <Widget>[
              new TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    //Navigator.of(context, rootNavigator: true).pop('dialog');
                    //setState(() => _saving = false);
                  },
                  child: new Text("Cancelar")),
            ],
          );
        });
  }

  Future<void> _alertTextDesasigna(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Center(child: Text("LLanta Desasignada Correctamente !")),
            actions: <Widget>[
              new TextButton(
                  onPressed: () {
                    _imageFile == null ? _opcionSinAnexo() : _opcionConAnexo();
                    //setState(() => _saving = false);
                  },
                  child: new Text("Aceptar")),
            ],
          );
        });
  }

  _opcionSinAnexo() {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    _seguirAtras();
  }

  _opcionConAnexo() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd_MM_yyyy');
    var formatterHora = new DateFormat('HH_mm');
    String today = formatter.format(now);
    String hora = formatterHora.format(now);

    Navigator.of(context, rootNavigator: true).pop('dialog');
    setState(() {
      _nameImage = 'Anexo_Llanta';
    });

    _getPahForImage();
  }

  _getPahForImage() async {
    _saving = true;
    print("Llanta : " + llanta.toString());
    final List<ResponseRuta>? res =
        await (httpProv.spWebRutaLlantasAnexos(llanta.toString()));

    if (res![0].okRef == null && res[0].ruta != null) {
      _saving = false;
      setState(() {
        _ruta = res[0].ruta;
      });
      print("Rutaa: " + _ruta.toString());
      sendImage(context);
    }
  }

  Future<void> sendImage(context) async {
    _saving = true;

    /*
    print("RUTA : " + _ruta);
    print('Original path: ${_imageFile.path}');
    String dir = path.dirname(_imageFile.path);
    String newPath = path.join(dir, _nameImage + '.jpg');
    print('New path: $newPath');
    File(_imageFile.path).renameSync(newPath);
    print('ARchivo: ${_imageFile.path}');
    */

    print("ID: " + id.toString());

    print("SERIE: " + serie.toString());

    print("LLanta: " + llanta.toString());

    int idMov = int.parse(id.toString());

    List<int>? bytes = null;
    String ext = "";
    String mimeType = "";

    bytes = File(_imageFile!.path).readAsBytesSync();
    int size = File(_imageFile!.path).lengthSync();
    print("size:" + size.toString());
    ext = '.jpg';
    mimeType = "image/jpeg";

    String img64 = base64Encode(bytes);

    /*
    var res = await httpProv.upload(File(newPath), _ruta);

    print(res);
    if (res) {
      _saving = false;
      saveRutaERP(context);
    } else {
      _saving = false;
    }*/

    var res = await (httpProv.anexosCuenta(id.toString(), _ruta! + "/", false,
        _nameImage! + ext, ext, mimeType, size, img64));

    if (res!.ok == null || res.ok == "null") {
      saveRutaERP(context);
      _saving = false;
    } else {
      _saving = false;
    }
  }

  saveRutaERP(context) async {
    _saving = true;
    print("AQUI YA ENTRO ");
    print("RUTA MANDADA ERP : " + _ruta! + "/" + _nameImage! + '.jpg');
    var res = await (httpProv.spWebAnexoCtaLlanta(
        id.toString(),
        llanta.toString(),
        posicion.toString(),
        _nameImage!,
        _ruta! + "/" + _nameImage! + '.jpg',
        'Imagen'));
    if (res![0].ok == null || res[0].ok == "null") {
      _saving = false;
      setState(() {
        _ruta = null;
        _nameImage = null;
        _imageFile = null;
      });
      _showMessgeDialogoPreventivo(context, res[0].okRef.toString());
    } else {
      print("saveRutaERP  ELSE: " + res[0].ok);
      _saving = false;
    }
  }

  Future<void> _showMessgeDialogoPreventivo(context, messageResponseImage) {
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

  _seguirAtras() {
    //Navigator.of(context).pop();
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  _openSnackBarWithoutAction(BuildContext context, String title) {
    final snackBar = SnackBar(
      content: Text(title),
      duration: Duration(seconds: 5),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
