import 'package:bufi_empresas/src/database/databaseProvider.dart';
import 'package:bufi_empresas/src/models/goodModel.dart';

class GoodDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarGood(BienesModel bienesModel) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Good (id_good,good_name,good_synonyms) "
          "VALUES('${bienesModel.idGood}', '${bienesModel.goodName}', '${bienesModel.goodSynonyms}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos");
    }
  }

  deleteGood() async {
    final db = await dbProvider.database;

    final res = await db.rawDelete('DELETE FROM Good');

    return res;
  }

  Future<List<BienesModel>> obtenerGood() async {
    final db = await dbProvider.database;
    final res = await db.rawQuery("SELECT * FROM Good ORDER BY good_name");

    List<BienesModel> list =
        res.isNotEmpty ? res.map((c) => BienesModel.fromJson(c)).toList() : [];
    return list;
  }
}
