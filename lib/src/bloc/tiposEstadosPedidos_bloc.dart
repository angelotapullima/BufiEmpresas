import 'package:bufi_empresas/src/database/tipoEstadoPedido_db.dart';
import 'package:bufi_empresas/src/models/tipoEstadoPedidoModel.dart';
import 'package:rxdart/rxdart.dart';

class TiposEstadosPedidosBloc {
  final tiposEstadosPedidosDatabase = TiposEstadoPedidosDatabase();
  final _tiposEstadosPedidosController =
      BehaviorSubject<List<TipoEstadoPedidoModel>>();

  Stream<List<TipoEstadoPedidoModel>> get tiposEstadosPedidosStream =>
      _tiposEstadosPedidosController.stream;

  void dispose() {
    _tiposEstadosPedidosController?.close();
  }

  void obtenerTiposEstadosPedidos() async {
    _tiposEstadosPedidosController.sink
        .add(await tiposEstadosPedidosDatabase.obtenerTiposEstadoPedido());
  }
}
