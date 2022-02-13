import 'dart:async';

import 'package:best_flutter_ui_templates/http/http_provider.dart';
import 'package:best_flutter_ui_templates/src/models/equipo_transporte_model.dart';
import 'package:best_flutter_ui_templates/src/models/llanta_detalle_lista_model.dart';
import 'package:best_flutter_ui_templates/src/models/response_model.dart';
import 'package:best_flutter_ui_templates/src/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListaLlantasDetallePage extends StatefulWidget {
  final EquipoTransporte? vehiculo;
  ListaLlantasDetallePage(this.vehiculo);

  @override
  _ListaLlantasDetallePageState createState() =>
      _ListaLlantasDetallePageState(vehiculo);
}

class _ListaLlantasDetallePageState extends State<ListaLlantasDetallePage> {
  EquipoTransporte? vehiculo;
  String? _kilometraje;
  String? _profundidaText;

  final httpProv = new HttpProvider();
  TextEditingController _textProfundidadController = TextEditingController();
  TextEditingController _textKilometrajeController = TextEditingController();
  _ListaLlantasDetallePageState(this.vehiculo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBarCustom("Medir Llantas"),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            _cardKilometraje(),
            Flexible(
                child: Container(
              height: 650.0,
              child: _getlistaServicios(),
            ))
          ],
        ),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _cardKilometraje() {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            height: 80.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 5.0,
                  ),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_getRenglonMotivo(_kilometraje)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRenglonMotivo(value1) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, right: 5.0, left: 5.0, bottom: 5.0),
                  child: TextField(
                    //autofocus: true,
                    onChanged: (valor) => setState(() {
                      _kilometraje = valor.toString();
                    }),
                    controller: _textKilometrajeController,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny('\.'),
                      LengthLimitingTextInputFormatter(8)
                    ],

                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Kilometraje",
                      labelText: "Kilometraje",
                      focusColor: Colors.green,
                      hoverColor: Colors.green,
                      fillColor: Colors.green,
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getlistaServicios() {
    print("AQUI SI ENTRO : " + vehiculo!.id.toString());
    final httpProv = new HttpProvider();

    return FutureBuilder(
        future: httpProv.spWebLlantaVehiculoLista(vehiculo!.id.toString()),
        builder: (BuildContext context,
            AsyncSnapshot<List<LlantaDetalleLista>?> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.error.toString());
            return ListView(
              shrinkWrap: true,
              children: _listaServicios(snapshot.data!, context),
            );
          } else {
            print(snapshot.error.toString());
            return Container(
                height: 400.0,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  List<Widget> _listaServicios(
      List<LlantaDetalleLista> items, BuildContext context) {
    final List<Widget> servicios = [];

    if (items.length <= 0) {
      return [];
    }

    items.forEach((item) {
      final widgetTemp = Card(
        child: ListTile(
          leading: Image.asset('assets/tire.png'),
          title: Text(
            "Posición: " + item.posicion.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          subtitle: Text(
            "Profundidad: " + item.profundidad.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          trailing: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (_textKilometrajeController.text != "") {
                _displayTextInputDialog(context, item);
              } else {
                _openSnackBarWithoutAction(
                    context, "El Kilometraje es necesario");
              }
            },
            child: Icon(Icons.edit),
          ),
          isThreeLine: false,
        ),
      );

      servicios..add(widgetTemp);
    });

    return servicios;
  }

  Widget _getRow(String text, double porcent) {
    return Container(
      width: MediaQuery.of(context).size.width * porcent,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _getDateFormat(DateTime fecha) {
    try {
      var dia = fecha.day.toString();
      var mes = fecha.month.toString();
      var ano = fecha.year.toString();

      return dia + " / " + mes + " / " + ano;
    } catch (e) {
      return "";
    }
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, LlantaDetalleLista item) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Posición: " + item.posicion!),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  _profundidaText = value;
                });
              },
              controller: _textProfundidadController,
              inputFormatters: [LengthLimitingTextInputFormatter(5)],
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                signed: false,
              ),
              cursorColor: Colors.green,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "00.00",
                labelText: "Profundidad Max. 21.00",
                focusColor: Colors.green,
                hoverColor: Colors.green,
                fillColor: Colors.green,
              ),
            ),
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
                child: Text('Guardar'),
                onPressed: () {
                  _setProfundidad(item, context);
                },
              ),
            ],
          );
        });
  }

  _setProfundidad(LlantaDetalleLista item, BuildContext context) async {
    print("Profundidad: " + _textProfundidadController.text);
    double profundidad = double.parse(_textProfundidadController.text);
    print("Profundidad Parseada: " + profundidad.toString());
    if (profundidad <= 21.0) {
      print("Unidad: " + vehiculo!.id.toString());
      print("Asignacion: " '${int.parse(item.posicion!)}');
      print("Comentario: " + "");
      print("Kilometros: " + _textKilometrajeController.text);
      print("Profundidad: " + _textProfundidadController.text);
      final List<Response> lista = await (httpProv.spWebLecturaLlanta(
          vehiculo!.id.toString(),
          int.parse(item.posicion!),
          "",
          int.parse(_textKilometrajeController.text),
          _textProfundidadController.text) as FutureOr<List<Response>>);

      if (lista.length <= 0) {
      } else {
        if (lista[0].ok == null || lista[0].ok == "null") {
          setState(() {
            _profundidaText = "";
            _textProfundidadController.text = "";
          });
          Navigator.of(context, rootNavigator: true).pop('dialog');
        } else {
          //  _openSnackBarWithoutAction(context ,lista[0].okRef) ;
        }
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    }
  }

  _openSnackBarWithoutAction(BuildContext context, String title) {
    final snackBar = SnackBar(
      content: Text(title),
      duration: Duration(seconds: 3),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
