import 'dart:convert';
import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/models/session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SessionProvider {
  static SessionProvider _instancia = new SessionProvider._internal();
  static SessionModel _session = new SessionModel();
  static String? _apiUri;
  static bool _connected = false;

  factory SessionProvider() {
    return _instancia;
  }

  SessionProvider._internal();
  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  validaRefresh() async {
    this._loadSession();

    if (_session.access == null) {
      return false;
    }

    DateTime now = new DateTime.now();
    DateTime token = _session.expires ?? now;
    int difference = token.difference(now).inMinutes;

    if (difference <= 0) {
      if (_session.refresh == null) {
        this.reset();
        return false;
      }

      final httpProv = new HttpProvider();
      var res = await httpProv.refresh(_session);
      if (res.statusCode == 200) {
        var respuesta = json.decode(res.body);
        _session = sessionModelFromLogin(respuesta);
        _instancia.session = _session;
        return true;
      } else {
        return false;
      }
    }

    return true;
  }

  validaToken() {
    this._loadSession();

    if (_session.access == null || _session.refresh == null) {
      return false;
    }

    return true;
  }

  void reset() {
    _session.username = null;
    _session.userweb = null;
    _session.password = null;
    _session.access = null;
    _session.refresh = null;
    _session.expires = null;

    String sessionString = sessionModelToJsonString(_session);
    _prefs.setString('session', sessionString);
  }

  _loadSession() {
    String? sessionString = _prefs.getString('session') ?? null;
    print(sessionString);
    if (sessionString != null && sessionString != '') {
      _session = sessionModelFromJsonString(sessionString);
    }
  }

  bool _toBoolean(String? str, [bool? strict]) {
    if (str == null) return false;
    if (strict == true) {
      return str == '1' || str == 'true';
    }
    return str != '0' && str != 'false' && str != '';
  }

  // GET y SET de Login
  get iconConnected {
    var x = _prefs.getString('apiconn');
    var _ac = _toBoolean(x);
    _connected = (_ac == null || _ac == false) ? false : true;
    return _connected;
  }

  bool get connected {
    var x = _prefs.getString('apiconn');
    var _ac = _toBoolean(x);
    _connected = (_ac == null || _ac == false) ? false : true;
    return /*_connected*/ true;
  }

  set connected(bool value) {
    _connected = (value == null || value == false) ? false : true;
    _prefs.setString('apiconn', _connected.toString().toLowerCase());
  }

  // GET y SET de Login

  String? get apiUri {
    _apiUri = _prefs.getString('apiUri') ?? "http://200.57.183.109:9903";
    return _apiUri;
  }

  set apiUri(String? value) {
    _apiUri = value;
    _prefs.setString('apiUri', _apiUri!);
  }

  // ignore: unnecessary_getters_setters
  SessionModel get session {
    //_loadSession();
    return _session;
  }

  // ignore: unnecessary_getters_setters
  set session(SessionModel value) {
    _session = value;

    String sessionString = sessionModelToJsonString(_session);
    _prefs.setString('session', sessionString);
  }

  // @override
  // bool updateShouldNotify(InheritedWidget oldWidget) => true;

  // static LoginBloc of(BuildContext context) {
  //   return context
  //       .dependOnInheritedWidgetOfExactType<SessionProvider>()
  //       .loginBloc;
  // }
}
