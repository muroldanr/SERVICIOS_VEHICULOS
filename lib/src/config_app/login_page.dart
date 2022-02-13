import 'dart:async';
import 'dart:convert';
import 'package:best_flutter_ui_templates/fitness_app/models/login_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/models/rol_model.dart';
import 'package:best_flutter_ui_templates/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/models/session_model.dart';
import 'package:best_flutter_ui_templates/src/providers/session_provider.dart';
import 'package:best_flutter_ui_templates/src/utils/DAWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import 'main_config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Para agilizar snackbar y loading
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SessionProvider _prov = new SessionProvider();
  SessionModel _modelForm = new SessionModel();
  bool _saving = false; // Para estatus loading
  LoginRequestModel? requestModel;
  Future<LoginResponseModel>? responseModel;
  final httpProv = new HttpProvider();
  int noInicios = 0;

  // Form controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  // API
  TextEditingController _apiController = new TextEditingController();
  void onValueChange() {
    setState(() {
      _apiController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiController.text = _prov.apiUri!;
    _apiController.addListener(onValueChange);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: DaScaffoldLoading(
          isLoading: _saving,
          keyLoading: _scaffoldKey,
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          //floatingActionButton: _configAPI(),
          children: <Widget>[
            _background(),
            _loginForm(),
          ],
        ));
  }

  // API
  Widget _configAPI() {
    return FloatingActionButton(
      child: Icon(
        _prov.connected ? Icons.cloud_done : Icons.cloud_off,
        color: Colors.white70,
        size: 30.0,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: _apiDialog,
    );
  }

  void _apiDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return DAInputDialog(
            title: 'Configurar app',
            subtitle: 'Ingrese Uri de API First',
            okText: 'Conectar',
            input: DAInput(
              padding: 0.0,
              tipo: 'url',
              controller: _apiController,
              onSaved: (value) {
                _prov.apiUri = _apiController.text;
              },
            ),
            onPressed: _validaAPI,
          );
        });
  }

  Future<void> _validaAPI() async {
    try {
      Navigator.of(context).pop();
      setState(() {
        _prov.connected = false;
        _prov.apiUri = _apiController.text;
        _saving = true;
      }); // Loading start

      final httpProv = new HttpProvider();
      var res = await httpProv.test();
      _prov.connected = (res.statusCode == 200);

      String msg = (res.statusCode == 200)
          ? 'Conexión Exitosa'
          : 'Error de servidor: ${res.reasonPhrase.toString()}';
      DAToast(_scaffoldKey, msg);

      setState(() => _saving = false); // L
    } catch (e) {
      // ignore: unused_element
      setState(() {
        _saving = false; // Loading end
        _prov.connected = false;
        DAToast(_scaffoldKey, e.toString());
      });
    }
  }

  // Fondo
  Widget _background() {
    // Obtiene datos de main.dart, logo y nombre de app
    return DaBackground(
      label: appName,
      image: loginLogo(),
    );
  }

  // Login
  Widget _loginForm() {
    return DaFloatingForm(
      title: 'Ingresa con tu cuenta',
      formKey: _formKey,
      children: <Widget>[
        DAInput(
          tipo: 'email',
          label: 'Usuario',
          controller: _emailController,
          onSaved: (value) {
            _modelForm.username = value;
          },
        ),
        SizedBox(height: 20.0),
        DAInput(
          tipo: 'password',
          label: 'Contraseña',
          controller: _passController,
          onSaved: (value) {
            _modelForm.password = value;
          },
        ),
        SizedBox(height: 40.0),
        // Login Button
        DAButton(
          label: 'Ingresar',
          onPressed: () async => await _login(),
        ),
      ],
    );
  }

  Future<void> _login() async {
    // setState(() async {
    final form = _formKey.currentState!;
    form.save();

    if (!_prov.connected) {
      DAToast(_scaffoldKey, 'Requiere configurar un API válida');
      return;
    }

    if (form.validate()) {
      try {
        setState(() => _saving = true); // Loading start

        final httpProv = new HttpProvider();
        _modelForm.intelisisMK = 'App_mantenimiento';
        print("USUARIO: " + _modelForm.username.toString());

        print("PASSWORD: " + _modelForm.password.toString());
        var res = await httpProv.login(_modelForm);

        if (res.statusCode == 200) {
          //almacenar refresh token y access token
          var respuesta = json.decode(res.body);
          _prov.session = sessionModelFromLogin(respuesta);
          _formKey.currentState!.reset();
          log("RESPUESTA: " + respuesta.toString());
          noInicios++;
          print("NUMERO DE INCIIOS: " + noInicios.toString());

          setState(() => _saving = false); // Loading end

          log("RESPONSE ACCESS : " + _prov.session.access.toString());
          print("RESPONSE USERNAME : " + _prov.session.username.toString());
          print("RESPONSE USERWEB : " + _prov.session.userweb.toString());
          _getRole(_prov.session.userweb, _prov.session.access);
          //Navigator.pushReplacementNamed(context, 'home');
        } else if (res.statusCode == 400) {
          print("ENTRO AQUI");
          var respuesta = json.decode(res.body);
          String msg = respuesta["error_description"].toString() +
              " " +
              respuesta["error"].toString();
          DAToast(_scaffoldKey, msg);
          //_snakeBar(msg);
        } else {
          //ERROR NO CONTROLADO DESDE EL API
          String msg = res.reasonPhrase.toString();
          DAToast(_scaffoldKey, 'Error de servidor: $msg');
        }

        setState(() => _saving = false); // Loading end
      } catch (e) {
        setState(() => _saving = false); // Loading end
        DAToast(_scaffoldKey, e.toString());
      }
    }
  }
/*
  _login() async {
    setState(() => _saving = true); // L
    final form = _formKey.currentState;
    form.save();
    try {
      final httpProv = new HttpProvider();
      var res = await httpProv.login(requestModel);
      if (res.statusCode == 200) {
        //almacenar refresh token y access token
        noInicios++;
        print("NUMERO DE INCIIOS: " + noInicios.toString());
        var jwt = res.body;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        LoginResponseModel responseModel = loginResponseFromJson(jwt);
        prefs.setString("AuthToken", responseModel.authToken);
        setState(() => _saving = false); // Loading end
        _getRole(requestModel.username, responseModel.authToken);
      } else {
        _alertTextLogin(context);
      }
    } catch (e) {
      setState(() => _saving = false); // Loading end
      //DAToast(_scaffoldKey, e.toString());
    }
  }*/

  Future<void> _alertTextLogin(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Center(child: Text("Credenciales incorrectas")),
            actions: <Widget>[
              new TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    setState(() => _saving = false);
                  },
                  child: new Text("Cancelar")),
            ],
          );
        });
  }

  _getRole(String? user, String? token) async {
    print("WebUsuario: " + user.toString());
    final List<Rol>? lista = await httpProv.spUsuarioRol(user.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (lista!.isNotEmpty) {
      prefs.setString("AuthToken", token!);
      prefs.setString("Usuario", user!);
      prefs.setBool("Levantar", lista[0].levantar!);
      prefs.setBool("Procesar", lista[0].procesar!);
      prefs.setBool("Afectar", lista[0].afectar!);
      prefs.setBool("Consultar", lista[0].consultar!);
      prefs.setBool("LLantas", lista[0].lLantas!);
      prefs.setBool("Autorizar", lista[0].autorizar!);
      _setToken(user, prefs.getString("Token"));
    } else {
      prefs.clear();
    }
  }

  _setToken(String? user, String? token) async {
    if (token == null) {
      print("ENTRO AQUI TOK");
      token = "dfsdfsd";
      setState(() => _saving = true);
      _alertTokenError(context);
    }
    print("ENTRO ACA TOK");
    log(token);
    int cerrar = 0;
    final List<Response>? lista =
        await (httpProv.spAppUpdateToken(user, token, cerrar));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lista!.isNotEmpty) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else {
      prefs.clear();
    }
  }

  Future<void> _alertTokenError(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Center(child: Text("Token de notificaciònes no valido")),
            actions: <Widget>[
              new TextButton(
                  onPressed: () {
                    setState(() => _saving = false);
                    _closeSession();
                  },
                  child: new Text("Cancelar")),
            ],
          );
        });
  }

  _closeSession() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //await preferences.clear();
    preferences.remove('AuthToken');
    preferences.remove('Usuario');
    _comprobarClose();
  }

  _comprobarClose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('Usuario'));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(),
      ),
    );
  }

  _openSnackBarWithoutAction(BuildContext context, String title) {
    final snackBar = SnackBar(
      content: Text(title),
      duration: Duration(seconds: 5),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
