import 'package:best_flutter_ui_templates/src/config_app/apiconfig_page.dart';
import 'package:best_flutter_ui_templates/src/config_app/login_page.dart';
import 'package:best_flutter_ui_templates/src/config_app/menu_page.dart';
import 'package:best_flutter_ui_templates/src/models/solicitud_pendiente_model.dart';
import 'package:best_flutter_ui_templates/src/pages/detalle_servicio_page.dart';
import 'package:best_flutter_ui_templates/src/pages/home_page.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    //'/'     : (BuildContext context) => HomePage(),
    'login': (BuildContext context) => LoginPage(),
    'apiconfig': (BuildContext context) => ApiconfigPage(),
    'home': (BuildContext context) => HomePage(),
    'menu': (BuildContext context) => MenuPage(),
    //'detalle': (BuildContext context) => DetalleServicioPage(solicitud),
  };
}
