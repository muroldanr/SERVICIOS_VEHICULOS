import 'package:intl/intl.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;
  final n = num.tryParse(s);
  return (n == null) ? false : true;
}

String generarFechaVista(String dia, String mes, String ano) {
  String fechaFormatoVista = dia + "/" + mes + "/" + ano;
  return fechaFormatoVista;
}

String generarFechaRequest(String dia, String mes, String ano) {
  String fechaFormatoRequest = mes + "/" + dia + "/" + ano;
  return fechaFormatoRequest;
}

String generarFechaRequestProceso(DateTime amount) {
    var formatDate = DateFormat('yyyyMMdd HH:mm');
   String date = formatDate.format(amount);
    return date;
}



String generarFechaSQL(DateTime amount) {
  var formatDate = DateFormat('yyyyMMdd');
  String date = formatDate.format(amount);
  return date;
}

String generarHoraSQL(DateTime amount) {
  var formatDate = DateFormat('HH:mm');
  String date = formatDate.format(amount);
  return date;
}


String generarFecha(DateTime amount) {
  var formatDate = DateFormat('dd/MM/yyyy');
  String date = formatDate.format(amount);
  return date;
}

String generarFechaVistaNew(DateTime amount) {
  var formatDate = DateFormat('dd/MM/yyyy');
  String date = formatDate.format(amount);
  return date;
}




