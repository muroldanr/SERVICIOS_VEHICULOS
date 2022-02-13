import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:best_flutter_ui_templates/src/config_app/login_page.dart';
import 'package:best_flutter_ui_templates/src/config_app/main_config.dart';
import 'package:best_flutter_ui_templates/src/providers/push_notification_provider.dart';
import 'package:best_flutter_ui_templates/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = new SessionProvider();
  await session.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // final pushProvider = new PushNotificationsProvider();
    // pushProvider.initNotifications();
  }

  final SessionProvider prov = new SessionProvider();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.grey[900],
      statusBarIconBrightness: Brightness.light,
      //statusBarBrightness: Brightness.dark,
      //systemNavigationBarDividerColor: Colors.pink,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    Color _primaryColor = Colors.green;
    String _initial = (prov.validaToken()) ? 'home' : 'login';
    //String _initial = (false) ? 'home' : 'login';

    return MaterialApp(
      title: 'MAS ERP',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        // AppLocalizations.delegate, // remove the comment for this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,

        // ...
      ],
      supportedLocales: [const Locale('es', 'ES')],
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        primarySwatch: Colors.green,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
        primaryColor: _primaryColor,
        backgroundColor: Colors.white,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: _primaryColor,
          selectionColor: _primaryColor,
          selectionHandleColor: _primaryColor,
        ),
      ),
      home: LoginPage(),
      initialRoute: _initial,
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginPage());
      },
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
