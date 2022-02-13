import 'dart:async';

class InputValidators {
  final validaUri =
      StreamTransformer<String, String>.fromHandlers(handleData: (uri, sink) {
    Pattern pattern = r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+';
    RegExp regExp = new RegExp(pattern as String);
    if (regExp.hasMatch(uri)) {
      sink.add(uri);
    } else {
      sink.addError('url inválida');
    }
  });

  final validaEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern as String);
    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Email incorrecto');
    }
  });

  final validaPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError('Requiere mas de 6 caracteres');
    }
  });
}
