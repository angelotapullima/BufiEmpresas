import 'dart:convert';

import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class NegocioApi {
  final prefs = Preferences();

  Future updateNegocio(CompanySubsidiaryModel csmodel) async {
    try {
      final res =
          await http.post("$apiBaseURL/api/Negocio/update_negocio", body: {
        'id_company': '${csmodel.idCompany}',
        'empresa_nombre': '${csmodel.companyName}',
        'empresa_type': '${csmodel.companyType}',
        "id_category": '${csmodel.idCategory}',
        "empresa_cel": '${csmodel.subsidiaryCellphone}',
        "empresa_ruc": '${csmodel.companyRuc}',
        "calle_x": '${csmodel.subsidiaryCoordX}',
        "calle_y": '${csmodel.subsidiaryCoordY}',
        "actual_opening_hours": '${csmodel.subsidiaryOpeningHours}',
        'empresa_cel2': '${csmodel.subsidiaryCellphone2}',
        'empresa_direccion': '${csmodel.subsidiaryAddress}',
        'shortcode': '${csmodel.companyShortcode}',
        'delivery': '${csmodel.companyDelivery}',
        "entrega": '${csmodel.companyShortcode}',
        "tarjeta": '${csmodel.companyTarjeta}',
        "app": 'true',
        "tn": prefs.token,
      });
      final code = json.decode(res.body);
      //final int code = decodesData;
      if (code == 1) {
        return 1;
      } else if (code == 2) {
        return 2;
      } else {
        return code;
      }
      // return code;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }
}
