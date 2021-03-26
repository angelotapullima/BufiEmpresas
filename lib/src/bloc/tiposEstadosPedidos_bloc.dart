import 'package:bufi_empresas/src/database/tipoEstadoPedido_db.dart';
import 'package:bufi_empresas/src/models/tipoEstadoPedidoModel.dart';
import 'package:rxdart/rxdart.dart';

class TiposEstadosPedidosBloc {
  final tiposEstadosPedidosDatabase = TiposEstadoPedidosDatabase();
  final _tiposEstadosPedidosController =
      BehaviorSubject<List<TipoEstadoPedidoModel>>();
  final _tiposEstadoPedidoIdController =
      BehaviorSubject<List<TipoEstadoPedidoModel>>();

  Stream<List<TipoEstadoPedidoModel>> get tiposEstadosPedidosStream =>
      _tiposEstadosPedidosController.stream;
  Stream<List<TipoEstadoPedidoModel>> get tipoEstadoPedidoIdStream =>
      _tiposEstadoPedidoIdController.stream;

  void dispose() {
    _tiposEstadosPedidosController?.close();
    _tiposEstadoPedidoIdController?.close();
  }

  void obtenerTiposEstadosPedidos() async {
    _tiposEstadosPedidosController.sink
        .add(await tiposEstadosPedidosDatabase.obtenerTiposEstadoPedido());
  }

  void obtenerTiposEstadosPedidosXid(String idEstado) async {
    _tiposEstadoPedidoIdController.sink.add(await tiposEstadosPedidosDatabase
        .obtenerTiposEstadoPedidoXid(idEstado));
  }
}
