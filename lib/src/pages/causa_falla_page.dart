import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/hotel_booking/hotel_app_theme.dart';
import 'package:best_flutter_ui_templates/src/models/causa_model.dart';
import 'package:best_flutter_ui_templates/src/models/descripcion_model.dart';
import 'package:best_flutter_ui_templates/src/models/origen_model.dart';
import 'package:best_flutter_ui_templates/src/models/proveedor_model.dart';
import 'package:best_flutter_ui_templates/src/models/refacciones_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_ruta.dart';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_model.dart';
import 'package:best_flutter_ui_templates/src/models/tipo_cambio.dart';
import 'package:best_flutter_ui_templates/src/pages/PDFScreen.dart';
import 'package:best_flutter_ui_templates/src/utils/DAWidgets.dart';
import 'package:best_flutter_ui_templates/src/utils/utils.dart';
import 'package:best_flutter_ui_templates/src/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class CausaFalla extends StatefulWidget {
  final SolicitudPendiente solicitud;
  CausaFalla(this.solicitud);

  @override
  _CausaFallaState createState() => _CausaFallaState(solicitud);
}

class _CausaFallaState extends State<CausaFalla> {
  SolicitudPendiente solicitudPendiente;
  _CausaFallaState(this.solicitudPendiente);
  bool dolar = false;
  bool closeTopController = false;
  final httpProv = new HttpProvider();
  Origen? _opcionSeleccionadaOrigen = new Origen();
  Causa? _opcionSeleccionadaCausaOrigen = new Causa();
  TextEditingController _inputDescripcionCausaController =
      new TextEditingController();
  TextEditingController _inputFolioController = new TextEditingController();
  TextEditingController _inputRefaccionesController =
      new TextEditingController();
  TextEditingController _inputProveedorController = new TextEditingController();

  TextEditingController _inputImporteController = new TextEditingController();
  TextEditingController _inputTipoCambioController =
      new TextEditingController();
  final formatCurrency = new NumberFormat.simpleCurrency();
  TextEditingController _fechaPromesaController = new TextEditingController();
  Proveedor? _opcionSeleccionadaProveedor = new Proveedor();

  late Descripcion descripcion;
  String? descripcionArt;
  String? folio;
  String? importe;
  double suma = 0.00;
  double total = 0.00;
  String? _fechaPromesa;
  bool _evaluandoMoneda = false;
  bool _bloquearSwitch = false;
  String _responsable = "";
  String? _proveedorSelected = "";
  String _folioSelected = "";
  String? _provedorSeleccionado;
  String _actualizandoProveedorClave = "";
  String _actualizandoProveedorNombre = "";

  List<Origen> listaOrigen = [];
  List<Causa> listaCausaOrigen = [];
  List<Refacciones> listaRefacciones = [];
  List<Proveedor> listaProveedores = [];
  List<Proveedor> listaProveedoresBuscado = [];
  bool _isDolar = false;
  String _tipoDeCambio = '';
  String? _valorTipoCambio = '';
  bool _monedaTipo = false;
  bool _condicionalPDF = false;
  String _fechaRequerida = '';
  File? imageFile;
  String imagenPesos = "assets/peso.png";
  String imagenDolar = "assets/dollar.png";
  bool _condicionalProveedores = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false; // Para estatus loading
  File? _filePDF;
  String? _filePDFname = null;
  String? _ruta = null;
  DateTime now = DateTime.now();
  PickedFile? _imageFile;
  dynamic _pickImageError;
  String? _nameImage = '';

  @override
  void initState() {
    super.initState();
    _getCausaOrigen();
    _getTipoCambio();
    //_getProveedores();
    descripcion = new Descripcion();
  }

  @override
  Widget build(BuildContext context) {
    return DaScaffoldLoading(
      isLoading: _saving,
      keyLoading: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      children: <Widget>[
        Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          resizeToAvoidBottomInset: true,
          appBar: NavBarCustom("Calcular Presupuesto"),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                _cardUnoFlexible(),
                //_cardFechaPromesa(),
                _cardTresFlexible(),
                //_servicioCardDetalle(),
                //   Container(
                Container(
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
                  child:
                      Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                    ListView(
                        shrinkWrap: true,
                        children: _listaRefacciones(
                            listaRefacciones, context, _evaluandoMoneda)),
                  ]),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                          child: Column(
                            children: [
                              FloatingActionButton(
                                heroTag: "btn1",
                                onPressed: () {
                                  _showChoiceFolio(context);
                                },
                                child: Icon(Icons.picture_as_pdf),
                                backgroundColor: Colors.green,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10.0, 5.0, 20.0, 5.0),
                          child: Column(
                            children: [
                              FloatingActionButton(
                                heroTag: "btnIMG",
                                onPressed: () {
                                  _showChoiceFolioImg(context);
                                },
                                child: Icon(Icons.camera_alt_outlined),
                                backgroundColor: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Adjuntar PDF'S",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Adjuntar Imagen",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Center(
                  child: _imageFile != null
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(_imageFile!.path)),
                                  fit: BoxFit.fitWidth),
                            ),
                          ))
                      : Container(),
                ),
                Center(
                  child: _imageFile != null
                      ? FloatingActionButton(
                          heroTag: "btn_listo",
                          onPressed: () {
                            _getPahForImg();
                          },
                          child: Icon(Icons.check_box_rounded),
                          backgroundColor: Colors.green,
                        )
                      : Container(),
                ),

                Divider(),
                _filePDFname != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PDFScreen(path: _filePDF),
                                ),
                              );
                            },
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 7.0, right: 7.0, bottom: 10.0),
                                child: Icon(
                                  Icons.file_copy_outlined,
                                  size: 30.0,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Container(
                            child: Text(
                              _filePDFname!,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Container(
                            child: FloatingActionButton(
                              heroTag: "btn2",
                              onPressed: () {
                                _getPahForPDF();
                              },
                              mini: true,
                              child: Icon(
                                Icons.send,
                                size: 20.0,
                              ),
                            ),
                          )
                        ],
                      )
                    : SizedBox(height: 1.0)
              ],
            ),
          ),
          /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _postGenerarOrden();
        },
        child: Icon(Icons.send),
        backgroundColor: Colors.green,
      ),*/
        )
      ],
    );
  }

  _getPahForPDF() async {
    setState(() {
      _saving = true;
    });
    print("MODULO ID : " + solicitudPendiente.id.toString());
    final List<ResponseRuta> res = await (httpProv.spWebRutaAlmacenarAnexos(
        solicitudPendiente.id.toString()) as FutureOr<List<ResponseRuta>>);

    if (res.isNotEmpty) {
      if (res[0].okRef == null && res[0].ruta != null) {
        setState(() {
          _ruta = res[0].ruta;
          _saving = false;
        });
        _sendPDF(context);
      } else {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  _getPahForImg() async {
    setState(() {
      _saving = true;
    });
    print("MODULO ID : " + solicitudPendiente.id.toString());
    final List<ResponseRuta> res = await (httpProv.spWebRutaAlmacenarAnexos(
        solicitudPendiente.id.toString()) as FutureOr<List<ResponseRuta>>);

    if (res.isNotEmpty) {
      if (res[0].okRef == null && res[0].ruta != null) {
        setState(() {
          _ruta = res[0].ruta;
        });

        _sendIMG(context);
      } else {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _sendIMG(context) async {
    setState(() {
      _saving = true;
    });

    List<int>? bytes = null;
    String ext = "";
    String mimeType = "";

    bytes = File(_imageFile!.path).readAsBytesSync();
    ext = '.jpg';
    mimeType = "image/jpeg";

    String img64 = base64Encode(bytes);

    String fileType = "data:image/jpeg;base64," + img64;
    int idMov = int.parse(solicitudPendiente.movId.toString());

    var res = await httpProv.anexos(idMov, _ruta, solicitudPendiente.mov,
        _nameImage! + ext, ext, mimeType, fileType);

    if (res != null) {
      setState(() {
        _saving = false;
      });
      saveRutaERPimg(context);
    } else {
      setState(() {
        _saving = false;
      });
    }
  }

  saveRutaERPimg(context) async {
    setState(() {
      _saving = true;
    });

    int idMov = int.parse(solicitudPendiente.movId.toString());
    var res = await (httpProv.spWebAnexoMovServicio(
        solicitudPendiente.id.toString(),
        solicitudPendiente.movId.toString() + "_" + _nameImage! + ".jpg",
        _ruta! +
            "/" +
            solicitudPendiente.movId.toString() +
            "_" +
            _nameImage! +
            '.jpg',
        'Imagen') as FutureOr<List<Response>>);
    if (res.isNotEmpty) {
      if (res[0].ok == null || res[0].ok == "null") {
        setState(() {
          _ruta = null;
          _nameImage = null;
          _imageFile = null;
          _saving = false;
        });

        print("BIEN TRES ");
        _showMessgeDialogPDF(context, res[0].okRef.toString());
      } else {
        setState(() {
          _saving = false;
        });
        print("saveRutaERP  ELSE: " + res[0].ok);
      }
    }
  }

  Future<void> _sendPDF(context) async {
    setState(() {
      _saving = true;
    });
    List<int>? bytes = null;
    String ext = "";
    String mimeType = "";

    bytes = File(_filePDF!.path).readAsBytesSync();
    ext = '.pdf';
    mimeType = "application/pdf";

    String pdf64 = base64Encode(bytes);

    String fileType = "data:application/pdf;base64," + pdf64;
    int idMov = int.parse(solicitudPendiente.movId.toString());

    //var res = await httpProv.anexos(File(newPath), _ruta);
    var res = await httpProv.anexos(idMov, _ruta, solicitudPendiente.mov,
        _filePDFname! + ext, ext, mimeType, fileType);

    print(res);
    if (res != null) {
      setState(() {
        _saving = false;
      });
      saveRutaERPpdf(context);
    } else {
      setState(() {
        _saving = false;
      });
      DAToast(_scaffoldKey, "Error al subir el Anexo");
    }
  }

  saveRutaERPpdf(context) async {
    setState(() {
      _saving = true;
    });

    int idMov = int.parse(solicitudPendiente.movId.toString());
    var res = await (httpProv.spWebAnexoMovServicio(
        solicitudPendiente.id.toString(),
        solicitudPendiente.movId.toString() + "_" + _filePDFname! + ".pdf",
        _ruta! +
            "/" +
            solicitudPendiente.movId.toString() +
            "_" +
            _filePDFname! +
            '.pdf',
        'Pdf') as FutureOr<List<Response>>);
    if (res.isNotEmpty) {
      if (res[0].ok == null || res[0].ok == "null") {
        setState(() {
          _ruta = null;
          _filePDFname = null;
          _filePDF = null;
          _saving = false;
        });
        print("BIEN TRES ");
        _showMessgeDialogPDF(context, res[0].okRef.toString());
      } else {
        setState(() {
          _saving = false;
        });
        print("saveRutaERP  ELSE: " + res[0].ok);
      }
    }
  }

  spWebVentaPresupuestoFolio() async {
    setState(() {
      _saving = true;
    });
    print("id : " + solicitudPendiente.id.toString());
    print("FOLIO : " + _inputFolioController.text.toString());

    final List<Response> listaRef = await (httpProv.spWebVentaFolio(
        solicitudPendiente.id.toString(),
        _inputFolioController.text.toString()) as FutureOr<List<Response>>);

    if (listaRef.length <= 0) {
    } else {
      if (listaRef[0].ok == null ||
          listaRef[0].ok == "null" && listaRef[0].okRef == null ||
          listaRef[0].okRef == "null") {
        print("RESPUESTA REQUEST FOLIO: " + listaRef[0].okRef.toString());
        _showMessgeDialogFolioResponse(context, "Folio guardado Correctamente");
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _showMessgeDialogFolioResponse(context, messageResponseFolio) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: new Text("Folio"),
          content: new Text('$messageResponseFolio'),
          actions: <Widget>[
            new TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("Ok"))
          ],
        );
      },
    );
  }

  Future<void> _showMessgeDialogPDF(context, messageResponsePDF) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: new Text("Adjuntar Anexo"),
          content: new Text('$messageResponsePDF'),
          actions: <Widget>[
            new TextButton(
                onPressed: () {
                  spWebVentaPresupuestoFolio();
                  Navigator.of(context).pop();
                },
                child: new Text("Ok"))
          ],
        );
      },
    );
  }

  _getTipoCambio() async {
    final httpProv = new HttpProvider();
    var res = await (httpProv.spWebMonTipoCambio());

    if (res!.isNotEmpty) {
      print("TIPO  DE CAMBIO :" + res[0].tipoCambio.toString());
      String cambio = res[0].tipoCambio.toString();
      setState(() {
        _inputTipoCambioController.text = cambio.substring(0, 5);
      });
    } else {
      print(res);
    }
  }

  _setListRefacciones(bool monedaTipo) async {
    final List<Refacciones> listaRef =
        await (httpProv.spWebSolicitudArtLista(solicitudPendiente.id.toString())
            as FutureOr<List<Refacciones>>);

    if (listaRef.length <= 0) {
      setState(() {
        listaRefacciones = [];
        _condicionalPDF = false;
        _bloquearSwitch = false;
      });
    } else {
      if (listaRef[0].articulo != null) {
        setState(() {
          _evaluandoMoneda = monedaTipo;
          listaRefacciones = listaRef;
          _condicionalPDF = true;
        });
      } else {
        setState(() {
          listaRefacciones = [];
        });
      }
    }
  }

  _setNewRefacciones(bool monedaTipo) async {
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
          _setListRefacciones(monedaTipo);
          setState(() {
            _inputImporteController.text = "";
            _inputRefaccionesController.text = "";
          });
        } else {}
      }
    }
  }

  _setVentaPresupuesto(bool monedaTipo) async {
    if (_inputRefaccionesController.text.isNotEmpty &&
        _inputImporteController.text.isNotEmpty) {
      setState(() {
        _saving = true;
      });
      _fechaRequerida = DateFormat('dd-MM-yyyy').format(now);
      print("id : " + solicitudPendiente.id.toString());
      print("descripcion :" + _inputDescripcionCausaController.text);
      print(
          "origen causa :" + _opcionSeleccionadaCausaOrigen!.causa.toString());
      print("sistema Origen : " + _opcionSeleccionadaOrigen!.origen.toString());
      print("moneda tipo : " + _monedaTipo.toString());
      print("tipo de cambio : " + _inputTipoCambioController.text);
      //print("fecha promesa : " + _fechaPromesaController.text);
      print("fecha promesa : " + _fechaRequerida.toString());
      print("proveedor : " + _actualizandoProveedorClave.toString());
      print("refacciones/articulo : " + _inputRefaccionesController.text);
      print("importe : " + _inputImporteController.text);

      final List<Response>? listaRef = await (httpProv.spWebVentaPresupuesto(
          solicitudPendiente.id.toString(),
          _inputDescripcionCausaController.text,
          _opcionSeleccionadaCausaOrigen!.causa.toString(),
          _opcionSeleccionadaOrigen!.origen.toString(),
          _monedaTipo,
          _inputTipoCambioController.text,
          //_fechaPromesaController.text,
          //"1/02/2021",
          _fechaRequerida.toString(),
          _actualizandoProveedorClave.toString(),
          _inputRefaccionesController.text,
          _inputImporteController.text,
          true,
          ""));

      print("VALOR : " + _inputImporteController.text.toString());
      suma = suma + double.parse(_inputImporteController.text.toString());
      print("SUMA : " + suma.toString());
      total = suma;
      print("TOTAL : " + total.toString());
      if (total > 0) {
        _bloquearSwitch = true;
      }

      if (listaRef!.length <= 0) {
      } else {
        if (listaRef[0].ok == null || listaRef[0].ok == "null") {
          _setListRefacciones(monedaTipo);
          setState(() {
            _inputImporteController.text = "";
            _inputRefaccionesController.text = "";
            _saving = false;
          });
        } else {}
      }
    }
  }

  _postGenerarOrden() async {
    final httpProv = new HttpProvider();

    print(
      solicitudPendiente.id.toString(),
    );
    print(_inputDescripcionCausaController.text.toString());
    print(_opcionSeleccionadaCausaOrigen!.causa.toString());
    print(_opcionSeleccionadaOrigen!.origen.toString());
    print(_inputRefaccionesController.text.toString());
    print(
      "ES DOLAR  : " + _monedaTipo.toString(),
    );
    print(_tipoDeCambio == null
        ? "VALOR TIPO DE CAMBIO : " + _tipoDeCambio.toString()
        : "VALOR TIPO DE CAMBIO : " + _tipoDeCambio.toString());
    print(_fechaPromesaController.text == null
        ? ''
        : "FECHA PROMESA : " + _fechaPromesaController.text);
    print(
      _inputFolioController.text == null
          ? ''
          : "FOLIO : " + _inputFolioController.text,
    );

    var res = await (httpProv.spWebVentaDescripcion(
        solicitudPendiente.id.toString(),
        _inputDescripcionCausaController.text,
        _opcionSeleccionadaCausaOrigen!.causa.toString(),
        _opcionSeleccionadaOrigen!.origen.toString(),
        _inputRefaccionesController.text,
        _monedaTipo,
        _tipoDeCambio.toString() == null ? '' : _tipoDeCambio.toString(),
        _inputFolioController.text,
        _fechaPromesaController.text) as FutureOr<List<Response>>);
    if (res[0].ok != null) {
      if (res.isNotEmpty) {
        _showMessgeDialog(context,
            res[0].okRef.toString() + "\n" + " OK: " + res[0].ok.toString());
      } else {
        //  _openSnackBarWithoutAction(context ,lista[0].okRef) ;
      }
    } else {
      _showMessgeDialog(
          context,
          "OK : " +
              res[0].okRef.toString() +
              "\n" +
              " OkRef: " +
              res[0].ok.toString());
    }
  }

  Widget _cardUnoFlexible() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
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
          padding:
              const EdgeInsets.only(left: 50, right: 50, top: 5, bottom: 5),
          child: Column(children: [
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: true,
                onExpansionChanged: (bool) {
                  _getBoolExpandir();
                },
                title: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Causa Origen",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                children: [
                  _getDropdownSistemaOrigen(),
                  SizedBox(height: 5.0),
                  Text(
                    "Sistema Origen",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5.0),
                  _getDropdownOrigen(),
                  SizedBox(height: 5.0),
                  Text(
                    "Descripción de la falla",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  TextFormField(
                    onSaved: (value) {
                      descripcion.descripcion = value;
                    },
                    controller: _inputDescripcionCausaController,
                    decoration: const InputDecoration(
                      hintText: 'Max. 280 caracteres',
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
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  _getBoolExpandir() {
    if (_inputDescripcionCausaController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Widget _cardDosFlexible() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
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
          padding:
              const EdgeInsets.only(left: 5.0, right: 25, top: 5, bottom: 5),
          child: Column(children: [
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: false,
                title: Padding(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 25, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      _getFechaPromesa(),
                    ],
                  ),
                ),
                children: [Text(".")],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _cardTresFlexible() {
    String imagenMore = "assets/more.png";
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 16),
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
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: Column(children: [
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Cotización",
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
                  _getSwitch(),
                  SizedBox(height: 20.0),
                  _monedaTipo == true
                      ? _getRenglon("Tipo Cambio USD ")
                      : SizedBox(height: 0.0),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width * 0.30,
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
                        width: MediaQuery.of(context).size.width * 0.26,
                        padding: EdgeInsets.all(5),
                        child: TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                        width: MediaQuery.of(context).size.width * 0.27,
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Container(
                              child: IconButton(
                                icon: const Icon(Icons.person_add),
                                color: Colors.green,
                                tooltip: _actualizandoProveedorNombre
                                            .toString() ==
                                        ""
                                    ? 'Selecciona Proveedor'
                                    : _actualizandoProveedorNombre.toString(),
                                onPressed: () {
                                  _showChoiceDialogo(context);
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  _setVentaPresupuesto(_monedaTipo);
                                },
                                child: Image.asset(
                                  imagenMore,
                                  fit: BoxFit.fitHeight,
                                  height: 30.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.all(5.0),
                        child: Text(total.toString() == null
                            ? 'Total \u{24} 0.00'
                            : 'Total: ' + formatCurrency.format(total)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _cardFechaPromesa() {
    final widgetTemp = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
          height: 100.0,
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
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //_getFechaRequerida(),
                    //Divider(),
                    //SizedBox(height: 5.0),
                    _getFechaPromesa()
                    //_getDropdownProveedores(),
                  ])),
        ),
      ],
    );

    return widgetTemp;
  }

  Widget _getDropdownProveedores() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: DropdownButton<Proveedor>(
                isExpanded: true,
                value: _opcionSeleccionadaProveedor,
                hint: Text("Selecciona ..."),
                onChanged: (Proveedor? newValue) {
                  String? proveedor =
                      newValue!.proveedor!.isNotEmpty ? newValue.nombre : "";
                  setState(() {
                    _opcionSeleccionadaProveedor = newValue;
                  });
                },
                items: listaProveedores.map((Proveedor proveedor) {
                  String? descripcion = (proveedor.nombre!.isNotEmpty)
                      ? proveedor.nombre
                      : "Sin descripcion";
                  return new DropdownMenuItem<Proveedor>(
                    value: proveedor,
                    child: Text(
                      proveedor.proveedor! + " - " + proveedor.nombre!,
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
    );
  }

  Widget _getFechaRequerida() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10),
          width: MediaQuery.of(context).size.width * 0.25,
          child: TextFormField(
            controller: _inputFolioController,
            onSaved: (value) {
              folio = value;
            },
            decoration: const InputDecoration(
              hintText: 'Folio',
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
          width: MediaQuery.of(context).size.width * 0.53,
          padding: EdgeInsets.only(left: 20),
          child: Column(children: [
            TextField(
                controller: _fechaPromesaController,
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    hintText: _fechaPromesaController.text,
                    labelText: 'Fecha Requerida',
                    prefixIcon: Icon(Icons.calendar_today)),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDatePromesa(context);
                }),
          ]),
        ),
      ],
    );
  }

  Widget _getFechaPromesa() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.80,
          padding: EdgeInsets.only(left: 10),
          child: Column(children: [
            TextField(
                controller: _fechaPromesaController,
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    hintText: _fechaPromesaController.text,
                    labelText: 'Fecha Promesa',
                    prefixIcon: Icon(Icons.calendar_today)),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDatePromesa(context);
                }),
          ]),
        ),
      ],
    );
  }

  Widget _getSwitch() {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 25.0),
                      child: Text(
                        "Refacciones Cotizadas",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ))
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Dólares",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0),
                width: MediaQuery.of(context).size.width * 0.20,
                height: 15.0,
                child: FlutterSwitch(
                  activeColor: Colors.green,
                  value: _monedaTipo,
                  onToggle: (bool value) {
                    (_bloquearSwitch)
                        ? _showMessgeDialog(context,
                            "No es posible cambiar la moneda si tienes articulos agregados")
                        : _getTipoMoneda(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showMessgeDialog(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: new Text(text),
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
  }

  _regresarDos(proveedorClave, proveedorNombre) {
    if (Navigator.canPop(context)) {
      print("si : " + proveedorClave);
      Navigator.pop(context, proveedorClave);
      setState(() {
        _actualizandoProveedorClave = proveedorClave.toString();
        _actualizandoProveedorNombre = proveedorNombre.toString();
      });
    } else {
      print("no");
      SystemNavigator.pop();
    }
  }

  _getTipoMoneda(bool value) async {
    String categoria = 'PESOS';
    if (value) {
      categoria = 'DOLAR';
      setState(() {
        _monedaTipo = value;
      });
    } else {
      categoria = 'PESOS';
      setState(() {
        _monedaTipo = value;
      });
    }
  }

  Widget _getRenglon(String value1) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    value1,
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Text(
                      '\u{24}',
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w100,
                          color: Colors.green),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _inputTipoCambioController,
                    onSaved: (value) {
                      _valorTipoCambio = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Captura el valor ... ',
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
              ]),
            ],
          ),
        ),
      ],
    );
  }

  _getCausaOrigen() async {
    final List<Causa>? lista = await (httpProv.spWebServicioCausaLista());

    if (lista!.length <= 0) {
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
    final List<Origen>? lista = await (httpProv.spWebServicioOrigenLista());
    print("LISTA DE SISTEMA ORIGEN : " + lista.toString());
    if (lista!.length <= 0) {
      _opcionSeleccionadaOrigen = null;
      listaOrigen = [];
    } else {
      _opcionSeleccionadaOrigen = lista.first;
      listaOrigen = lista;
    }
    _setListRefacciones(_evaluandoMoneda);
  }

  _requestBuscarProveedor(BuildContext context) async {
    final List<Proveedor> lista = await (httpProv
            .postProveedores(_inputProveedorController.text.toString())
        as FutureOr<List<Proveedor>>);

    if (lista.length <= 0) {
      _opcionSeleccionadaProveedor = null;
      listaProveedoresBuscado = [];
    } else {
      _opcionSeleccionadaProveedor = lista[0];
      listaProveedoresBuscado = lista;
    }
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
      List<Refacciones> items, BuildContext context, bool _evaluandoMoneda) {
    final List<Widget> servicios = [];

    if (items.length <= 0) {
      return [];
    }
    items.forEach((item) {
      final widgetTemp = Stack(
        children: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 15.0, 15.0),
              child:
                  //(item.responsable == "") ? Center() :
                  Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                _getRow(item.articulo!, 0.30),
                _getRow(formatCurrency.format(item.precio), 0.30),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.green,
                  tooltip: 'Eliminar',
                  onPressed: () {
                    setState(() {
                      _deleteRenglon(item);
                    });
                  },
                ),
              ]),
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
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Future<void> _deleteRenglon(Refacciones item) async {
    suma = suma - double.parse(item.precio.toString());
    total = suma;

    final List<Response> listaRef = await (httpProv.spWebEliminarSolicitudArt(
        solicitudPendiente.id, item.renglon) as FutureOr<List<Response>>);

    if (listaRef.length <= 0) {
    } else {
      if (listaRef[0].ok == null) {
        _setListRefacciones(_evaluandoMoneda);
      } else {}
    }
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
                  child: Text("Selecciona un Proveedor"),
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
                                    controller: _inputProveedorController,
                                    onSaved: (value) {
                                      _proveedorSelected = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Buscar Proveedor',
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
                                        _requestBuscarProveedor(context);
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
                                                    child: Text("Proveedores"),
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
                                          child: _getListaProvedores(context),
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

  Future<void> _showChoiceFolio(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Center(
                  child: Text("Captura Folio"),
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
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: _inputFolioController,
                                    onSaved: (value) {
                                      folio = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Folio',
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
                              ],
                            ),
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
                  new TextButton(
                      onPressed: () {
                        _inputFolioController.value.text != ""
                            ? _showChoiceDialogAdjuntar(context)
                            : Text("El Folio es Requerido.");
                      },
                      child: new Text("Guardar")),
                ],
              );
            },
          );
        });
  }

  Future<void> _showChoiceFolioImg(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Center(
                  child: Text("Captura Folio"),
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
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: _inputFolioController,
                                    onSaved: (value) {
                                      folio = value;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Folio',
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
                              ],
                            ),
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
                  new TextButton(
                      onPressed: () {
                        _inputFolioController.value.text != ""
                            ? _showChoiceDialogAdjuntarImg(context)
                            : Text("El Folio es Requerido.");
                      },
                      child: new Text("Guardar")),
                ],
              );
            },
          );
        });
  }

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Gujarat, India'),
          );
        },
      ),
    );
  }

  Widget _getListaProvedores(BuildContext context) {
    return FutureBuilder(
      future:
          httpProv.postProveedores(_inputProveedorController.text.toString()),
      builder:
          (BuildContext context, AsyncSnapshot<List<Proveedor>?> snapshot) {
        if (snapshot.hasData) {
          return ListView(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20.0, bottom: 0.0),
              children: _listProveedor(snapshot.data!, context));
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  List<Widget> _listProveedor(List<Proveedor> items, BuildContext context) {
    final List<Widget> proveedor = [];

    items
      ..asMap().forEach((index, item) {
        final widgetTemp = Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: GestureDetector(
                onTap: () {
                  print("PROVE SELECCIONADOO : " +
                      _provedorSeleccionado.toString());
                  print("PROVEEDOR CLAVE : " + item.nombre.toString());
                  print("PROVEEDOR NOMBRE : " + item.proveedor.toString());
                  _regresarDos(
                      item.proveedor.toString(), item.nombre.toString());
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
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 8.0),
                    child: Column(
                      children: [
                        Text(
                          item.nombre!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
          ],
        );

        proveedor..add(widgetTemp);
      });

    return proveedor;
  }

  Future<void> _showChoiceDialogAdjuntar(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
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
                GestureDetector(
                  child: Text("Adjuntar Archivo"),
                  onTap: () {
                    _openDocs(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showChoiceDialogAdjuntarImg(BuildContext context) {
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
                GestureDetector(
                  child: Text("Adjuntar Archivo"),
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      SystemNavigator.pop();
                    }
                    _showChoiceDialog(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
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
        _nameImage = 'Cotizacion';
      });
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        SystemNavigator.pop();
      }
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
        _nameImage = 'Cotizacion';
      });
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        SystemNavigator.pop();
      }
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

  void _openDocs(BuildContext context) async {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd_MM_yyyy');
    var formatterHora = new DateFormat('HH:mm');
    String today = formatter.format(now);
    String hora = formatterHora.format(now);
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      int bytes = await file.length();
      if (bytes < 2000000.0) {
        this.setState(() {
          _filePDF = file;
          //_filePDFname = "Folio_" + _inputFolioController.value.text;
          _filePDFname = "Cotizacion";
        });
      } else {
        DAToast(_scaffoldKey,
            "Archivo demasiado grande, El archivo debe ser menor a 2MB");
      }
    } else {
      // User canceled the picker
    }

    Navigator.of(context).pop();
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    var i = (bytes / 1024).floor();
    return i;
  }

  _selectDatePromesa(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now(),
        lastDate: new DateTime(2022),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      var dia = picked.day.toString();
      var mes = picked.month.toString();
      var ano = picked.year.toString();
      print("FECHA FIN  : " + dia + "-" + mes + "-" + ano);
      setState(() {
        _fechaPromesa = generarFechaVista(dia, mes, ano);
        _fechaPromesaController.text = _fechaPromesa!;
      });
    }
  }
}
