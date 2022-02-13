import 'dart:async';
import 'dart:developer';

import 'package:best_flutter_ui_templates/src/config_app/login_page.dart';
import 'package:best_flutter_ui_templates/src/models/equipo_transporte_model.dart';
import 'package:best_flutter_ui_templates/src/models/llanta_plantilla_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_model.dart';
import 'package:best_flutter_ui_templates/src/pages/lista_llantas_detalle_page.dart';
import 'package:best_flutter_ui_templates/src/pages/lista_llantas_page.dart';
import 'package:best_flutter_ui_templates/src/pages/lista_servicio_page.dart';
import 'package:best_flutter_ui_templates/src/widgets/TicketFormulario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/config_app/main_config.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:best_flutter_ui_templates/src/utils/DAWidgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Icon cusIcon = Icon(Icons.search);
  Widget? cusSearchBar;
  double _sizeBoton = 0;
  int _selectedIndex = 1;
  List<IconData> _icons = [
    Icons.add,
    Icons.list,
    Icons.car_repair,
    Icons.circle
  ];
  SessionProvider prov = new SessionProvider();
  SessionModel usuario = new SessionModel();
  ScrollController scrollController = ScrollController();
  bool closeTopController = false; // Para estatus loading
  bool correctivo = false;
  bool maquinaria = false;
  int filterOptions = 0;
  bool _cargarActive = false;
  bool _saving = false; // Para estatus loading
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final filtersOptions = ["TODO", "CORRECTIVO", "PREVENTIVO"];
  List<String> _listaEstatus = [
    "TODO",
    "APROBADA",
    "PENDIENTE",
    "PROCESO",
    "EN APROBACION",
    "CERRADA",
    "RECHAZADA",
    "OM REVISION",
    "OM CONCLUIDO"
  ];
  String? _estatusSelected = "TODO";
  String filteText = "";
  final httpProv = new HttpProvider();
  SharedPreferences? prefs;
  String? rol;
  bool? _llantas = false;
  bool? _levantar = false;
  bool? _consultar = false;
  bool? _autorizar = false;

  List<LlantaPlantilla> dataLLantasPlantilla = [];

  EquipoTransporte? _opcionSeleccionadaVehiculo = new EquipoTransporte();
  List<EquipoTransporte> listaVehiculo = [];

  String? name1;
  String? name2;
  String? name3;
  String? name4;

  bool _medirVisible = true;

  var namesList = <String>[];
  List<FloatingActionButton> buttonsList = <FloatingActionButton>[];

  final formatCurrency = new NumberFormat.simpleCurrency();

  List<SolicitudPendiente>? listaServicios = [];
  List<SolicitudPendiente>? listaServiciosFiltered = [];
  List<SolicitudPendiente>? listaServiciosAutorizar = [];

  String imagenAppBar = "assets/background2.jpg";
  String imagenBack = "assets/background2.jpg";

  var refreshKeyServicios = GlobalKey<RefreshIndicatorState>();
  var refreshKeyServiciosAutoriza = GlobalKey<RefreshIndicatorState>();

  String today = "";

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DaScaffoldLoading(
        isLoading: _saving,
        keyLoading: _scaffoldKey,
        children: <Widget>[
          Scaffold(
              appBar: _navBar2() as PreferredSizeWidget?,
              backgroundColor: Colors.white,
              body: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: _getRenglonFiltros(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _getOptionMenu(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    height: 75.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(68.0),
                            bottomLeft: Radius.circular(68.0),
                            bottomRight: Radius.circular(68.0),
                            topRight: Radius.circular(68.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 5.0,
                          ),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _getListMenu(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    var now = new DateTime.now();
    //var formatter = new DateFormat('MM/dd/yyyy'); ANTES DEL API
    var formatter = new DateFormat('dd/MM/yyyy');
    today = formatter.format(now);
    _getPreferences();
    _getListaServicio();

    _getVehiculos();
  }

  Widget _getRenglonFiltros() {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              (_selectedIndex == 1 || _selectedIndex == 2)
                  ? getMenuSearch()
                  : SizedBox(height: 10),
              (_selectedIndex == 1 || _selectedIndex == 2)
                  ? //getMenuEstatus()
                  _getMenuEstatus()
                  : SizedBox(height: 10),
            ]),
        Divider()
      ],
    );
  }

  //comentario
  Widget _getOptionMenu() {
    switch (_selectedIndex) {
      case 0:
        return TicketFormulario(_change);
        break;
      case 1:
        return Container(
            height: MediaQuery.of(context).size.height * 0.70,
            child: _getlistaServicios());
        break;
      case 2:
        return Container(
            height: MediaQuery.of(context).size.height * 0.70,
            child: _getlistaServiciosAutoriza());
        break;
      case 3:
        return Container(
          height: MediaQuery.of(context).size.height * 1,
          child: Column(
            children: [
              _callTable(),
              _botonMedirLLantas(),
            ],
          ),
        );
        break;

      default:
        return Container();
        break;
    }
  }

  _getOptionMenuAfuera(int opcion) {
    switch (_selectedIndex) {
      case 0:
        return TicketFormulario(_change);
        break;
      case 1:
        return Container(
            height: MediaQuery.of(context).size.height * 0.70,
            child: _getlistaServicios());
        break;
      case 2:
        return Container(
            height: MediaQuery.of(context).size.height * 0.70,
            child: _getlistaServiciosAutoriza());
        break;
      case 3:
        return Container(
          height: MediaQuery.of(context).size.height * 1,
          child: Column(
            children: [
              _callTable(),
              _botonMedirLLantas(),
            ],
          ),
        );
        break;

      default:
        return Container();
        break;
    }
  }

  _change(bool cargando) {
    setState(() {
      _saving = cargando;
    });
  }

  _getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      rol = prefs!.getString("Rol");
      _levantar =
          prefs!.getBool("Levantar" == null ? true as String : "Levantar");
      _consultar =
          prefs!.getBool("Consultar" == null ? true as String : "Consultar");
      _llantas = prefs!.getBool("LLantas" == null ? true as String : "LLantas");
      _autorizar =
          prefs!.getBool("Autorizar" == null ? true as String : "Autorizar");
      _selectedIndex = _listMenuInitial(prefs);
    });
  }

  int _listMenuInitial(SharedPreferences? prefs) {
    int menu = 0;
    if (_llantas!) {
      menu = 3;
    }
    if (_levantar!) {
      menu = 0;
    }
    if (_consultar!) {
      menu = 1;
    }
    if (_autorizar! &&
        listaServiciosAutorizar!.length > listaServicios!.length) {
      menu = 2;
    }
    if (_autorizar! &&
        listaServiciosAutorizar!.length < listaServicios!.length) {
      menu = 1;
    }

    return menu;
  }

  List<Widget> _getListMenu() {
    List<Widget> menu = [];

    if (_levantar!) {
      menu.add(_buildIcon(0));
    }
    if (_consultar!) {
      menu.add(_buildIcon(1));
    }
    if (_autorizar!) {
      menu.add(_buildIcon(2));
    }
    if (_llantas!) {
      menu.add(_buildIcon(3));
    }
    return menu;
  }

  Future<Null> _getListaServicio() async {
    setState(() {
      _saving = false;
    });
    final List<SolicitudPendiente>? lista = await httpProv.spWebSolicitudEstado(
        null, "01/02/2021", today, null, null, null, null);

    setState(() {
      if (lista!.length <= 0) {
        listaServicios = [];
        listaServiciosFiltered = listaServicios;
      } else {
        listaServicios = lista;
        listaServiciosFiltered = listaServicios;
      }
    });
    _getListaServicioAutorizar();
  }

  Future<Null> _getListaServicioAutorizar() async {
    final List<SolicitudPendiente>? lista =
        await httpProv.spWebSolicitudAutorizar();
    setState(() {
      if (lista!.length <= 0) {
        listaServiciosAutorizar = [];
        _cargarActive = true;
      } else {
        listaServiciosAutorizar = lista;
        _cargarActive = false;
      }
    });
  }

  Future<Null> _getListaServicioRefresh() async {
    final List<SolicitudPendiente>? lista = await httpProv.spWebSolicitudEstado(
        null, "01/02/2021", "04/04/2021", null, null, null, null);

    setState(() {
      if (lista!.length <= 0) {
        refreshKeyServicios.currentState!.show(atTop: false);
        listaServicios = [];
        listaServiciosFiltered = listaServicios;
      } else {
        refreshKeyServicios.currentState!.show(atTop: false);
        listaServicios = lista;
        listaServiciosFiltered = listaServicios;
      }
    });
  }

  Future<Null> _getListaServicioAutorizarRefresh() async {
    final List<SolicitudPendiente>? lista =
        await httpProv.spWebSolicitudAutorizar();

    setState(() {
      if (lista!.length <= 0) {
        listaServiciosAutorizar = [];
        refreshKeyServiciosAutoriza.currentState!.show(atTop: false);
      } else {
        listaServiciosAutorizar = lista;
        log(listaServiciosAutorizar.toString());
        refreshKeyServiciosAutoriza.currentState!.show(atTop: false);
      }
    });
  }

  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          color: _selectedIndex == index ? Colors.black : Color(0xFFE7EBEE),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(_icons[index],
            color: _selectedIndex == index ? Colors.white : Color(0xFFB4C1C4)),
      ),
    );
  }

  Future<void> _displaOutSessionDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("¿Cerrar Sesión?"),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Cancelar'),
                onPressed: () {
                  setState(() {});
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('Aceptar'),
                onPressed: () {
                  _comprobarClose();
                  //_removeToken();
                },
              ),
            ],
          );
        });
  }

  _comprobarClose() async {
    print("enter _comprobarClose");
    Navigator.of(context, rootNavigator: true).pop('dialog');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(),
      ),
    );

    _removeToken();
  }

  _removeToken() async {
    print("enter _removeToken");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int cerrar = 1;
    String user = prefs.getString("Usuario")!;
    String? token = prefs.getString("Token");
    print("soy el user : " + user);
    print("soy el token : " + token.toString());
    if (token.toString() != "null") {
      print("Aqui 1");
      final List<Response> lista = await (httpProv.spAppUpdateToken(
          user, token, cerrar) as FutureOr<List<Response>>);
      if (lista[0].okRef == "Ok") {
        _closeSession();
      } else {
        _closeSession();
      }
    } else {
      print("Aqui 2");
      final List<Response> lista = await (httpProv.spAppUpdateToken(
          user, 'dfsdfsd', cerrar) as FutureOr<List<Response>>);
      if (lista[0].okRef == "Ok") {
        _closeSession();
      } else {
        _closeSession();
      }
    }
  }

  _closeSession() async {
    setState(() {
      _saving = true;
    });
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    //await preferences.clear();
    //preferences.remove('AuthToken'); ANTES DEL API
    //preferences.remove('Usuario'); ANTES DEL API
    final httpProv = new HttpProvider();
    await httpProv.logOut();
    SessionProvider prov = new SessionProvider();
    prov.reset();
    setState(() {
      _saving = false;
    });
    //_comprobarClose();
    //_comprobarClose();
  }

  Widget _navBar2() {
    var titleName = Text("LEVANTAR TICKET");

    bool options = false;
    switch (_selectedIndex) {
      case 0:
        titleName = Text(
          "LEVANTAR TICKET",
          style: TextStyle(fontSize: 16),
        );
        options = false;
        break;
      case 1:
        titleName = Text("SOLICITUDES DE MANTENIMIENTO",
            style: TextStyle(fontSize: 16));
        options = true;
        break;
      case 2:
        titleName = Text(
          "AUTORIZAR TICKET DE SERVICIO",
          style: TextStyle(fontSize: 16),
        );
        options = true;
        break;
      case 3:
        options = false;
        break;
      default:
    }

    /* if (_selectedIndex != 1) {
      setState(() {
        this.cusIcon = Icon(Icons.cancel);
      });
    }*/

    var actionsList = ([
      IconButton(
        icon: cusIcon,
        onPressed: () {
          setState(() {
            if (this.cusIcon.icon == Icons.search) {
              this.cusIcon = Icon(Icons.cancel);
              this.cusSearchBar = TextField(
                onChanged: (text) {
                  setState(() {
                    this.filteText = text;
                  });
                  filterList();
                },
                textInputAction: TextInputAction.go,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Buscar ...",
                  hintStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                //autofocus: true,
              );
              this._sizeBoton = 200;
            } else {
              this.cusIcon = Icon(Icons.search);
              setState(() {
                this.filteText = "";
              });
              this.cusSearchBar =
                  _selectedIndex == 3 ? _getDropdownVehiculos() : titleName;
              this._sizeBoton = 0;
            }
          });
        },
      ),
      IconButton(
          onPressed: () {
            _displaOutSessionDialog(context);
          },
          icon: Icon(Icons.login)),
    ]);

    return AppBar(
      automaticallyImplyLeading: false,
      title: this.cusIcon.icon == Icons.search
          ? (_selectedIndex == 3 ? _getDropdownVehiculos() : titleName)
          : this.cusSearchBar,
      actions:
          (_selectedIndex != 3 && _selectedIndex != 0 && _selectedIndex != 2)
              ? [actionsList[0], actionsList[1]]
              : [],
      flexibleSpace: Container(
          child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0.0),
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
            topRight: Radius.circular(0.0)),
        child: Container(
          child: Image.asset(
            imagenAppBar,
            fit: BoxFit.cover,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[500]!, Colors.blue[400]!],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      )),
      elevation: 20,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
    );
  }

  Widget getMenuSearch() {
    return Container(
      child: GroupButton(
        isRadio: true,
        spacing: 5,
        onSelected: (index, isSelected) => {
          setState(() {
            this.filterOptions = index;
          }),
          filterList()
        },
        buttons: filtersOptions,
      ),
    );
  }

  Widget getMenuEstatus() {
    return DropdownButtonFormField(
      isExpanded: true,
      value: _listaEstatus[0],
      items: _listaEstatus.map((_listaEstatus) {
        return DropdownMenuItem(
          value: _listaEstatus,
          child: Text(_listaEstatus),
        );
      }).toList(),
      onChanged: (dynamic val) {
        setState(() {
          _estatusSelected = val;
        });

        filterListEstatus();
      },
    );
  }

  Widget _buscarEstatus() {
    return Container(
        child: FloatingActionButton(
      backgroundColor: _getColor(_estatusSelected),
      mini: true,
      heroTag: null,
      onPressed: () {},
      child: Icon(Icons.search_sharp),
    ));
  }

  Color? _getColor(String? status) {
    switch (status) {
      case "TODO":
        return Color(0xffdac0a7);
        break;
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

  _getMenuEstatus() {
    return PopupMenuButton(
      child: _buscarEstatus(),
      itemBuilder: (BuildContext bc) => [
        PopupMenuItem(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                color: Color(0xffdac0a7),
                shape: BoxShape.rectangle,
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "TODO",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ]),
            ),
            value: "TODO"),
        PopupMenuItem(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                color: Colors.green[600],
                shape: BoxShape.rectangle,
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "APROBADA",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ]),
            ),
            value: "APROBADA"),
        PopupMenuItem(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                color: Colors.yellow[600],
                shape: BoxShape.rectangle,
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "PROCESO",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ]),
            ),
            value: "PROCESO"),
        PopupMenuItem(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                color: Colors.grey[600],
                shape: BoxShape.rectangle,
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "EN APROBACION",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ]),
            ),
            value: "EN APROBACION"),
        PopupMenuItem(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                color: Colors.blue[600],
                shape: BoxShape.rectangle,
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "CERRADA",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ]),
            ),
            value: "CERRADA"),
        PopupMenuItem(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                color: Colors.red[600],
                shape: BoxShape.rectangle,
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "RECHAZADA",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ]),
            ),
            value: "RECHAZADA"),
        PopupMenuItem(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                color: Colors.orange[600],
                shape: BoxShape.rectangle,
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "OM REVISION",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ]),
            ),
            value: "OM REVISION"),
        PopupMenuItem(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                color: Colors.green[300],
                shape: BoxShape.rectangle,
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "OM CONCLUIDO",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ]),
            ),
            value: "OM CONCLUIDO"),
      ],
      onSelected: (dynamic value) {
        setState(() {
          _estatusSelected = value;
        });
      },
    );
  }

  filterListEstatus() {
    print("algo : " + _estatusSelected.toString());
    setState(() {
      if (_estatusSelected.toString() != "TODO") {
        print("algo 2 : " + _estatusSelected.toString());
        this.listaServiciosFiltered = listaServicios!
            .where((servicio) =>
                servicio.estado!
                    .toUpperCase()
                    .contains(this._estatusSelected!.toUpperCase()) &&
                servicio.servicioTipoOrden!.toUpperCase().contains(
                    this.filtersOptions[this.filterOptions].toUpperCase()))
            .toList();
      } else {
        print("algo 3 : " + _estatusSelected.toString());
        this.listaServiciosFiltered = listaServicios;
      }
    });
  }

  Widget _getlistaServiciosAutoriza() {
    if (listaServiciosAutorizar!.length > 0) {
      return RefreshIndicator(
          key: refreshKeyServiciosAutoriza,
          child: ListaServiciosPage(
              listaServiciosAutorizar, 'Autorizaciones', context),
          onRefresh: _getListaServicioAutorizarRefresh);
    } else {
      return Center(
          child: Stack(
        children: [
          Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 28),
              child: _cargarActive == true ? Text('.') : Text('')),
          FloatingActionButton(
            child: Icon(Icons.autorenew),
            backgroundColor: Colors.green,
            onPressed: () {
              _cargarActive = true;
              _getListaServicioAutorizar();
            },
          ),
        ],
      ));
    }
  }

  void filterList() {
    setState(() {
      _saving = false;
      if (filterOptions == 0) {
        if (this.filteText.isNotEmpty && _estatusSelected != "TODO") {
          print("ENTRO AQU 0 ");
          this.listaServiciosFiltered = listaServicios!
              .where((servicio) =>
                  (servicio.descripcionActivo!
                      .toUpperCase()
                      .contains(this.filteText.toUpperCase())) ||
                  servicio.responsable!
                      .toUpperCase()
                      .contains(this.filteText.toUpperCase()) ||
                  servicio.movId!
                      .toUpperCase()
                      .contains(this.filteText.toUpperCase()) ||
                  servicio.servicioSerie!
                          .toUpperCase()
                          .contains(this.filteText.toUpperCase()) &&
                      servicio.estado!
                          .toUpperCase()
                          .contains(this._estatusSelected!.toUpperCase()))
              .toList();
        } else {
          if (filterOptions == 0 && _estatusSelected == "TODO") {
            print("ENTRO AQU 1 ");
            this.listaServiciosFiltered = listaServicios!
                .where((servicio) => ((servicio.descripcionActivo!
                        .toUpperCase()
                        .contains(this.filteText.toUpperCase())) ||
                    servicio.responsable!
                        .toUpperCase()
                        .contains(this.filteText.toUpperCase()) ||
                    servicio.movId!
                        .toUpperCase()
                        .contains(this.filteText.toUpperCase()) ||
                    servicio.servicioSerie!
                        .toUpperCase()
                        .contains(this.filteText.toUpperCase())))
                .toList();
          } else if (filterOptions != 0 && _estatusSelected != "TODO") {
            print("ENTRO AQU 2 ");
            this.listaServiciosFiltered = listaServicios!
                .where((servicio) =>
                    servicio.servicioTipoOrden!.toUpperCase().contains(this
                        .filtersOptions[this.filterOptions]
                        .toUpperCase()) &&
                    servicio.estado!
                        .toUpperCase()
                        .contains(this._estatusSelected!.toUpperCase()))
                .toList();
          } else if (filterOptions != 0 && _estatusSelected == "TODO") {
            print("ENTRO AQU 3 ");
            this.listaServiciosFiltered = listaServicios!
                .where((servicio) =>
                    servicio.servicioTipoOrden!.toUpperCase().contains(this
                        .filtersOptions[this.filterOptions]
                        .toUpperCase()) &&
                    servicio.estado!
                        .toUpperCase()
                        .contains(this._estatusSelected!.toUpperCase()))
                .toList();
          } else {
            print("ENTRO AQU 4 ");
            this.listaServiciosFiltered = listaServicios!
                .where((servicio) => servicio.estado!
                    .toUpperCase()
                    .contains(this._estatusSelected!.toUpperCase()))
                .toList();
          }
        }
      } else {
        if (this.filteText.isNotEmpty && _estatusSelected != "TODO") {
          print("ENTRO AQU 5 ");
          this.listaServiciosFiltered = listaServicios!
              .where((servicio) => ((servicio.descripcionActivo!
                          .toUpperCase()
                          .contains(this.filteText.toUpperCase()) ||
                      servicio.responsable!
                          .toUpperCase()
                          .contains(this.filteText.toUpperCase()) ||
                      servicio.servicioSerie!
                          .toUpperCase()
                          .contains(this.filteText.toUpperCase()) ||
                      servicio.movId!
                          .toUpperCase()
                          .contains(this.filteText.toUpperCase())) &&
                  servicio.estado!
                      .toUpperCase()
                      .contains(this._estatusSelected!.toUpperCase()) &&
                  servicio.servicioTipoOrden!.toUpperCase().contains(
                      this.filtersOptions[this.filterOptions].toUpperCase())))
              .toList();
        } else {
          if (filterOptions == 0 && _estatusSelected == "TODO") {
            print("ENTRO AQU 6 ");
            this.listaServiciosFiltered = listaServicios;
          } else if (filterOptions != 0 && _estatusSelected != "TODO") {
            print("ENTRO AQU 7 ");
            this.listaServiciosFiltered = listaServicios!
                .where((servicio) =>
                    servicio.servicioTipoOrden!.toUpperCase().contains(this
                        .filtersOptions[this.filterOptions]
                        .toUpperCase()) &&
                    servicio.estado!
                        .toUpperCase()
                        .contains(this._estatusSelected!.toUpperCase()))
                .toList();
          } else if (filterOptions != 0 && _estatusSelected == "TODO") {
            print("ENTRO AQU 8 ");
            this.listaServiciosFiltered = listaServicios!
                .where((servicio) =>
                    ((servicio.descripcionActivo!
                            .toUpperCase()
                            .contains(this.filteText.toUpperCase())) ||
                        servicio.responsable!
                            .toUpperCase()
                            .contains(this.filteText.toUpperCase()) ||
                        servicio.movId!
                            .toUpperCase()
                            .contains(this.filteText.toUpperCase()) ||
                        servicio.servicioSerie!
                            .toUpperCase()
                            .contains(this.filteText.toUpperCase()) ||
                        servicio.estado!
                            .toUpperCase()
                            .contains(this.filteText.toUpperCase())) &&
                    servicio.servicioTipoOrden!.toUpperCase().contains(
                        this.filtersOptions[this.filterOptions].toUpperCase()))
                .toList();
          } else {
            print("ENTRO AQU 9 ");
            this.listaServiciosFiltered = listaServicios!
                .where((servicio) => servicio.estado!
                    .toUpperCase()
                    .contains(this._estatusSelected!.toUpperCase()))
                .toList();
          }
        }
      }
    });
  }

  Widget _getlistaServicios() {
    if (listaServicios!.length > 0) {
      //filterListEstatus();
      filterList();
      return RefreshIndicator(
        key: refreshKeyServicios,
        child: ListaServiciosPage(listaServiciosFiltered, 'Pendiente', context),
        onRefresh: _getListaServicioRefresh,
      );
    } else {
      return Center(
        child: FloatingActionButton(
          child: Icon(Icons.autorenew),
          backgroundColor: Colors.green,
          onPressed: () {
            _getListaServicio();
          },
        ),
      );
    }
  }

  _callTable() {
    print("SOY EL VEHICULO: " + _opcionSeleccionadaVehiculo!.id.toString());
    final httpProv = new HttpProvider();
    return FutureBuilder(
        future: httpProv
            .spWebLlantasPlantilla(_opcionSeleccionadaVehiculo!.id.toString()),
        builder: (BuildContext context,
            AsyncSnapshot<List<LlantaPlantilla>?> snapshot) {
          if (snapshot.hasData) {
            return ListaLlantasPage(snapshot.data, 'Pendiente',
                scrollController, context, _opcionSeleccionadaVehiculo);
          } else {
            return Container(
                height: 400.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  validarLlantas([List<LlantaPlantilla>? data]) {
    bool value = false;
    for (var i = 0; i < data!.length; i++) {
      if (_validarEje(data[0].izqExt!) ||
          _validarEje(data[0].izqInt!) ||
          _validarEje(data[0].derInt!) ||
          _validarEje(data[0].derExt!)) {
        value = true;
      }
    }
    setState(() {
      _medirVisible = value;
    });
  }

  bool _validarEje(String llanta) {
    try {
      var parts = llanta.split('-');
      var prefix = parts[1].trim();
      if (prefix == "A") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Widget _servicioCardDetalle() {
    final widgetTemp = Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
          height: 650.0,
          width: 500.0,
          decoration: BoxDecoration(
              color: Colors.transparent,
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
            padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0),
                _getRenglonDos(),
                SizedBox(height: 70.0),
                _getRenglonCuatro(),
                SizedBox(height: 30.0),
                _getRenglonCuatro(),
                SizedBox(height: 10.0),
                _getRenglonDos(),
                //_getRenglon("Motivo", solicitudPendiente.mov),
                //_getRenglon("O.C", "NULL"),
              ],
            ),
          ),
        ),
      ],
    );

    return widgetTemp;
  }

  Widget _getRenglonDos() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black38,
                    tooltip: 'Hola',
                    onPressed: () {},
                    child: Icon(Icons.circle),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black38,
                    tooltip: 'Hola',
                    onPressed: () {},
                    child: Icon(Icons.circle),
                  ),
                )
              ]),
            ],
          ),
        ),
        Divider(
          color: Colors.white,
          height: 40,
        )
      ],
    );
  }

  Widget _getRenglonCuatro() {
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
                  alignment: Alignment.bottomLeft,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black38,
                    tooltip: 'Hola',
                    onPressed: () {},
                    child: Icon(Icons.circle),
                  ),
                ),
                Container(
                    alignment: Alignment.bottomLeft,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: FloatingActionButton(
                      backgroundColor: Colors.black38,
                      tooltip: 'Hola',
                      onPressed: () {},
                      child: Icon(Icons.circle),
                    )),
                Container(
                  alignment: Alignment.bottomRight,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black38,
                    tooltip: 'Hola',
                    onPressed: () {},
                    child: Icon(Icons.circle),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: FloatingActionButton(
                    backgroundColor: Colors.black38,
                    tooltip: 'Hola',
                    onPressed: () {},
                    child: Icon(Icons.circle),
                  ),
                ),
              ]),
            ],
          ),
        ),
        Divider(color: Colors.white, height: 40),
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
                    onTap: () => {})
              ]),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  List<Widget> _buildButtonsWithNames() {
    for (int i = 0; i < namesList.length; i++) {
      buttonsList.add(new FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.black,
          tooltip: namesList[i],
          child: Icon(Icons.circle)));
    }
    return buttonsList;
  }

  _getVehiculos() async {
    final List<EquipoTransporte> lista = await (httpProv.spWebEquipoTransporte()
        as FutureOr<List<EquipoTransporte>>);
    log("------LISTA DE VEHICULOS : -----" + lista.toString());
    if (lista.length <= 0) {
      _opcionSeleccionadaVehiculo = null;
      this.setState(() {
        listaVehiculo = [];
      });
    } else {
      _opcionSeleccionadaVehiculo = lista.first;
      this.setState(() {
        listaVehiculo = lista;
      });
    }
  }

  Widget _getDropdownVehiculos() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: DropdownButton<EquipoTransporte>(
                isExpanded: true,
                value: _opcionSeleccionadaVehiculo,
                hint: Text("Selecciona ..."),
                onChanged: (EquipoTransporte? newValue) {
                  setState(() {
                    _opcionSeleccionadaVehiculo = newValue;
                  });
                  _callTable();
                },
                items: listaVehiculo.map((EquipoTransporte vehiculo) {
                  String? descripcion = (vehiculo.serie!.isNotEmpty)
                      ? vehiculo.serie
                      : "Sin descripcion";
                  return new DropdownMenuItem<EquipoTransporte>(
                    value: vehiculo,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            vehiculo.serie! + " - " + vehiculo.descripcion1!,
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
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

  Widget _botonMedirLLantas() {
    String titulo = "Medir Llantas";
    Widget boton = Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
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
                  builder: (_) =>
                      ListaLlantasDetallePage(_opcionSeleccionadaVehiculo),
                ),
              ),
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

    if (_medirVisible) {
      return boton;
    } else {
      return Center();
    }
  }
}
