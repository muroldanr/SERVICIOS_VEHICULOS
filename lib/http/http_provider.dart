import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:best_flutter_ui_templates/fitness_app/models/login_model.dart';
import 'package:best_flutter_ui_templates/src/models/actividad_model.dart';
import 'package:best_flutter_ui_templates/src/models/activos_fijo_model.dart';
import 'package:best_flutter_ui_templates/src/models/anexo_model.dart';
import 'package:best_flutter_ui_templates/src/models/anexos_model.dart';
import 'package:best_flutter_ui_templates/src/models/causa_model.dart';
import 'package:best_flutter_ui_templates/src/models/equipo_transporte_model.dart';
import 'package:best_flutter_ui_templates/src/models/llanta_detalle_lista_model.dart';
import 'package:best_flutter_ui_templates/src/models/llanta_detalle_model.dart';
import 'package:best_flutter_ui_templates/src/models/llanta_disponble_model.dart';
import 'package:best_flutter_ui_templates/src/models/llanta_plantilla_model.dart';
import 'package:best_flutter_ui_templates/src/models/mecanico_model.dart';
import 'package:best_flutter_ui_templates/src/models/operador_model.dart';
import 'package:best_flutter_ui_templates/src/models/origen_model.dart';
import 'package:best_flutter_ui_templates/src/models/proveedor_model.dart';
import 'package:best_flutter_ui_templates/src/models/refacciones_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_ruta.dart';
import 'package:best_flutter_ui_templates/src/models/rol_model.dart';
import 'package:best_flutter_ui_templates/src/models/servicio_tipo_model.dart';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_detalle_model.dart';
import 'dart:io';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_model.dart';
import 'package:best_flutter_ui_templates/src/models/tipo_cambio.dart';
import 'package:best_flutter_ui_templates/src/models/tipo_operacion.dart';
import 'package:best_flutter_ui_templates/src/models/tipo_orden_model.dart';
import 'package:best_flutter_ui_templates/src/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:best_flutter_ui_templates/src/models/session_model.dart';
import 'package:best_flutter_ui_templates/src/providers/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'http_interceptor.dart';
import 'http_retry_policy.dart';
import 'package:http/http.dart' as https;
import 'package:best_flutter_ui_templates/src/utils/DAWidgets.dart';
// import 'http_routes.dart';

class HttpProvider {
  SessionProvider prefs = new SessionProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //String _url = 'b3903.online-server.cloud';//MASERP
  //String _url = '3.92.119.99:8096'; //INTELISIS
  //String _url = '200.57.183.109:8091'; //CONTADERO INTELISIS PRUEBAS
  String _url = '200.57.183.109:9903'; //CONTADERO API INTELISIS // PRUEBAS
  //String _url = '200.57.183.109:8085'; //CONTADERO API INTELISIS // PRODUCCION

  //String _db = 'Desarrollo'; //INTELISIS
  String _db = 'Conta'; //CONTADERO
  bool _cargando = false;

  getHeaders(SessionProvider prefs) {
    return {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
      "Access-Control-Allow-Headers": "Content-Type",
      "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
      'Authorization': 'Bearer ' + prefs.session.access!,
    };
  }

  final _client = HttpClientWithInterceptor.build(interceptors: [
    // Interceptor(),
  ]);

  String getEndPoinds(String sp) {
    switch (sp) {
      case 'spWebActivoFijo':
        return 'PROC' + '/spWebActivoFijo';

        break;
      case 'spWebServicioTipo':
        return 'PROC' + '/spWebServicioTipo';
        break;
      case 'spWebVentaSolicitud':
        return 'PROC' + '/spWebVentaSolicitud';
        break;
      case 'spWebArtActividadLista':
        return 'PROC' + '/spWebArtActividadLista';
        break;
      case 'spWebSolicitudDatalle':
        return 'PROC' + '/spWebSolicitudDatalle';
        break;
      case 'spWebSolicitudEstado':
        return 'PROC' + '/spWebSolicitudEstado';
        break;
      case 'spWebAvanzarActividad':
        return 'PROC' + '/spWebAvanzarActividad';
        break;
      case 'spWebVentaDescripcionLista':
        return 'PROC' + '/spWebVentaDescripcionLista';
        break;
      case 'spWebServicioOrigenLista':
        return 'PROC' + '/spWebServicioOrigenLista';
        break;
      case 'spWebServicioCausaLista':
        return 'PROC' + '/spWebServicioCausaLista';
        break;
      case 'spWebVentaDescripcion':
        return 'PROC' + '/spWebVentaDescripcion';
      case 'spWebLlantasPlantilla':
        return 'PROC' + '/spWebLlantasPlantilla';
      case 'spWebLlantaVehiculoLista':
        return 'PROC' + '/spWebLlantaVehiculoLista';
      case 'spWebEquipoTransporte':
        return 'PROC' + '/spWebEquipoTransporte';
        break;
      case 'spWebLlantaInfo':
        return 'PROC' + '/spWebLlantaInfo';
        break;
      case 'spWebSolicitudArtLista':
        return 'PROC' + '/spWebSolicitudArtLista';
        break;
      case 'spWebSolicitudArt':
        return 'PROC' + '/spWebSolicitudArt';
        break;
      case 'spWebLlantaDisponibleLista':
        return 'PROC' + '/spWebLlantaDisponibleLista';
        break;
      case 'spWebAsignaLlanta':
        return 'PROC' + '/spWebAsignaLlanta';
        break;
      case 'spWebLecturaLlanta':
        return 'PROC' + '/spWebLecturaLlanta';
        break;
      case 'spWebActualizarSolicitudArt':
        return 'PROC' + '/spWebActualizarSolicitudArt';
        break;
      case 'spWebDesasignaLlanta':
        return 'PROC' + '/spWebDesasignaLlanta';
        break;

      case 'spWebBajaLlanta':
        return 'PROC' + '/spWebBajaLlanta';
        break;

        break;
      case 'spWebEliminarSolicitudArt':
        return 'PROC' + '/spWebEliminarSolicitudArt';
        break;
      case 'spWebSolicitudAutorizar':
        return 'PROC' + '/spWebSolicitudAutorizar';
        break;
      case 'spWebCambiarSituacion':
        return 'PROC' + '/spWebCambiarSituacion';
        break;
      case 'spUsuarioRol':
        return 'PROC' + '/spUsuarioRol';
        break;
      case 'spWebVentaCancelar':
        return 'PROC' + '/spWebVentaCancelar';
        break;
      case 'spWebGenerarOrdenMatto':
        return 'PROC' + '/spWebGenerarOrdenMatto';
        break;
      case 'spAppUpdateToken':
        return 'PROC' + '/spAppUpdateToken';
        break;
      case 'spWebGenerarConsumoInterno':
        return 'PROC' + '/spWebGenerarConsumoInterno';
        break;
      case 'spWebMonTipoCambio':
        return 'PROC' + '/spWebMonTipoCambio';
        break;
      case 'spWebProvLista':
        return 'PROC' + '/spWebProvLista';
        break;
      case 'spWebServicioTipoOperacion':
        return 'PROC' + '/spWebServicioTipoOperacion';
        break;
      case 'spWebVentaPresupuesto':
        return 'PROC' + '/spWebVentaPresupuesto';
        break;
      case 'spWebAgenteMecanico':
        return 'PROC' + '/spWebAgenteMecanico';
        break;
      case 'spWebRutaAlmacenarAnexos':
        return 'PROC' + '/spWebRutaAlmacenarAnexos';
        break;
      case 'spWebRutaLlantasAnexos':
        return 'PROC' + '/spWebRutaLlantasAnexos';
        break;

      case 'upload':
        return 'api/upload';
        break;
      case 'spWebAnexoMovLista':
        return 'PROC' + '/spWebAnexoMovLista';
        break;
      case 'spWebAnexoMovServicio':
        return 'PROC' + '/spWebAnexoMovServicio';
        break;
      case 'spWebAnexoCtaLlanta':
        return 'PROC' + '/spWebAnexoCtaLlanta';
        break;
      case 'spWebVentaFolio':
        return 'PROC' + '/spWebVentaFolio';
        break;
      case 'spWebVentaActualizarOM':
        return 'PROC' + '/spWebVentaActualizarOM';
        break;

      case 'spWebOperadorLista':
        return 'PROC' + '/spWebOperadorLista';
        break;

      case 'download':
        return 'api/download';

      case 'anexos':
        return '/Anexo';
        break;

      case 'anexoCuenta':
        return '/AnexoCuenta';
        break;

      default:
        return '';
        break;
    }
  }

  final _clientInterceptor = HttpClientWithInterceptor.build(
    interceptors: [
      Interceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  Future test() async {
    var res;
    try {
      final Uri loginUri = Uri.parse(prefs.apiUri! + "/Help");

      res = await _client.get(loginUri).timeout(Duration(seconds: 5));
    } catch (e) {
      throw "Uri Inválida.";
    }
    return res;
  }

  Future login(SessionModel credenciales) async {
    var res;
    try {
      print("PREFS_APIURI: " + prefs.apiUri!);
      final Uri loginUri = Uri.parse(prefs.apiUri! + "/Login");

      final String data = grantPassword(credenciales);

      res = await _client.post(
        loginUri,
        body: data,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      ).timeout(Duration(seconds: 25));
    } catch (e) {
      throw "Servidor no válido.";
    }
    print(res);
    return res;
  }
  /*
  Future login(LoginRequestModel requestModel) async {
    var res;
    try {
      final String loginUri = "http://" + _url + "/api/login?database=$_db";

      //final String data = grantPassword(credenciales, licence);

      res = await _client
          .post(
            loginUri,
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Content-Type': 'application/json',
              "Access-Control-Allow-Headers": "Content-Type",
              "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
            },
            body: jsonEncode(<String, String>{
              'username': requestModel.username.toUpperCase(),
              'password': requestModel.password.toUpperCase()
            }),
          )
          .timeout(Duration(seconds: 25));

      //return LoginResponseModel.fromJson(jsonDecode(res.body));
    } catch (e) {
      print("Servidor no válido. $e");
    }

    print(res.body);
    return res;
  }*/

  Future refresh(SessionModel credenciales) async {
    var res;
    try {
      final Uri loginUri = Uri.parse(prefs.apiUri! + "/Login");
      final String data = grantRefresh(credenciales);

      res = await _client.post(
        loginUri,
        body: data,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      ).timeout(Duration(seconds: 25));
    } catch (e) {
      throw e;
    }
    return res;
  }

  Future logOut() async {
    var res;
    final Uri loginUri = Uri.parse(prefs.apiUri! + "/LogOut");
    try {
      res = await _clientInterceptor.post(loginUri,
          body: json.encode({"Estacion": prefs.session.estacion}),
          headers: {
            'Content-Type': 'application/json'
          }).timeout(Duration(seconds: 5));
    } catch (e) {
      return false;
    }
    return (res.statusCode == 200) ? true : false;
  }

  Future<List<dynamic>?> httpGet(String uri, BuildContext context) async {
    var res;
    final Uri loginUri = Uri.parse(prefs.apiUri! + uri);
    try {
      res = await _clientInterceptor.get(loginUri, headers: {
        "Content-Type": "application/json"
      }).timeout(Duration(seconds: 30));

      if (res.statusCode == 401) {
        prefs.reset();
        Navigator.pushReplacementNamed(context, 'login');
        throw "SESSION INVALIDA";
      }
    } catch (e) {
      throw e;
    }

    return jsonDecode(res.body);
  }

  Future<Response?> anexosCuenta(String id, String ruta, bool autorizado,
      String name, String ext, String mimeType, int size, String file) async {
    await prefs.validaRefresh();

    final url = Uri.http(_url, getEndPoinds('anexoCuenta'));

    print(url);

    print("SolicitudID:" + id.toString());
    print("Ruta:" + ruta.toString());
    print("Autorizado:" + autorizado.toString());
    print("NAMEEE:" + name.toString());
    print("ext:" + ext.toString());
    print("mimeType:" + mimeType.toString());
    print("size:" + size.toString());
    log("file:" + file.toString());
    print("NAMEEE:" + name.toString());

    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "Rama": "LLT",
            "Cuenta": id,
            "Ruta": ruta,
            "Autorizado": autorizado,
            "name": name,
            "extension": ext,
            "mimeType": mimeType,
            "size": size,
            "File": "data:image/jpeg;base64," + file
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJsonOne(resp.body);
    } else {
      return null;
    }
  }

  Future<Response?> anexos(int id, String? ruta, String? mov, String name,
      String ext, String mimeType, String file) async {
    await prefs.validaRefresh();

    final url = Uri.http(_url, getEndPoinds('anexos'));

    print(url);
    print("id:" + id.toString());
    print("ruta:" + ruta.toString());
    print("mov:" + mov.toString());
    print("name:" + name.toString());
    print("ext:" + ext.toString());
    print("mimetype:" + mimeType.toString());
    try {
      final resp = await https
          .post(
            url,
            headers: getHeaders(prefs),
            body: jsonEncode(<String, dynamic>{
              "ID": id,
              "Ruta": ruta,
              "Rama": "VTAS",
              "Mov": mov,
              "name": name,
              "extension": ext,
              "mimeType": mimeType,
              "File": file,
            }),
          )
          .timeout(Duration(seconds: 60));
      print("hasta aqui llego : " + resp.body);
      if (resp.statusCode == 200) {
        print("entro al if");
        return responseFromJsonOne(resp.body);
      } else {
        print("entro al else");
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Anexo>?> getAnexo(String id, String nombre) async {
    await prefs.validaRefresh();
    Map<String, String> queryParams = {
      'ID': id,
      'Rama': 'VTAS',
      'S': "1",
      'Nombre': nombre,
    };

    String queryString = Uri(queryParameters: queryParams).query;
    final url = Uri.http(_url, getEndPoinds('anexo'));

    final urlParameters = Uri.parse('$url/Anexo?' + queryString);
    print(urlParameters);
    final resp = await https
        .get(
          urlParameters,
          headers: getBasicHeaders(prefs),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    print(resp.statusCode);
    if (resp.statusCode == 200) {
      return anexoFromJson(resp.body);
    } else {
      return null;
    }
  }

  getBasicHeaders(SessionProvider prefs) {
    return {
      'Authorization': 'Bearer ' + prefs.session.access!,
    };
  }

  //  MASERP

  //  MASERP
  /*
  Future<List<SolicitudPendiente>> postServiciosPendientes() async {
    final url = Uri.http(_url, 'PROC' + '/sp/spWebSolicitudPendiente');

    try {
      return await _procesarRespuestaServiciosPendientes(url, prefs);
    } catch (e) {
      print("Servidor no válido. $e");
      return [];
    }
  }

  Future<List<SolicitudPendiente>> _procesarRespuestaServiciosPendientes(
      Uri url, SharedPreferences prefs) async {
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String>{
            "UsuarioWeb": pref,
          }),
        )
        .timeout(Duration(seconds: 25));

    return solicitudPendienteFromJson(resp.body);
  }
*/
  Future<List<TipoOperacion>?> postTipoOperacion() async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebServicioTipoOperacion'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return tipoOperacionFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Proveedor>?> postProveedores(String nombre) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebProvLista'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "Nombre": nombre
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return proveedorFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Mecanico>?> spWebAgenteMecanico() async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebAgenteMecanico'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return mecanicoFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<TipoOrden>> _procesarRespuestaTipoOperacion(
    Uri url,
  ) async {
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
          }),
        )
        .timeout(Duration(seconds: 25));

    final decodedData = json.decode(resp.body);
    final dataFallas = new TipoOrdenes.fromJsonList(decodedData);
    return dataFallas.items;
  }

  Future<List<ActivosFijos>?> getActivoFijo(String categoria) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebActivoFijo'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "Categoria": categoria,
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return activosFijosFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Operador>?> getOperadores(String servicioserie) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebOperadorLista'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "ServicioSerie": servicioserie
          }),
        )
        .timeout(Duration(seconds: 25));
    log("--RESPUESTA--");
    log(resp.body);
    if (resp.statusCode == 200) {
      return operadorFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<ServicioTipo>?> getServicioTipo(
      String? servicioSerie, String? servicioArticulo, String tipo) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebServicioTipo'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "ServicioSerie": servicioSerie,
            "ServicioArticulo": servicioArticulo,
            "Tipo": tipo,
          }),
        )
        .timeout(Duration(seconds: 25));

    if (resp.statusCode == 200) {
      return servicioTipoFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>> sptVentaSolicitud(
      String servicioSerie,
      String servicioArticulo,
      String tipoOrden,
      String tipo,
      String tipoClave,
      String observaciones,
      String prioridad,
      String kilometros,
      String operador) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebVentaSolicitud'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "ServicioSerie": servicioSerie,
            "ServicioArticulo": servicioArticulo,
            "ServicioTipoOrden": tipoOrden,
            "TipoOperacion": tipo,
            "ServicioTipo": tipoClave,
            "Observaciones": observaciones,
            "Prioridad": prioridad,
            "Kilometros": kilometros,
            "Operador": operador
          }),
        )
        .timeout(Duration(seconds: 50));

    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      await prefs.validaRefresh();
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.http(_url, getEndPoinds('spWebVentaSolicitud'));
      final resp = await https
          .post(
            url,
            headers: getHeaders(prefs),
            body: jsonEncode(<String, String?>{
              "UsuarioWeb": prefs.session.userweb,
              "ServicioSerie": servicioSerie,
              "ServicioArticulo": servicioArticulo,
              "ServicioTipoOrden": tipoOrden,
              "TipoOperacion": tipo,
              "ServicioTipo": tipoClave,
              "Observaciones": observaciones,
              "Prioridad": prioridad,
              "Kilometros": kilometros
            }),
          )
          .timeout(Duration(seconds: 50));
      return [];
    }
  }

  Future<List<Actividad>?> spWebArtActividadLista(String moduloID) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebArtActividadLista'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "ModuloID": moduloID,
          }),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);

    if (resp.statusCode == 200) {
      return actividadFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<SolicitudPendienteDetalle>?> detalleServicioFromJson(
      String id) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebSolicitudDatalle'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": id,
          }),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);

    if (resp.statusCode == 200) {
      return solicitudPendienteDetalleFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<SolicitudPendiente>?> spWebSolicitudEstado(
      String? estatus,
      String fechaD,
      String fechaA,
      String? estado,
      String? grupo,
      String? servicioSerie,
      String? servicioArticulo) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebSolicitudEstado'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "Estatus": estatus,
            "FechaD": fechaD,
            "FechaA": fechaA,
            "Estado": estado,
            "Grupo": grupo,
            "ServicioSerie": servicioSerie,
            "ServicioArticulo": servicioArticulo,
          }),
        )
        .timeout(Duration(seconds: 25));

    log("SOY EL spWebSolicitudEstado : " + resp.body);

    if (resp.statusCode == 200) {
      return solicitudPendienteFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebVentaDescripcion(
      String id,
      String descripcion,
      String causaOrigen,
      String sistemaOrigen,
      String refacciones,
      bool dolares,
      String tipoCambio,
      String folio,
      String fechaRequerida) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebVentaDescripcion'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": id,
            "Descripcion": descripcion,
            "OrigenCausa": causaOrigen,
            "SistemaOrigen": sistemaOrigen,
            "Refacciones": refacciones,
            "Dolares": dolares,
            "TipoCambio": tipoCambio,
            "Folio": folio,
            "FechaRequerida": fechaRequerida,
          }),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);

    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Origen>?> spWebServicioOrigenLista() async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebServicioOrigenLista'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
          }),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);

    if (resp.statusCode == 200) {
      return origenFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<LlantaDetalleLista>?> spWebLlantaVehiculoLista(
      String unidad) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebLlantaVehiculoLista'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String>{
            "Unidad": unidad,
          }),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);

    if (resp.statusCode == 200) {
      return llantaDetalleListaFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<EquipoTransporte>?> spWebEquipoTransporte() async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebEquipoTransporte'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
          }),
        )
        .timeout(Duration(seconds: 25));

    log(resp.body);

    if (resp.statusCode == 200) {
      return equipoTransporteFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Causa>?> spWebServicioCausaLista() async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebServicioCausaLista'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
          }),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);

    if (resp.statusCode == 200) {
      return causaFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future confirmarInputsDate(int? _rid, String _fechaA, String _fechaD) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebAvanzarActividad'));
    print("RID: " + _rid.toString());
    print("FECHA_A: " + _fechaA);
    print("FECHA_D: " + _fechaD);
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "RID": _rid,
            "Avanzar": 1,
            "FechaD": _fechaD,
            "FechaA": _fechaA,
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return resp;
    } else {
      return null;
    }
  }

  Future<List<ResponseRuta>?> spWebRutaAlmacenarAnexos(
    String moduloId,
  ) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebRutaAlmacenarAnexos'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": moduloId,
          }),
        )
        .timeout(Duration(seconds: 35));

    print(resp.body);
    if (resp.statusCode == 200) {
      return responseRutaFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<ResponseRuta>?> spWebRutaLlantasAnexos(
    String llanta,
  ) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebRutaLlantasAnexos'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "Llanta": llanta,
          }),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);
    if (resp.statusCode == 200) {
      return responseRutaFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<LlantaDetalle>?> spWebLlantaInfo(
      String _unidad, String _posicion) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebLlantaInfo'));
    final resp = await https
        .post(url,
            headers: getHeaders(prefs),
            body: jsonEncode(<String, dynamic>{
              "UsuarioWeb": prefs.session.userweb,
              "Unidad": _unidad,
              "Posicion": _posicion,
            }))
        .timeout(Duration(seconds: 25));

    print(resp.body);
    if (resp.statusCode == 200) {
      return llantaDetalleFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<LlantaPlantilla>?> spWebLlantasPlantilla(String unidad) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebLlantasPlantilla'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "Unidad": unidad
          }),
        )
        .timeout(Duration(seconds: 25));

    print("SOY EL RESPONSE DE LLANTAS :" + resp.body);
    if (resp.statusCode == 200) {
      return llantaPlantillaFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Refacciones>?> spWebSolicitudArtLista(String id) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebSolicitudArtLista'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String>{"ID": id}),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);
    if (resp.statusCode == 200) {
      return refaccionesFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebSolicitudArt(
      String id, String articulo, String precio, bool compra) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebSolicitudArt'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": id,
            "Articulo": articulo,
            "Precio": precio,
            "Compra": compra,
          }),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebVentaPresupuesto(
      String id,
      String descripcion,
      String causaOrigen,
      String sistemaOrigen,
      bool dolares,
      String tipoCambio,
      String fechaRequerida,
      String proveedor,
      String articulo,
      String precio,
      bool compra,
      String folio) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebVentaPresupuesto'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": id,
            "Descripcion": descripcion,
            "OrigenCausa": causaOrigen,
            "SistemaOrigen": sistemaOrigen,
            "Dolares": dolares,
            "TipoCambio": tipoCambio,
            "FechaRequerida": fechaRequerida,
            "Proveedor": proveedor,
            "Articulo": articulo,
            "Precio": precio,
            "Compra": compra,
            "Folio": folio,
          }),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  //LLANTAS
  Future<List<Response>?> spWebDesasignaLlanta(
      int unidad, // String antes del API
      int asignacion, // String antes del API
      String causa,
      String comentario,
      int kilometros, // String antes del API
      int profundidad // String antes del API
      ) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebDesasignaLlanta'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<dynamic, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "Unidad": unidad,
            "Asignacion": asignacion,
            "Causa": causa,
            "Comentario": comentario,
            "Kilometros": kilometros,
            "Profundidad": profundidad
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebBajaLlanta(int unidad, int asignacion,
      String causa, String comentario, int kilometros, int profundidad) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebBajaLlanta'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<dynamic, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "Unidad": unidad,
            "Asignacion": asignacion,
            "Causa": causa,
            "Comentario": comentario,
            "Kilometros": kilometros,
            "Profundidad": profundidad
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebVentaFolio(
    String id,
    String folio,
  ) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebVentaFolio'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<dynamic, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": id.toString(),
            "Folio": folio.toString(),
          }),
        )
        .timeout(Duration(seconds: 25));

    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<LlantasDisponibles>?> spWebLlantaDisponibleLista(
      String llanta) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebLlantaDisponibleLista'));
    final resp = await https
        .post(url,
            headers: getHeaders(prefs),
            body: jsonEncode(<String, dynamic>{
              "UsuarioWeb": prefs.session.userweb,
              "Llanta": llanta
            }))
        .timeout(Duration(seconds: 25));

    print(resp.body);
    if (resp.statusCode == 200) {
      return llantasDisponiblesFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebAsignaLlanta(
      String unidad,
      String llanta,
      int asignacion,
      String comentario,
      int kilometros,
      String profundidad) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebAsignaLlanta'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "Unidad": unidad,
            "Llanta": llanta,
            "Asignacion": asignacion,
            "Comentario": comentario,
            "Kilometros": kilometros,
            "Profundidad": profundidad
          }),
        )
        .timeout(Duration(seconds: 25));
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebLecturaLlanta(String unidad, int asignacion,
      String comentario, int kilometros, String profundidad) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebLecturaLlanta'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "Unidad": unidad,
            "Asignacion": asignacion,
            "Comentario": comentario,
            "Kilometros": kilometros,
            "Profundidad": profundidad
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebActualizarSolicitudArt(
      int? id, int? renglon, bool? compra) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebActualizarSolicitudArt'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": id,
            "Renglon": renglon,
            "Compra": compra,
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebEliminarSolicitudArt(
      int? id, int? renglon) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.validaRefresh();
    final url = Uri.http(_url, getEndPoinds('spWebEliminarSolicitudArt'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": id,
            "Renglon": renglon,
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<SolicitudPendiente>?> spWebSolicitudAutorizar() async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebSolicitudAutorizar'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
          }),
        )
        .timeout(Duration(seconds: 25));
    log("spWebSolicitudAutorizar");
    log(resp.body);
    if (resp.statusCode == 200) {
      return solicitudPendienteFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebCambiarSituacion(
      String modulo, int? moduloID) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebCambiarSituacion'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "Modulo": modulo,
            "ModuloID": moduloID,
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Rol>?> spUsuarioRol(String usuarioWeb) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.validaRefresh();
    final url = Uri.http(_url, getEndPoinds('spUsuarioRol'));
    print("URL: " + url.toString());
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": usuarioWeb,
          }),
        )
        .timeout(Duration(seconds: 25));
    if (resp.statusCode == 200) {
      return rolFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebGenerarOrdenMatto(String id) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.validaRefresh();
    final url = Uri.http(_url, getEndPoinds('spWebGenerarOrdenMatto'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": id,
            // "TareaRealizadas": tarearealizadas,
            // "FechaInicio": fechaInicio,
            // "FechaFin": fechaFin,
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebVentaCancelar(int? id) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebVentaCancelar'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": id,
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spAppUpdateToken(
      String? usuarioWeb, String? token, int cerrar) async {
    //await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spAppUpdateToken'));

    print("URL: " + _url.toString());
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, dynamic>{
            "UsuarioWeb": usuarioWeb,
            "Token": token,
            "Cerrar": cerrar
          }),
        )
        .timeout(Duration(seconds: 25));
    print("RESPONSE spAppUpdateToken");
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebVentaActualizarOM(
    String id,
    String tareasRealizadas,
    String fechaInicio,
    String fechaFin,
    String agente,
    String kilometros,
  ) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebVentaActualizarOM'));
    if (fechaInicio != "" && fechaFin != "") {
      final resp = await https
          .post(
            url,
            headers: getHeaders(prefs),
            body: jsonEncode(<String, String?>{
              "UsuarioWeb": prefs.session.userweb,
              "ID": id,
              "TareaRealizadas": tareasRealizadas,
              "FechaInicio": fechaInicio,
              "FechaFin": fechaFin,
              "Agente": agente,
              "Kilometros": kilometros
            }),
          )
          .timeout(Duration(seconds: 25));
      print(resp.body);
      if (resp.statusCode == 200) {
        return responseFromJson(resp.body);
      } else {
        return null;
      }
    } else {
      final resp = await https
          .post(
            url,
            headers: getHeaders(prefs),
            body: jsonEncode(<String, String?>{
              "UsuarioWeb": prefs.session.userweb,
              "ID": id,
              "Agente": agente,
              "Kilometros": kilometros
            }),
          )
          .timeout(Duration(seconds: 25));
      print(resp.body);
      if (resp.statusCode == 200) {
        return responseFromJson(resp.body);
      } else {
        return null;
      }
    }
  }

  Future<List<Response>?> spWebGenerarConsumoInterno(
    String id,
  ) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebGenerarConsumoInterno'));

    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": id,
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<TipoCambio>?> spWebMonTipoCambio() async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebMonTipoCambio'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String>{}),
        )
        .timeout(Duration(seconds: 25));

    print(resp.body);

    if (resp.statusCode == 200) {
      return tipoCambioFromJson(resp.body);
    } else {
      return null;
    }
  }
  /*
  Future<bool> upload(File filename, String path) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();

    final url = Uri.http(_url, getEndPoinds('upload'));
    final _token = prefs.getString("AuthToken");
    var request = https.MultipartRequest('POST', url);
    request.headers['authorization'] = 'Bearer $_token';

    request.files
        .add(await https.MultipartFile.fromPath('file', filename.path));
    request.files.add(https.MultipartFile.fromString('path', path));

    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }*/

  Future<bool> upload(File filename, String path) async {
    await prefs.validaRefresh();
    final url = Uri.http(_url, getEndPoinds('upload'));

    final _token = prefs.session.access;
    var request = https.MultipartRequest('POST', url);
    request.headers['authorization'] = 'Bearer $_token';

    request.files
        .add(await https.MultipartFile.fromPath('file', filename.path));
    request.files.add(https.MultipartFile.fromString('path', path));

    var response = await request.send().timeout(Duration(seconds: 60));
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<List<Anexos>?> spWebAnexoMovLista(String id) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebAnexoMovLista'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "Modulo": "VTAS",
            "ModuloID": id
          }),
        )
        .timeout(Duration(seconds: 25));
    if (resp.statusCode == 200) {
      return anexosFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<Response> download(path) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('download'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String>{
            // "UsuarioWeb": prefs.session.userweb,
            "path": path,
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    print(resp.statusCode);
    if (resp.statusCode == 200) {
      return responseFromJsonOne(resp.body);
    } else {
      return responseFromJsonOne(resp.body);
    }
  }

  Future<List<Response>?> spWebAnexoMovServicio(
      String id, String documento, String pathanexo, String tipo) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebAnexoMovServicio'));
    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "ID": id,
            "Documento": documento,
            "PathAnexo": pathanexo,
            "Tipo": tipo
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }

  Future<List<Response>?> spWebAnexoCtaLlanta(String unidad, String llanta,
      String posicion, String documento, String pathanexo, String tipo) async {
    await prefs.validaRefresh();
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.http(_url, getEndPoinds('spWebAnexoCtaLlanta'));
    print(url);
    print("UNIDAD: " + unidad);
    print("llanta: " + llanta);
    print("posicion: " + posicion);
    print("documento: " + documento);
    print("pathanexo: " + pathanexo);
    print("tipo: " + tipo);

    final resp = await https
        .post(
          url,
          headers: getHeaders(prefs),
          body: jsonEncode(<String, String?>{
            "UsuarioWeb": prefs.session.userweb,
            "Unidad": unidad,
            "Llanta": llanta,
            "Posicion": posicion,
            "Documento": documento,
            "PathAnexo": pathanexo,
            "Tipo": tipo
          }),
        )
        .timeout(Duration(seconds: 25));
    print(resp.body);
    if (resp.statusCode == 200) {
      return responseFromJson(resp.body);
    } else {
      return null;
    }
  }
}
