import 'package:best_flutter_ui_templates/fitness_app/models/login_model.dart';
import 'package:best_flutter_ui_templates/fitness_app/utils/DAWidgets.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Para agilizar snackbar y loading
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late LoginRequestModel requestModel;
  bool _saving = false; // Para estatus loading
  String username = "";
  String password = "";

  // Form controllers
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // API
  void onValueChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    requestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return DaScaffoldLoading(
      isLoading: _saving,
      keyLoading: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      children: <Widget>[
        SizedBox(
          height: 25,
        ),
        Text('LOGIN'),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
