import 'package:best_flutter_ui_templates/src/models/equipo_transporte_model.dart';
import 'package:best_flutter_ui_templates/src/models/llanta_plantilla_model.dart';
import 'package:best_flutter_ui_templates/src/pages/asignar_llanta_page.dart';
import 'package:best_flutter_ui_templates/src/pages/llanta_detalle_page.dart';
import 'package:flutter/material.dart';

class ListaLlantasPage extends StatelessWidget {
  final List<LlantaPlantilla>? llantaPlantilla;
  final String tipoList;
  final ScrollController scrollController;
  final BuildContext context;
  final EquipoTransporte? vehiculo;

  ListaLlantasPage(this.llantaPlantilla, this.tipoList, this.scrollController,
      this.context, this.vehiculo);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _getTipoVehiculo(vehiculo!.articulo.toString()),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        padding: EdgeInsets.only(top: 70),
        shrinkWrap: true,
        controller: scrollController,
        children: _listaLlantas(this.llantaPlantilla!, context),
      ),
    );
  }

  List<Widget> _listaLlantas(
      List<LlantaPlantilla> items, BuildContext context) {
    final List<Widget> llantas = [];

    if (items.length <= 0) {
      return [];
    }

    llantaPlantilla!.forEach((item) {
      final widgetTemp = Stack(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(children: <Widget>[
                  item.eje.toString() == "2"
                      ? SizedBox(height: 100)
                      : SizedBox(height: 0),
                  _llantaModel(item.izqExt.toString()),
                ]),
                Column(children: <Widget>[
                  item.eje.toString() == "2"
                      ? SizedBox(height: 100)
                      : SizedBox(height: 0),
                  _llantaModel(item.izqInt.toString()),
                ]),
                Column(children: <Widget>[
                  item.eje.toString() == "2"
                      ? SizedBox(height: 100)
                      : SizedBox(height: 0),
                  _llantaModelDivider(),
                ]),
                Column(children: <Widget>[
                  item.eje.toString() == "2"
                      ? SizedBox(height: 100)
                      : SizedBox(height: 0),
                  _llantaModel(item.derInt.toString()),
                ]),
                Column(children: <Widget>[
                  item.eje.toString() == "2"
                      ? SizedBox(height: 100)
                      : SizedBox(height: 0),
                  _llantaModel(item.derExt.toString()),
                ]),
              ],
            ),
          ),
        ],
      );
      llantas..add(widgetTemp);
    });

    return llantas;
  }

  Widget _llantaModel(String item) {
    String imagenLlanta = "assets/llanta.png";

    Function nextOption = (_) => AsignarLlantaPage(vehiculo, _getEje(item));
    if (_validarEje(item)) {
      String itemNumber = _getEje(item);
      print("POSICION: " + itemNumber);
      print("UNIDAD: " + vehiculo!.id.toString());

      nextOption = (_) => DetalleLlantaPage(itemNumber, vehiculo!.id.toString());
    }

    //if(item != "null"){
    if (item != "null") {
      return Opacity(
        opacity: _validarEje(item) ? 1.0 : 0.5,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.15,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Container(
              height: 110,
              child: Column(
                children: [
                  Container(
                    height: 60,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: nextOption as Widget Function(BuildContext),
                        ),
                      ),
                      child: Image.asset(
                        imagenLlanta,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Divider(),
                  Text(
                    _getEje(item),
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
          color: Colors.white,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.15,
          height:
              MediaQuery.of(context).size.width * (1 / llantaPlantilla!.length),
          child: Center());
    }
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

  String _getEje(String llanta) {
    var parts = llanta.split('-');
    var prefix = parts[0].trim();
    return prefix;
  }

  Widget _llantaModelDivider() {
    return GestureDetector(
      onTap: () {},
      child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          color: Colors.transparent,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.30,
          height:
              MediaQuery.of(context).size.width * (1 / llantaPlantilla!.length),
          child: Center()),
    );
  }

  /*
  AssetImage _getTipoVehiculo(String articuloTipo) {
    switch (articuloTipo.toString()) {
      case "AUTOMOVIL":
        return AssetImage("assets/vehiculo1.png");
        break;
      case "VOLTEO":
        return AssetImage("assets/volteo.png");
        break;
      case "PIPA":
        return AssetImage("assets/pipa3.png");
        break;
      case "CAJA":
        return AssetImage("assets/caja.png");
        break;
      default:
        return AssetImage("assets/no-image.png");
        break;
    }
  }*/

  AssetImage _getTipoVehiculo(String articuloTipo) {
    print("SOY EL VEHICULO : " + articuloTipo.toString());
    switch (articuloTipo.toString()) {
      case "Automoviles":
        return AssetImage("assets/vehiculo1.png");
        break;
      case "VOLTEO":
        return AssetImage("assets/volteo.png");
        break;
      case "Pipa":
        return AssetImage("assets/pipa3.png");
        break;
      case "Tractocamion":
        return AssetImage("assets/volteo.png");
        break;
      case "Caja Transferencia":
        return AssetImage("assets/caja02.jpeg");
        break;
      default:
        return AssetImage("assets/no-image.png");
        break;
    }
  }
}
