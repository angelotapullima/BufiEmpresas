import 'dart:async';

import 'package:bufi_empresas/src/api/restablecerPassword_api.dart';
import 'package:rxdart/rxdart.dart';

class RestablecerPasswordBloc with Validators {
  final restablecerPasswdApi = RestablecerPasswordApi();
  final _passwordController = BehaviorSubject<String>();
  final _passwordConfirmController = BehaviorSubject<String>();
  final _cargandoController = new BehaviorSubject<bool>();

  //Recuperaer los datos del Stream
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);
  Stream<String> get passwordConfirmStream => _passwordConfirmController.stream
          .transform(StreamTransformer<String, String>.fromHandlers(
              handleData: (password, sink) {
        if (password == _passwordController.value) {
          sink.add(password);
        } else {
          sink.addError('Contraseña no coincide');
        }
      }));
  Stream<bool> get cargando => _cargandoController.stream;

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(passwordStream, passwordConfirmStream, (p, c) => true);

  //inserta valores al Stream
  Function(String) get changePasswordConfirm =>
      _passwordConfirmController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(bool) get changeCargando => _cargandoController.sink.add;

  //obtener el ultimo valor ingresado a los stream
  String get passwordConfirm => _passwordConfirmController.value;
  String get password => _passwordController.value;

  dispose() {
    _passwordConfirmController?.close();
    _passwordController?.close();
    _cargandoController?.close();
  }

  Future<int> restablecerPassword(String pass) async {
    _cargandoController.sink.add(true);
    final resp = await restablecerPasswdApi.send(pass);
    _cargandoController.sink.add(false);
    return resp;
  }
}

class Validators {
  String contra;

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 0) {
      sink.add(password);
    } else {
      sink.addError('Este campo no debe estar vacío');
    }
  });
}
