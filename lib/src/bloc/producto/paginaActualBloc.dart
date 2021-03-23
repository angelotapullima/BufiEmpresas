import 'package:rxdart/rxdart.dart';

class ContadorPaginaProductosBloc { 

  final _selectContadorController = BehaviorSubject<int>();

  Stream<int> get selectContadorStream    => _selectContadorController.stream;

  Function(int) get changeContador    => _selectContadorController.sink.add; 


  // Obtener el último valor ingresado a los streams
  int get pageContador   => _selectContadorController.value; 

  dispose() {
    _selectContadorController?.close(); 
  }
}