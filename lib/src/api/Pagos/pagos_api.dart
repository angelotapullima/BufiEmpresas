import 'dart:convert';
import 'package:bufi_empresas/src/database/pagos_db.dart';
import 'package:bufi_empresas/src/models/PagosModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PagosApi {
  final pagosDataBase = PagosDataBase();
  final prefs = new Preferences();

  Future<bool> obtenerPagosXIdSubsidiary(
      String idSubsidiary, String fechaIni, String fechaFin) async {
    try {
      final url = '$apiBaseURL/api/Cuentaempresa/pagos_por_subsidiary';

      final resp = await http.post(url, body: {
        'id_subsidiary': '$idSubsidiary',
        'fecha_i': '$fechaIni',
        'fecha_f': '$fechaFin',
        'tn': prefs.token,
        'app': 'true'
      });

      final decodedData = json.decode(resp.body);

      if (decodedData['result'].length > 0) {
        for (var i = 0; i < decodedData['result'].length; i++) {
          PagosModel pagoModel = PagosModel();
          pagoModel.idTransferenciaUE =
              decodedData['result'][i]['id_transferencia_u_e'];
          pagoModel.idSubsidiary = decodedData['result'][i]['id_subsidiary'];
          pagoModel.transferenciaUENroOperacion =
              decodedData['result'][i]['transferencia_u_e_nro_operacion'];
          pagoModel.idUsuario = decodedData['result'][i]['id_usuario'];
          pagoModel.idEmpresa = decodedData['result'][i]['id_empresa'];
          pagoModel.idPago = decodedData['result'][i]['id_pago'];
          pagoModel.transferenciaUEMonto =
              decodedData['result'][i]['transferencia_u_e_monto'];
          pagoModel.transferecniaUEConcepto =
              decodedData['result'][i]['transferencia_u_e_concepto'];
          var algo = decodedData['result'][i]['transferencia_u_e_date'];
          algo = algo.split(' ');
          var fecha = algo[0].trim();
          pagoModel.transferenciaUEDate = fecha;
          pagoModel.transferenciaUEEstado =
              decodedData['result'][i]['transferencia_u_e_estado'];
          pagoModel.idDelivery = decodedData['result'][i]['id_delivery'];
          pagoModel.pagoTipo = decodedData['result'][i]['pago_tipo'];
          pagoModel.pagoMonto = decodedData['result'][i]['pago_monto'];
          pagoModel.pagoComision = decodedData['result'][i]['pago_comision'];
          pagoModel.pagoTotal = decodedData['result'][i]['pago_total'];
          pagoModel.pagoDate = decodedData['result'][i]['pago_date'];
          pagoModel.pagoEstado = decodedData['result'][i]['pago_estado'];
          pagoModel.pagoMicrotime = decodedData['result'][i]['pago_microtime'];

          await pagosDataBase.insertarPagos(pagoModel);
        }
        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return false;
    }
  }
}
