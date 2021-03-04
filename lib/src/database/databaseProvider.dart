import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database _database;
  static final DatabaseProvider db = DatabaseProvider._();

  DatabaseProvider._();
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'bufi.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE User('
          'id_user VARCHAR PRIMARY KEY,'
          'c_u VARCHAR,'
          'c_p VARCHAR,'
          '_n VARCHAR,'
          'u_e VARCHAR,'
          'u_i VARCHAR,'
          'p_c VARCHAR,'
          'p_n VARCHAR,'
          'p_p VARCHAR,'
          'p_m VARCHAR,'
          'p_s VARCHAR,'
          'p_d VARCHAR,'
          'ru VARCHAR,'
          'rn VARCHAR,'
          'tn VARCHAR'
          ')');

      await db.execute('CREATE TABLE Company ('
          'id_company VARCHAR  PRIMARY KEY,'
          'id_user VARCHAR,'
          'id_city VARCHAR,'
          'id_category VARCHAR,'
          'company_name VARCHAR,'
          'company_ruc VARCHAR,'
          'company_image VARCHAR,'
          'company_type VARCHAR,'
          'company_shortcode VARCHAR,'
          'company_delivery_propio VARCHAR,'
          'company_delivery VARCHAR,'
          'company_entrega VARCHAR,'
          'company_tarjeta VARCHAR,'
          'company_verified VARCHAR,'
          'company_rating VARCHAR,'
          'company_created_at VARCHAR,'
          'company_join VARCHAR,'
          'company_status VARCHAR,'
          'company_mt VARCHAR,'
          'mi_negocio VARCHAR'
          ')');

      await db.execute('CREATE TABLE Subsidiary ('
          'id_subsidiary VARCHAR PRIMARY KEY,'
          'id_company VARCHAR,'
          'subsidiary_name VARCHAR,'
          'subsidiary_address VARCHAR,'
          'subsidiary_cellphone VARCHAR,'
          'subsidiary_cellphone_2 VARCHAR,'
          'subsidiary_email VARCHAR,'
          'subsidiary_coord_x VARCHAR,'
          'subsidiary_coord_y VARCHAR,'
          'subsidiary_opening_hours VARCHAR,'
          'subsidiary_principal VARCHAR,'
          'subsidiary_status VARCHAR,'
          'subsidiary_favourite VARCHAR'
          ')');
    });
  }
}
