import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
import 'package:best_flutter_ui_templates/design_course/design_course_app_theme.dart';
import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/models/anexo_model.dart';
import 'package:best_flutter_ui_templates/src/models/anexos_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_detalle_model.dart';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_model.dart';
import 'package:best_flutter_ui_templates/src/pages/home_page.dart';
import 'package:best_flutter_ui_templates/src/utils/DAWidgets.dart';
import 'package:best_flutter_ui_templates/src/widgets/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DetalleAprobarTicket extends StatefulWidget {
  SolicitudPendiente solicitud;

  DetalleAprobarTicket(
    this.solicitud,
  );

  @override
  _DetalleAprobarTicketState createState() =>
      _DetalleAprobarTicketState(solicitud);
}

class _DetalleAprobarTicketState extends State<DetalleAprobarTicket> {
  SolicitudPendiente solicitudPendiente;

  _DetalleAprobarTicketState(
    this.solicitudPendiente,
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  bool closeTopController = false;
  SolicitudPendienteDetalle detalle = new SolicitudPendienteDetalle();
  bool cambio = false;
  final httpProv = new HttpProvider();
  bool _saving = false; // Para estatus loading
  Uint8List? _bytes;

  File? _imageFile = new File("demo.jpg");
  File? _archivoPDF;
  String _nameImage = "";

  List<Anexo> listaAnexos = [];

  @override
  void initState() {
    super.initState();

    _getDetalle();
    scrollController.addListener(() {
      setState(() {
        closeTopController = scrollController.offset > 40;
      });
    });
  }

  _getDetalle() async {
    var res = await (httpProv
            .detalleServicioFromJson(solicitudPendiente.id.toString())
        as FutureOr<List<SolicitudPendienteDetalle>>);

    if (res[0] != null) {
      setState(() {
        detalle = res[0];
      });
    } else {
      print("Error en la Consulta");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DaScaffoldLoading(
      isLoading: _saving,
      keyLoading: _scaffoldKey,
      children: <Widget>[
        Scaffold(
          appBar: NavBarCustom(solicitudPendiente.mov),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 1.2,
              child: Column(
                children: <Widget>[
                  _box(),
                  _servicioCardDetalle(),
                  _getFormularioTitle(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _getRenglonVerAnexos() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              child: TextButton.icon(
                  label: Text('Ver Imagen',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent)),
                  icon: Icon(
                    Icons.image,
                    size: 40.0,
                  ),
                  onPressed: () {
                    _getListImage();
                  })),
        ),
        SizedBox(width: 30.0),
        Flexible(
          child: Container(
              child: TextButton.icon(
                  icon: Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 40.0,
                  ),
                  label: Text('Ver PDF',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent)),
                  onPressed: () {
                    _getListPDF();
                  })),
        ),
      ],
    );
  }

  Widget _getRenglonModalVerAnexos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: TextButton.icon(
                label: Text('Ver Anexos',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent)),
                icon: Icon(
                  Icons.image,
                  size: 40.0,
                ),
                onPressed: () {
                  _getListAnexos();
                })),
      ],
    );
  }

  Future<void> _getListAnexos() async {
    setState(() {
      _saving = true;
    });
    final List<Anexo> resList =
        await (httpProv.getAnexo(solicitudPendiente.solicitudID.toString(), "")
            as FutureOr<List<Anexo>>);

    if (resList.length <= 0) {
    } else {
      if (resList[0].nombre != null) {
        setState(() {
          listaAnexos = resList;
        });
        _showChoiceDialogoListAnexos(context);
      } else {
        setState(() {
          listaAnexos = [];
          _saving = false;
        });
      }
    }
    setState(() {
      _saving = false;
    });
  }

  Future<void> _getListImage() async {
    setState(() {
      _saving = true;
    });
    var res = await (httpProv.getAnexo(
        solicitudPendiente.solicitudID.toString(),
        solicitudPendiente.movId.toString() +
            "_" +
            solicitudPendiente.mov.toString() +
            ".jpg") as FutureOr<List<Anexo>>);
    print(res);
    try {
      if (res[0].binFile != null || res[0].binFile != "null") {
        if (res[0].direccion != null || res[0].direccion != "null") {
          setState(() {
            _saving = false;
          });

          _getImage();
        } else {
          setState(() {
            _saving = false;
          });
        }
      }
    } catch (e) {
      print("Error al descargar");
      DAToast(_scaffoldKey, "Error al descargar, No hay Imagenes");
    }
    setState(() {
      _saving = false;
    });
  }

/* ANTES DEL API 
  Future<void> _getListImage() async {
    setState(() {
      _saving = true;
    });
    print("SOY EL ID :" + solicitudPendiente.id.toString());
    var res =
        await httpProv.spWebAnexoMovLista(solicitudPendiente.id.toString());
    for (var item in res) {
      print("RUTA ITERABLE: " + item.direccion.toString());
    }

    if (res.isNotEmpty) {
      if (res[0].direccion != null) {
        _getImage(res[0].direccion);
      } else {
        setState(() {
          _saving = false;
        });
      }
    }
    setState(() {
      _saving = false;
    });
  }*/

  Future<void> _getListPDF() async {
    setState(() {
      _saving = true;
    });

    print("SOY EL ID PDF :" + solicitudPendiente.id.toString());
    var res =
        await (httpProv.spWebAnexoMovLista(solicitudPendiente.id.toString())
            as FutureOr<List<Anexos>>);
    //print("RUTA PDF : " + res[1].direccion.toString());

    if (res.isNotEmpty) {
      if (res[1].direccion != null) {
        DAToastLong(_scaffoldKey, "Descargando PDF");
        _getPDF(res[1].direccion);
      } else {
        setState(() {
          _saving = false;
        });
      }
    }
    setState(() {
      _saving = false;
    });
  }

  Future<void> _getImage() async {
    setState(() {
      _saving = true;
    });

    var res = await (httpProv.getAnexo(
        solicitudPendiente.solicitudID.toString(),
        solicitudPendiente.movId.toString() +
            "_" +
            solicitudPendiente.mov.toString() +
            ".jpg") as FutureOr<List<Anexo>>);

    try {
      if (res[0].binFile != null || res[0].binFile != "null") {
        String image =
            res[0].binFile!.replaceAll("data:image/jpeg;base64,", "");
        Uint8List bytes = base64Decode(image);
        setState(() {
          _bytes = bytes;
          _nameImage = solicitudPendiente.movId.toString();
        });
        _showChoiceDialogoAnexosImagen(context, _bytes);
        //_showImageDialog(context);
        setState(() {
          _saving = false;
        });
      } else {
        print("ERROR AL DESCARGAR");
        setState(() {
          _saving = false;
        });
        DAToast(_scaffoldKey, "Error al descargar");
      }
    } catch (e) {
      print("error al descargar");
      DAToast(_scaffoldKey, "Error al descargar");
      setState(() {
        _saving = false;
      });
    }
  }

  Future<void> _getPDF(String? path) async {
    setState(() {
      _saving = true;
    });
    DAToast(_scaffoldKey, "Cargando PDF");

    var res = await (httpProv.getAnexo(
            solicitudPendiente.solicitudID.toString(),
            solicitudPendiente.movId! + "_Cotizacion.pdf")
        as FutureOr<List<Anexo>>);

    try {
      if (res[0].binFile != null) {
        //String pdf =res[0].binFile.replaceAll("data:application/pdf;base64,", "");
        String pdf = res[0].binFile!;
        String pdf_2 = "" + pdf;
        log("StringPDF:" + pdf_2);
        Uint8List bytes = base64.decode(pdf_2);

        final output = await getTemporaryDirectory();
        final file = File("${output.path}/example.pdf");
        await file.writeAsBytes(bytes.buffer.asUint8List());

        await OpenFile.open("${output.path}/example.pdf");
        setState(() {
          _saving = false;
        });
      } else {
        DAToast(_scaffoldKey, "Error al descargar if");
        setState(() {
          _saving = false;
        });
      }
    } catch (e) {
      print("ERROR PDF : " + e.toString());
      DAToast(_scaffoldKey, "Error al descargar catch");
      setState(() {
        _saving = false;
      });
    }
  }

  Future<void> _showChoiceDialogoListAnexos(BuildContext context) {
    setState(() {
      _saving = false;
    });
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Center(
                  child: Text("Anexos Adjuntos"),
                ),
                content: Container(
                  height: 250,
                  width: 250,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        listaAnexos != []
                            ? ListView(
                                shrinkWrap: true,
                                controller: scrollController,
                                children: _listaAnexos(listaAnexos, context),
                              )
                            : Center(
                                child: Text("SIN INFORMACIÓN"),
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
                      child: new Text("Cerrar")),
                ],
              );
            },
          );
        });
  }

  List<Widget> _listaAnexos(List<Anexo> items, BuildContext context) {
    final List<Widget> anexoss = [];

    if (items.length <= 0) {
      return [];
    }

    items.forEach((item) {
      final widgetTemp = Stack(
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              OutlinedButton(
                onPressed: () {
                  item.tipo == 'Imagen'
                      ? getSpecificImage(item)
                      : getSpecificPDF(item);
                },
                child: Text(
                  item.nombre!,
                ),
              ),
            ]),
          ),
        ],
      );
      anexoss..add(widgetTemp);
    });

    return anexoss;
  }

  getSpecificImage(items) async {
    setState(() {
      _saving = true;
    });
    if (items.binFile != null) {
      String image = items.binFile.replaceAll("data:image/jpeg;base64,", "");
      Uint8List bytes = base64Decode(image);
      setState(() {
        _bytes = bytes;
        _nameImage = solicitudPendiente.movId.toString();
        _saving = false;
      });
      _showChoiceDialogoAnexosImagen(context, _bytes);
    } else {
      setState(() {
        _saving = false;
      });
      DAToast(_scaffoldKey, "Error al descargar");
    }
  }

  getSpecificPDF(items) async {
    if (items.binFile != null) {
      //String pdf =res[0].binFile.replaceAll("data:application/pdf;base64,", "");
      String pdf = items.binFile;
      String pdf_2 = "" + pdf;
      log("StringPDF:" + pdf_2);
      Uint8List bytes = base64.decode(pdf_2);

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/example.pdf");
      await file.writeAsBytes(bytes.buffer.asUint8List());

      await OpenFile.open("${output.path}/example.pdf");
      setState(() {
        _saving = false;
      });
    } else {
      DAToast(_scaffoldKey, "Error al descargar if");
      setState(() {
        _saving = false;
      });
    }
  }

  Future<void> _showChoiceDialogoAnexosImagen(BuildContext context, _bytes) {
    setState(() {
      _saving = false;
    });
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Center(
                  child: Text(_nameImage),
                ),
                content: Container(
                  child: SingleChildScrollView(
                      child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _bytes != null
                                    ? Image.memory(_bytes)
                                    : Center(
                                        child: Text("SIN INFORMACIÓN"),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                actions: <Widget>[
                  new TextButton(
                      onPressed: () {
                        _regresar();
                      },
                      child: new Text("Cerrar")),
                ],
              );
            },
          );
        });
  }

  Future<void> _showChoiceDialogoAnexosPDF(BuildContext context, _bytes) {
    setState(() {
      _saving = false;
    });
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Center(
                  child: Text("Anexos"),
                ),
                content: Container(
                  child: SingleChildScrollView(
                      child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _bytes != null
                                    ? Image.memory(_bytes)
                                    : Center(
                                        child: Text("SIN INFORMACIÓN"),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
                actions: <Widget>[
                  new TextButton(
                      onPressed: () {
                        _regresar();
                      },
                      child: new Text("Cerrar")),
                ],
              );
            },
          );
        });
  }

  Widget _getImageButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    _imageFile = null;
                    _bytes = null;
                  });
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: Icon(
                  Icons.close,
                  size: 24,
                ),
                padding: EdgeInsets.all(12),
                shape: CircleBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }

  _regresar() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }

  Widget _title() {
    return Center(
      child: Text(
        "DETALLE TICKET SERVICIO",
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _box() {
    return SizedBox(height: 10.0);
  }

  Widget _getFormularioTitle() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 3.0),
          Text(
            'RECHAZAR / APROBAR',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
          SizedBox(height: 5.0),
          _cardAprobar()
        ],
      ),
    );
  }

  Widget _cardAprobar() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      height: 90.0,
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_getrengloSwitch()],
        ),
      ),
    );
  }

  Widget _getrengloSwitch() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(children: <Widget>[
            Icon(
              Icons.cancel_outlined,
              color: Colors.red,
              size: 40.0,
            ),
          ]),
          Container(
            width: MediaQuery.of(context).size.width * 0.55,
            child: FlutterSwitch(
              width: MediaQuery.of(context).size.width * 0.50,
              height: 20.0,
              toggleSize: 30.0,
              value: cambio,
              borderRadius: 30.0,
              activeColor: Colors.green,
              padding: 1.0,
              onToggle: (bool value) {
                _displayTextInputDialog(context);
              },
            ),
          ),
          Column(children: <Widget>[
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 40.0,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _servicioCardDetalle() {
    var dia = solicitudPendiente.fechaEmision!.day.toString();
    var mes = solicitudPendiente.fechaEmision!.month.toString();
    var ano = solicitudPendiente.fechaEmision!.year.toString();

    //print(newDateTimeObj2);

    //    var newDateTimeObj = new DateFormat().add_yMd().add_Hms().parse(fecha);

    final widgetTemp = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          height: 570.0,
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
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            child: Row(children: [
              Expanded(
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
                    _getRenglon(
                        "ECO", (detalle.eco == null) ? "" : detalle.eco!),
                    _getRenglon(
                        "CECO", (detalle.ceco == null) ? "" : detalle.ceco!),
                    _getRenglon("Usuario",
                        (detalle.usuario == null) ? "" : detalle.usuario!),
                    _getRenglon("Estatus",
                        (detalle.estatus == null) ? "" : detalle.estatus!),
                    _getRenglon("Motivo",
                        (detalle.motivo == null) ? "" : detalle.motivo!),
                    _getRenglon(
                        "O.C",
                        (detalle.ordenCompra == null)
                            ? ""
                            : detalle.ordenCompra),
                    //_getRenglonVerAnexos(),
                    _getRenglonModalVerAnexos(),
                    //_getRenglon("Motivo", solicitudPendiente.mov),
                    //_getRenglon("O.C", "NULL"),
                    SizedBox(height: 10.0),
                  ],
                ),
              )
            ]),
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Center(
                child:
                    Text("Autorizar Solicitud : " + solicitudPendiente.movId!)),
            content: Container(
              height: 70,
              width: 470,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FlatButton(
                    color: Colors.orange,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text('Cancelar'),
                    onPressed: () {
                      setState(() {
                        cambio = false;
                      });
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                  SizedBox(width: 7),
                  FlatButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text('Rechazar'),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      _rechazarMovimiento();
                      //_setProfundidad(item,context);
                    },
                  ),
                  SizedBox(width: 7),
                  FlatButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text('Autorizar'),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      _autorizarMovimiento();
                      //_setProfundidad(item,context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _autorizarMovimiento() async {
    setState(() {
      cambio = true;
      _saving = true;
    });
    final List<Response> lista = await (httpProv.spWebCambiarSituacion(
        'VTAS', solicitudPendiente.id) as FutureOr<List<Response>>);

    if (lista.length <= 0) {
    } else {
      if (lista[0].ok == null || lista[0].ok == "null") {
        setState(() {
          _saving = false;
        });
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          SystemNavigator.pop();
        }
      } else {
        setState(() {
          _saving = false;
        });
        //  _openSnackBarWithoutAction(context ,lista[0].okRef) ;
      }
    }
  }

  _rechazarMovimiento() async {
    setState(() {
      _saving = true;
      cambio = false;
    });

    final List<Response> lista = await (httpProv
        .spWebVentaCancelar(solicitudPendiente.id) as FutureOr<List<Response>>);

    if (lista.length <= 0) {
    } else {
      if (lista[0].ok == null || lista[0].ok == "null") {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          SystemNavigator.pop();
        }
      } else {
        //  _openSnackBarWithoutAction(context ,lista[0].okRef) ;
      }
    }
  }
}
