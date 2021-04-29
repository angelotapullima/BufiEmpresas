import 'package:bufi_empresas/src/models/tipoEstadoPedidoModel.dart';

import 'databaseProvider.dart';

class TiposEstadoPedidosDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarTiposEstadoPedidos(TipoEstadoPedidoModel tiposEstadoModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO EstadoPedido (id_tipo_estado, tipo_estado_nombre, tipo_estado_select) "
          "VALUES('${tiposEstadoModel.idTipoEstado}','${tiposEstadoModel.tipoEstadoNombre}','${tiposEstadoModel.tipoEstadoSelect}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos de Sugerencia");
      print(e);
    }
  }

  Future<List<TipoEstadoPedidoModel>> obtenerTiposEstadoPedido() async {
    final db = await dbProvider.database;
    final res = await db
        .rawQuery("SELECT * FROM EstadoPedido order by tipo_estado_select");

    List<TipoEstadoPedidoModel> list = res.isNotEmpty
        ? res.map((c) => TipoEstadoPedidoModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<TipoEstadoPedidoModel>> obtenerTiposEstadoPedido2(
      String id) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery(
        "SELECT * FROM EstadoPedido WHERE id_tipo_estado>'$id' AND id_tipo_estado<'99'");

    List<TipoEstadoPedidoModel> list = res.isNotEmpty
        ? res.map((c) => TipoEstadoPedidoModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<TipoEstadoPedidoModel>> obtenerTiposEstadoPedido1(
      String id) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery(
        "SELECT * FROM EstadoPedido WHERE id_tipo_estado<'99' AND  id_tipo_estado!='$id'");

    List<TipoEstadoPedidoModel> list = res.isNotEmpty
        ? res.map((c) => TipoEstadoPedidoModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<TipoEstadoPedidoModel>> obtenerTiposEstadoPedidoXid(
      String idTipoEstado) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery(
        "SELECT * FROM EstadoPedido where id_tipo_estado = '$idTipoEstado'");

    List<TipoEstadoPedidoModel> list = res.isNotEmpty
        ? res.map((c) => TipoEstadoPedidoModel.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<TipoEstadoPedidoModel>>
      obtenerTiposEstadoPedidoSeleccionado() async {
    final db = await dbProvider.database;
    final res = await db
        .rawQuery("SELECT * FROM EstadoPedido WHERE tipo_estado_select = '1'");

    List<TipoEstadoPedidoModel> list = res.isNotEmpty
        ? res.map((c) => TipoEstadoPedidoModel.fromJson(c)).toList()
        : [];
    return list;
  }

  desSeleccionarTiposEstadosPedido() async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate(
          "UPDATE EstadoPedido SET tipo_estado_select='0' WHERE tipo_estado_select='1'");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  updateSeleccionarTipoEstadoPedido(String idTipoEstado) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawUpdate("UPDATE EstadoPedido SET "
          "tipo_estado_select='1' "
          "WHERE id_tipo_estado = '$idTipoEstado'");
      return res;
    } catch (exception) {
      print(exception);
    }
  }
}
