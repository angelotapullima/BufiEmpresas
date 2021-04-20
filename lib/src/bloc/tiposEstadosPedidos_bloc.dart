import 'package:bufi_empresas/src/api/configuracion_api.dart';
import 'package:bufi_empresas/src/database/tipoEstadoPedido_db.dart';
import 'package:bufi_empresas/src/models/tipoEstadoPedidoModel.dart';
import 'package:rxdart/rxdart.dart';

class TiposEstadosPedidosBloc {
  final configApi = ConfiguracionApi();
  final tiposEstadosPedidosDatabase = TiposEstadoPedidosDatabase();
  final _tiposEstadosPedidosController =
      BehaviorSubject<List<TipoEstadoPedidoModel>>();
  final _tiposEstadosPedidosController2 =
      BehaviorSubject<List<TipoEstadoPedidoModel>>();
  final _tiposEstadoPedidoIdController =
      BehaviorSubject<List<TipoEstadoPedidoModel>>();

  Stream<List<TipoEstadoPedidoModel>> get tiposEstadosPedidosStream =>
      _tiposEstadosPedidosController.stream;
  Stream<List<TipoEstadoPedidoModel>> get tiposEstadosPedidosStream2 =>
      _tiposEstadosPedidosController2.stream;
  Stream<List<TipoEstadoPedidoModel>> get tipoEstadoPedidoIdStream =>
      _tiposEstadoPedidoIdController.stream;

  void dispose() {
    _tiposEstadosPedidosController?.close();
    _tiposEstadosPedidosController2?.close();
    _tiposEstadoPedidoIdController?.close();
  }

  void obtenerTiposEstadosPedidos() async {
    _tiposEstadosPedidosController.sink
        .add(await tiposEstadosPedidosDatabase.obtenerTiposEstadoPedido());
  }

  void obtenerTiposEstadosPedidos2(String id) async {
    _tiposEstadosPedidosController2.sink
        .add(await tiposEstadosPedidosDatabase.obtenerTiposEstadoPedido2(id));
  }

  void obtenerTiposEstadosPedidosXid(String idEstado) async {
    _tiposEstadoPedidoIdController.sink.add(await tiposEstadosPedidosDatabase
        .obtenerTiposEstadoPedidoXid(idEstado));
  }
}
