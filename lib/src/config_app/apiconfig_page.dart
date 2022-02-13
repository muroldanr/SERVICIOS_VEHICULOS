import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:best_flutter_ui_templates/src/providers/session_provider.dart';
import 'package:best_flutter_ui_templates/src/utils/DAWidgets.dart';

class ApiconfigPage extends StatefulWidget {
  @override
  _ApiconfigPageState createState() => _ApiconfigPageState();
}

class _ApiconfigPageState extends State<ApiconfigPage> {
  GlobalKey<FormState> _formKeyApi = GlobalKey<FormState>();
  SessionProvider prov = new SessionProvider();

  final String image = 'assets/Man.svg';
  final String titleA = 'Configurar app';

  TextEditingController _apiController = new TextEditingController();
  void onValueChange() {
    setState(() {
      _apiController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiController.text = prov.apiUri!;
    _apiController.addListener(onValueChange);
  }

  @override
  Widget build(BuildContext context) {
    return DaScaffoldLoading(
      appBar: AppBar(), // Para regresar <-
      floatingActionButton: _btnGuardar(),
      children: <Widget>[
        _background(),
        _apiForm(),
      ],
    );
  }

  Widget _btnGuardar() {
    return FloatingActionButton(
      child: Icon(Icons.save),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () => setState(() {
        final form = _formKeyApi.currentState!;
        form.save();
        if (form.validate()) {
          Navigator.pop(context);
        }
      }),
    );
  }

  Widget _background() {
    return DaBackground(
      label: titleA,
      image: SizedBox(child: SvgPicture.asset(image), height: 100.0),
      size: 0.3,
    );
  }

  Widget _apiForm() {
    return DaFloatingForm(
      spacing: 10.0,
      formKey: _formKeyApi,
      title: 'Ingrese Uri API First',
      children: <Widget>[
        DAInput(
          tipo: 'url',
          controller: _apiController,
          onSaved: (value) {
            prov.apiUri = _apiController.text;
          },
        ),
      ],
    );
  }
}
