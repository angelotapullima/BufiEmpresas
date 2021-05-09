import 'package:rxdart/rxdart.dart';

class EditarNegocioBloc {
  final _cargandoEditNegocioController = new BehaviorSubject<bool>();
  Stream<bool> get cargandoEditNegocioStream =>
      _cargandoEditNegocioController.stream;

  Function(bool) get changeCargandoEditNegocio =>
      _cargandoEditNegocioController.sink.add;
  dispose() {
    _cargandoEditNegocioController?.close();
  }
}
