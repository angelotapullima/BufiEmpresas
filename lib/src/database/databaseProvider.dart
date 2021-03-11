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

    final path = join(documentsDirectory.path, 'bufi2.db');
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
          'subsidiary_favourite VARCHAR,'
          'subsidiary_status_pedidos VARCHAR'
          ')');

      await db.execute(' CREATE TABLE Pedidos('
          ' id_pedido TEXT PRIMARY KEY,'
          ' id_user TEXT,'
          ' id_city TEXT,'
          ' id_subsidiary TEXT,'
          ' id_company TEXT,'
          ' delivery_number TEXT,'
          ' delivery_name TEXT,'
          ' delivery_email TEXT,'
          ' delivery_cel TEXT,'
          ' delivery_address TEXT,'
          ' delivery_description TEXT,'
          ' delivery_coord_x TEXT,'
          ' delivery_coord_y TEXT,'
          ' delivery_add_info TEXT,'
          ' delivery_price TEXT,'
          ' delivery_total_orden TEXT,'
          ' delivery_payment TEXT,'
          ' delivery_entrega TEXT,'
          ' delivery_datetime TEXT,'
          ' delivery_status TEXT,'
          ' delivery_mt TEXT'
          ')');

      await db.execute('CREATE TABLE Producto ('
          'id_producto VARCHAR  PRIMARY KEY,'
          'id_subsidiary VARCHAR,'
          'id_good VARCHAR,'
          'id_itemsubcategory VARCHAR,'
          'producto_name VARCHAR,'
          'producto_price VARCHAR,'
          'producto_currency VARCHAR,'
          'producto_image VARCHAR,'
          'producto_characteristics VARCHAR,'
          'producto_brand VARCHAR,'
          'producto_model VARCHAR,'
          'producto_type VARCHAR,'
          'producto_size VARCHAR,'
          'producto_stock VARCHAR,'
          'producto_measure VARCHAR,'
          'producto_rating VARCHAR,'
          'producto_updated VARCHAR,'
          'producto_status VARCHAR,'
          'producto_favourite VARCHAR'
          ')');

      await db.execute('CREATE TABLE Good ('
          'id_good VARCHAR  PRIMARY KEY,'
          'good_name VARCHAR,'
          'good_synonyms VARCHAR'
          ')');

      await db.execute(' CREATE TABLE DetallePedido('
          ' id_detalle_pedido TEXT PRIMARY KEY,'
          ' id_pedido TEXT,'
          ' id_producto TEXT,'
          ' cantidad TEXT,'
          ' delivery_detail_subtotal TEXT'
          ')');

      await db.execute('CREATE TABLE EstadoPedido ('
          'id_tipo_estado TEXT PRIMARY KEY,'
          'tipo_estado_nombre TEXT,'
          'tipo_estado_select TEXT'
          ')');

      await db.execute('CREATE TABLE Pagos ('
          'id_transferencia_u_e TEXT PRIMARY KEY,'
          'id_subsidiary TEXT,'
          'transferencia_u_e_nro_operacion TEXT,'
          'id_usuario TEXT,'
          'id_empresa TEXT,'
          'id_pago TEXT,'
          'transferencia_u_e_monto TEXT,'
          'transferencia_u_e_concepto TEXT,'
          'transferencia_u_e_date TEXT,'
          'transferencia_u_e_estado TEXT'
          ')');
    });
  }
}
