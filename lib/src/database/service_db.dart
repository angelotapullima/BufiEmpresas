import 'package:bufi_empresas/src/database/databaseProvider.dart';
import 'package:bufi_empresas/src/models/serviceModel.dart';

class ServiceDatabase {
  final dbProvider = DatabaseProvider.db;

  insertarService(ServiciosModel serviciosModel) async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Service (id_service,service_name,service_synonyms) "
          "VALUES('${serviciosModel.idService}', '${serviciosModel.serviceName}', '${serviciosModel.serviceSynonyms}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos");
    }
  }

  Future<List<ServiciosModel>> obtenerService() async {
    try {
      final db = await dbProvider.database;
      final res = await db.rawQuery("SELECT * FROM Service");

      List<ServiciosModel> list = res.isNotEmpty
          ? res.map((c) => ServiciosModel.fromJson(c)).toList()
          : [];
      return list;
    } catch (e) {
      print(" $e Error en la base de datossss");
      return [];
    }
  }
}
