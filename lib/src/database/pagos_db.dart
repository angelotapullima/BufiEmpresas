import 'package:bufi_empresas/src/database/databaseProvider.dart';
import 'package:bufi_empresas/src/models/PagosModel.dart';

class PagosDataBase {
  final dbProvider = DatabaseProvider.db;

  insertarPagos(PagosModel pagosModel) async {
    try {
      final db = await dbProvider.database;

      final res = await db.rawInsert(
          "INSERT OR REPLACE INTO Pagos (id_transferencia_u_e, id_subsidiary, transferencia_u_e_nro_operacion, id_usuario, id_empresa, id_pago, transferencia_u_e_monto, transferencia_u_e_concepto, transferencia_u_e_date, transferencia_u_e_estado, id_delivery, pago_tipo, pago_monto, pago_comision, pago_total, pago_date, pago_estado, pago_microtime) "
          "VALUES('${pagosModel.idTransferenciaUE}','${pagosModel.idSubsidiary}','${pagosModel.transferenciaUENroOperacion}','${pagosModel.idUsuario}','${pagosModel.idEmpresa}','${pagosModel.idPago}','${pagosModel.transferenciaUEMonto}','${pagosModel.transferecniaUEConcepto}','${pagosModel.transferenciaUEDate}','${pagosModel.transferenciaUEEstado}','${pagosModel.idDelivery}','${pagosModel.pagoTipo}','${pagosModel.pagoMonto}','${pagosModel.pagoComision}','${pagosModel.pagoTotal}','${pagosModel.pagoDate}','${pagosModel.pagoEstado}','${pagosModel.pagoMicrotime}')");

      return res;
    } catch (e) {
      print("$e Error en la base de datos de Sugerencia");
    }
  }

  Future<List<PagosModel>> obtenerPagosXIdSubsidiaryAndFecha(
      String idSubsidiary, String fechaI, String fechaF) async {
    final db = await dbProvider.database;
    final res = await db.rawQuery(
        "SELECT * FROM Pagos WHERE id_subsidiary='$idSubsidiary' AND (transferencia_u_e_date>='$fechaI' AND transferencia_u_e_date<='$fechaF')");

    List<PagosModel> list =
        res.isNotEmpty ? res.map((c) => PagosModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<PagosModel>> obtenerPagosXIdPago(String idPago) async {
    final db = await dbProvider.database;
    final res =
        await db.rawQuery("SELECT * FROM Pagos WHERE id_pago='$idPago'");

    List<PagosModel> list =
        res.isNotEmpty ? res.map((c) => PagosModel.fromJson(c)).toList() : [];
    return list;
  }
}
