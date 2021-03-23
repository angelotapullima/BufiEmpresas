import 'package:bufi_empresas/src/database/databaseProvider.dart';
import 'package:bufi_empresas/src/models/tallaProductoModel.dart';

class TallaProductoDatabase {
  final dbprovider = DatabaseProvider.db;

  insertarTallaProducto(TallaProductoModel tallaProductoModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO TallasProducto (id_talla_producto,id_producto,"
          "talla_producto,talla_status_producto,estado) "
          "VALUES ('${tallaProductoModel.idTallaProducto}','${tallaProductoModel.idProducto}',"
          "'${tallaProductoModel.tallaProducto}','${tallaProductoModel.tallaProductoStatus}',"
          "'${tallaProductoModel.estado}')");

      return res;
    } catch (exception) {
      print(exception);
      print("Error en la tabla Talla de Productos");
    }
  }

  updateEstadoa0() async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate('UPDATE TallasProducto SET estado="0"');

      return res;
    } catch (exception) {
      print(exception);
      print("Error en la tabla Marca de Productos");
    }
  }

  updateEstadoa1(TallaProductoModel tallaProductoModel) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate(
          'UPDATE TallasProducto SET estado="1" where id_talla_producto="${tallaProductoModel.idTallaProducto}" and id_producto="${tallaProductoModel.idProducto}"');

      return res;
    } catch (exception) {
      print(exception);
      print("Error en la tabla Talla de Productos");
    }
  }

  Future<List<TallaProductoModel>> obtenerTallaProducto() async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery("SELECT * FROM TallasProducto");

      List<TallaProductoModel> list = res.isNotEmpty
          ? res.map((c) => TallaProductoModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
      return [];
    }
  }

  Future<List<TallaProductoModel>> obtenerTallaProductoPorIdProducto(
      String idProducto) async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery(
          "SELECT * FROM TallasProducto where id_producto='$idProducto' order by id_producto");

      List<TallaProductoModel> list = res.isNotEmpty
          ? res.map((c) => TallaProductoModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
      return [];
    }
  }

  Future<List<TallaProductoModel>> obtenerTallaProductoPorEstado0() async {
    try {
      final db = await dbprovider.database;
      final res =
          await db.rawQuery("SELECT * FROM TallasProducto where estado=0");

      List<TallaProductoModel> list = res.isNotEmpty
          ? res.map((c) => TallaProductoModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      print(e);
      return [];
    }
  }

  Future<List<TallaProductoModel>> obtenerTallaProductoPorIdProductoEnEstado1(
      String idProducto) async {
    try {
      final db = await dbprovider.database;
      final res = await db.rawQuery(
          "SELECT * FROM TallasProducto where id_producto = '$idProducto' and estado='1'");

      List<TallaProductoModel> list = res.isNotEmpty
          ? res.map((c) => TallaProductoModel.fromJson(c)).toList()
          : [];

      return list;
    } catch (exception) {
      print(exception);
      print("Error en la tabla Talla de Productos");
      return [];
    }
  }
}
