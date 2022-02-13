import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/providers/session_provider.dart';
import 'package:best_flutter_ui_templates/src/utils/DAWidgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'main_config.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //SessionProvider _prov = new SessionProvider();
  //SessionModel _usuario = new SessionModel();
  bool _saving = false; // Para estatus loading

  String _registros = '0';
  List<String> _respuesta = <String>[];

  ScrollController _scrollController = new ScrollController();

  // Imagenes y Camara
  final _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      // Si llega hasta el fondo de la lista
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DaScaffoldLoading(
      isLoading: _saving,
      appBar: mainAppBar('') as PreferredSizeWidget?,
      keyLoading: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _botonChido(),
      children: <Widget>[
        ListView.builder(
            controller: _scrollController,
            itemCount: int.parse(_registros),
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Container(
                  child: Center(
                      child: Text(
                    _respuesta[index],
                    textAlign: TextAlign.center,
                  )),
                  margin: const EdgeInsets.all(10.0),
                  color: Theme.of(context).primaryColor,
                  width: 240.0,
                  height: 48.0,
                ),
              );
            }),
        Padding(
          padding: const EdgeInsets.only(left: 6, top: 8),
          child: FloatingActionButton(
            child: Icon(Icons.keyboard_arrow_left),
            onPressed: () async => await _cambiarPagina('home'),
            heroTag: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6, top: 8),
          child: Align(
            child: FloatingActionButton(
              onPressed: () async => await _tomarImagen(),
              heroTag: null,
              child: Icon(Icons.camera),
            ),
            alignment: Alignment.topRight,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6, top: 72),
          child: Align(
            child: FloatingActionButton(
              onPressed: () async => _seleccionarImagen(),
              heroTag: null,
              child: Icon(Icons.image_search),
            ),
            alignment: Alignment.topRight,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6, top: 144),
          child: Align(
            child: FloatingActionButton(
              onPressed: () async => await _obtenerUbicacion(),
              heroTag: null,
              child: Icon(Icons.location_searching),
            ),
            alignment: Alignment.topRight,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6, top: 216),
          child: Align(
            child: FloatingActionButton(
              onPressed: () async => await _obtenerUltimaUbicacion(),
              heroTag: null,
              child: Icon(Icons.location_pin),
            ),
            alignment: Alignment.topRight,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6, top: 284),
          child: Align(
            child: FloatingActionButton(
              onPressed: () async => await _cambiarPagina('firma'),
              heroTag: null,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                child: SvgPicture.asset(
                  'assets/firma.svg',
                  color: Colors.white,
                  width: 25.0,
                  height: 25.0,
                ),
              ),
            ),
            alignment: Alignment.topRight,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6, top: 356),
          child: Align(
            child: FloatingActionButton(
              onPressed: () async => await _cambiarPagina('mapa'),
              heroTag: null,
              child: Icon(Icons.map),
            ),
            alignment: Alignment.topRight,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
              child: SizedBox(
                width: 150.0,
                height: 300.0,
                child: _image == null
                    ? Container()
                    : Image.file(
                        _image!,
                      ),
              ),
            )
          ],
        )
      ],
    );
  }

  _botonChido() {
    return FloatingActionButton(
        child: Icon(Icons.file_download),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async => await _obtenerDatos());
  }

  _cambiarPagina(String pagina) async {
    switch (pagina) {
      case 'firma':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Captura De Firma'),
            content: Text(
                'Favor de dibujar con el dedo su firma, al finalizar dar clic en Guardar'),
            actions: [
              FlatButton(
                  onPressed: () {
                    SessionProvider prov = new SessionProvider();
                    prov.reset();
                    Navigator.pushReplacementNamed(context, pagina);
                  },
                  child: Text('Entendido')),
            ],
          ),
        );
        break;
      case 'mapa':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Mapa'),
            content: Text(
                'Mantener seleccionado en el mapa para marcar algun punto'),
            actions: [
              FlatButton(
                  onPressed: () {
                    SessionProvider prov = new SessionProvider();
                    prov.reset();
                    Navigator.pushReplacementNamed(context, pagina);
                  },
                  child: Text('Entendido')),
            ],
          ),
        );
        break;
      default:
        SessionProvider prov = new SessionProvider();
        prov.reset();
        Navigator.pushReplacementNamed(context, pagina);
    }
  }

  _obtenerDatos() async {
    try {
      setState(() => _saving = true); // Loading start
      final httpProvider = new HttpProvider();
      List<dynamic>? data =
          //await httpProvider.httpGet("/CRUD/Art?c=Articulo", context);
          await httpProvider.httpGet("/CRUD/Sucursal?c=Nombre", context);
      setState(() {
        _registros = data!.length.toString();
        for (var i = 0; i < int.parse(_registros); i++) {
          _respuesta.add(data[i]["Nombre"].toString());
        }
        //debugPrint(data[0].toString());
        _saving = false;
      });
    } catch (e) {
      setState(() {
        _registros = '0';
        _saving = false;
        DAToast(_scaffoldKey, e.toString());
      });
    }
  }

  Future _tomarImagen() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tomar Fotografía'),
        content: Text(
            'Permite tomar una fotografía utilizando la cámara del dispositivo'),
        actions: [
          FlatButton(
              onPressed: () async {
                Navigator.pop(context);

                final pickedFile =
                    await _picker.getImage(source: ImageSource.camera);

                setState(() {
                  imageCache!.clear();
                  imageCache!.clearLiveImages();

                  if (pickedFile != null) {
                    _image = File(pickedFile.path);
                    debugPrint(_image!.path);
                  } else {
                    DAToast(_scaffoldKey, 'Imagen no seleccionada');
                  }
                });
              },
              child: Text('Entendido')),
        ],
      ),
    );
  }

  void _seleccionarImagen() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Seleccionar Imagen'),
        content: Text(
            'Permite seleccionar una imagen de la galería del dispositivo'),
        actions: [
          FlatButton(
              onPressed: () async {
                Navigator.pop(context);

                PickedFile? pickedFile =
                    await _picker.getImage(source: ImageSource.gallery);

                setState(() {
                  imageCache!.clear();
                  imageCache!.clearLiveImages();

                  if (pickedFile != null) {
                    _image = File(pickedFile.path);
                    debugPrint(_image!.path);
                  } else {
                    DAToast(_scaffoldKey, 'Imagen no seleccionada');
                  }
                });
              },
              child: Text('Entendido')),
        ],
      ),
    );
  }

  Future _obtenerUbicacion() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Obtener Ubicación'),
        content: Text('Permite obtener la ubicación actual del GPS'),
        actions: [
          FlatButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await _verificarGPS();

                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.bestForNavigation,
                      timeLimit: Duration(seconds: 10));

                  String ubicacion = position.latitude.toString() +
                      ", " +
                      position.longitude.toString();

                  DAToast(_scaffoldKey, ubicacion);
                } catch (e) {
                  DAToast(_scaffoldKey, e.toString());
                }
              },
              child: Text('Entendido')),
        ],
      ),
    );
  }

  Future _obtenerUltimaUbicacion() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Obtener Ultima Ubicación'),
        content: Text('Permite obtener la última ubicación del GPS'),
        actions: [
          FlatButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await _verificarGPS();

                  Position position = await (Geolocator.getLastKnownPosition() as FutureOr<Position>);

                  String ubicacion = position.latitude.toString() +
                      ", " +
                      position.longitude.toString();

                  DAToast(_scaffoldKey, ubicacion);
                } catch (e) {
                  DAToast(_scaffoldKey, e.toString());
                }
              },
              child: Text('Entendido')),
        ],
      ),
    );
  }

  Future _verificarGPS() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      await Geolocator.openLocationSettings();
    } else {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      }
    }
  }
}
