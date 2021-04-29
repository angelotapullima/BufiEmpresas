import 'dart:async';

import 'package:rxdart/rxdart.dart';

class EditarSubsidiaryBloc {
  final _cargandoController = new BehaviorSubject<bool>();

  Stream<bool> get cargandoStream => _cargandoController.stream;

  Function(bool) get changeCargando => _cargandoController.sink.add;
  dispose() {
    _cargandoController?.close();
  }

  // Future<int> restablecerPassword(String pass) async {
  //   _cargandoController.sink.add(true);
  //   final resp = await restablecerPasswdApi.send(pass);
  //   _cargandoController.sink.add(false);
  //   return resp;
  // }
}
