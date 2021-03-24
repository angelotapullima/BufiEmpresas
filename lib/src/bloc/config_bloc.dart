import 'package:rxdart/rxdart.dart';

class ConfigBloc {
  final _empresaNameController = BehaviorSubject<String>();

  Stream<String> get empresaNameStream => _empresaNameController.stream;

  Function(String) get changeEmpresaName => _empresaNameController.sink.add;

  // Obtener el último valor ingresado a los streams
  String get empresaName => _empresaNameController.value;

  dispose() {
    _empresaNameController?.close();
  }
}
