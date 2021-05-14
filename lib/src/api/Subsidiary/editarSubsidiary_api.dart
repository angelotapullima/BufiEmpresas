import 'dart:convert';

import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class EditarSubsidaryApi {
  final prefs = new Preferences();
  final companyDatabase = new CompanyDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();
  Future<int> editarSubsidiary(SubsidiaryModel subsidiaryModel) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Negocio/guardar_edicion_sede');
      final resp = await http.post(url, body: {
        'empresa_nombre': '${subsidiaryModel.subsidiaryName}',
        'id': '${subsidiaryModel.idSubsidiary}',
        'empresa_cel': '${subsidiaryModel.subsidiaryCellphone}',
        'empresa_cel2': '${subsidiaryModel.subsidiaryCellphone2}',
        'empresa_direccion': '${subsidiaryModel.subsidiaryAddress}',
        'empresa_email': '${subsidiaryModel.subsidiaryEmail}',
        'empresa_coord_x': '${subsidiaryModel.subsidiaryCoordX}',
        'empresa_coord_y': '${subsidiaryModel.subsidiaryCoordY}',
        'opening_hours': '${subsidiaryModel.subsidiaryOpeningHours}',
        'tn': prefs.token,
        'app': 'true'
      });
      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];
      if (code == 1) {
        CompanyModel cmodel = CompanyModel();
        cmodel.idCompany = decodedData['result']['data']['id_company'];
        cmodel.idUser = decodedData['result']['data']['id_user'];
        cmodel.idCity = decodedData['result']['data']['id_city'];
        cmodel.idCategory = decodedData['result']['data']['id_category'];
        cmodel.companyName = decodedData['result']['data']['company_name'];
        cmodel.companyRuc = decodedData['result']['data']['company_ruc'];
        cmodel.companyImage = decodedData['result']['data']['company_image'];
        cmodel.companyType = decodedData['result']['data']['company_type'];
        cmodel.companyShortcode =
            decodedData['result']['data']['company_shortcode'];
        cmodel.companyDelivery =
            decodedData['result']['data']['company_delivery'];
        cmodel.companyEntrega =
            decodedData['result']['data']['company_entrega'];
        cmodel.companyTarjeta =
            decodedData['result']['data']['company_tarjeta'];
        cmodel.companyVerified =
            decodedData['result']['data']['company_verified'];
        cmodel.companyRating = decodedData['result']['data']['company_rating'];
        cmodel.companyCreatedAt =
            decodedData['result']['data']['company_created_at'];
        cmodel.companyJoin = decodedData['result']['data']['company_join'];
        cmodel.companyStatus = decodedData['result']['data']['company_status'];
        cmodel.companyMt = decodedData['result']['data']['company_mt'];

        final list1 = await companyDatabase
            .obtenerCompanyPorId(decodedData['result']['data']['id_company']);

        if (list1.length > 0) {
          cmodel.negocioEstadoSeleccion = list1[0].negocioEstadoSeleccion;
        } else {
          cmodel.negocioEstadoSeleccion = "0";
        }

        await companyDatabase.insertarCompany(cmodel);

        SubsidiaryModel smodel = SubsidiaryModel();
        smodel.idSubsidiary = decodedData['result']['data']['id_subsidiary'];
        smodel.idCompany = decodedData['result']['data']['id_company'];
        smodel.subsidiaryName =
            decodedData['result']['data']['subsidiary_name'];
        smodel.subsidiaryCellphone =
            decodedData['result']['data']['subsidiary_cellphone'];
        smodel.subsidiaryCellphone2 =
            decodedData['result']['data']['subsidiary_cellphone_2'];
        smodel.subsidiaryEmail =
            decodedData['result']['data']['subsidiary_email'];
        smodel.subsidiaryCoordX =
            decodedData['result']['data']['subsidiary_coord_x'];
        smodel.subsidiaryCoordY =
            decodedData['result']['data']['subsidiary_coord_y'];
        smodel.subsidiaryOpeningHours =
            decodedData['result']['data']['subsidiary_opening_hours'];
        smodel.subsidiaryPrincipal =
            decodedData['result']['data']['subsidiary_principal'];
        smodel.subsidiaryStatus =
            decodedData['result']['data']['subsidiary_status'];
        smodel.subsidiaryImg = decodedData["result"]['data']['subsidiary_img'];
        smodel.subsidiaryAddress =
            decodedData['result']['data']['subsidiary_address'];

        final list = await subsidiaryDatabase.obtenerSubsidiaryPorIdSubsidiary(
            decodedData['result']['data']['id_subsidiary']);

        if (list.length > 0) {
          smodel.subsidiaryStatusPedidos = list[0].subsidiaryStatusPedidos;
        } else {
          smodel.subsidiaryStatusPedidos = "0";
        }
        await subsidiaryDatabase.insertarSubsidiary(smodel);
        return code;
      } else {
        return code;
      }
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return 0;
    }
  }
}
