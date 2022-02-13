class DataTipoOrdenModel {
  String? tipoOperacion;

  DataTipoOrdenModel({this.tipoOperacion});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'TipoOperacion': tipoOperacion,
    };

    return map;
  }
}

class TipoOrdenes {
  List<TipoOrden> items = [];

  TipoOrdenes();

  TipoOrdenes.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      final responseDataFallasModel = new TipoOrden.fromJsonMap(item);
      items.add(responseDataFallasModel);
    }
  }
}

class TipoOrden {
  String? tipoOperacion;

  TipoOrden({
    this.tipoOperacion,
  });

  TipoOrden.fromJsonMap(Map<String, dynamic> json) {
    tipoOperacion = json['TipoOperacion'];
  }
}
