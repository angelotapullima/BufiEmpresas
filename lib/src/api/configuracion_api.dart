import 'dart:convert';
import 'package:bufi_empresas/src/database/tipoEstadoPedido_db.dart';
import 'package:bufi_empresas/src/models/tipoEstadoPedidoModel.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class ConfiguracionApi {
  final tiposEstadoPedidoDatabase = TiposEstadoPedidosDatabase();

  Future<bool> obtenerConfiguracion() async {
    try {
      final url = '$apiBaseURL/api/Inicio/configuracion';

      final resp = await http.post(url);

      final decodedData = json.decode(resp.body);

      if (decodedData['estados'].length > 0) {
        for (var i = 0; i < decodedData['estados'].length; i++) {
          TipoEstadoPedidoModel tipoEstadoPedido = TipoEstadoPedidoModel();

          if (decodedData['estados'][i.toString()] == null) {
            tipoEstadoPedido.idTipoEstado = "99";
            tipoEstadoPedido.tipoEstadoNombre = "TODOS";
          } else {
            tipoEstadoPedido.idTipoEstado = i.toString();
            tipoEstadoPedido.tipoEstadoNombre =
                decodedData['estados'][i.toString()];
          }

          final list = await tiposEstadoPedidoDatabase
              .obtenerTiposEstadoPedidoXid(tipoEstadoPedido.idTipoEstado);
          if (list.length > 0) {
            tipoEstadoPedido.tipoEstadoSelect = list[0].tipoEstadoSelect;
          } else {
            tipoEstadoPedido.tipoEstadoSelect = "0";
          }

          await tiposEstadoPedidoDatabase
              .insertarTiposEstadoPedidos(tipoEstadoPedido);
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
