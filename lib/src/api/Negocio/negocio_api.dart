import 'dart:convert';

import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class NegocioApi {
  final prefs = Preferences();
  final companyDatabase = new CompanyDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();

  Future updateNegocio(CompanySubsidiaryModel csmodel) async {
    try {
      final res = await http
          .post(Uri.parse("$apiBaseURL/api/Negocio/update_negocio"), body: {
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
        "entrega": '${csmodel.companyEntrega}',
        "tarjeta": '${csmodel.companyTarjeta}',
        "email": '${csmodel.subsidiaryEmail}',
        "app": 'true',
        "tn": prefs.token,
      });

      final decodedData = json.decode(res.body);

      final int code = decodedData['code'];
      //final int code = decodesData;
      if (code == 1) {
        CompanyModel cmodel = CompanyModel();
        cmodel.idCompany = decodedData['data']['id_company'];
        cmodel.idUser = decodedData['data']['id_user'];
        cmodel.idCity = decodedData['data']['id_city'];
        cmodel.idCategory = decodedData['data']['id_category'];
        cmodel.companyName = decodedData['data']['company_name'];
        cmodel.companyRuc = decodedData['data']['company_ruc'];
        cmodel.companyImage = decodedData['data']['company_image'];
        cmodel.companyType = decodedData['data']['company_type'];
        cmodel.companyShortcode = decodedData['data']['company_shortcode'];
        cmodel.companyDelivery = decodedData['data']['company_delivery'];
        cmodel.companyEntrega = decodedData['data']['company_entrega'];
        cmodel.companyTarjeta = decodedData['data']['company_tarjeta'];
        cmodel.companyVerified = decodedData['data']['company_verified'];
        cmodel.companyRating = decodedData['data']['company_rating'];
        cmodel.companyCreatedAt = decodedData['data']['company_created_at'];
        cmodel.companyJoin = decodedData['data']['company_join'];
        cmodel.companyStatus = decodedData['data']['company_status'];
        cmodel.companyMt = decodedData['data']['company_mt'];

        final list1 = await companyDatabase
            .obtenerCompanyPorId(decodedData['data']['id_company']);

        if (list1.length > 0) {
          cmodel.negocioEstadoSeleccion = list1[0].negocioEstadoSeleccion;
        } else {
          cmodel.negocioEstadoSeleccion = "0";
        }

        await companyDatabase.insertarCompany(cmodel);

        SubsidiaryModel smodel = SubsidiaryModel();
        smodel.idSubsidiary = decodedData['data']['id_subsidiary'];
        smodel.idCompany = decodedData['data']['id_company'];
        smodel.subsidiaryName = decodedData['data']['subsidiary_name'];
        smodel.subsidiaryCellphone =
            decodedData['data']['subsidiary_cellphone'];
        smodel.subsidiaryCellphone2 =
            decodedData['data']['subsidiary_cellphone_2'];
        smodel.subsidiaryEmail = decodedData['data']['subsidiary_email'];
        smodel.subsidiaryCoordX = decodedData['data']['subsidiary_coord_x'];
        smodel.subsidiaryCoordY = decodedData['data']['subsidiary_coord_y'];
        smodel.subsidiaryOpeningHours =
            decodedData['data']['subsidiary_opening_hours'];
        smodel.subsidiaryPrincipal =
            decodedData['data']['subsidiary_principal'];
        smodel.subsidiaryStatus = decodedData['data']['subsidiary_status'];
        smodel.subsidiaryImg = decodedData['data']['subsidiary_img'];
        smodel.subsidiaryAddress = decodedData['data']['subsidiary_address'];

        final list = await subsidiaryDatabase.obtenerSubsidiaryPorIdSubsidiary(
            decodedData['data']['id_subsidiary']);

        if (list.length > 0) {
          smodel.subsidiaryStatusPedidos = list[0].subsidiaryStatusPedidos;
        } else {
          smodel.subsidiaryStatusPedidos = "0";
        }
        await subsidiaryDatabase.insertarSubsidiary(smodel);
        return code;
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
