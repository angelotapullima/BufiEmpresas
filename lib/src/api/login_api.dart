import 'dart:convert';

import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/models/usuarioModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/constants.dart';

import 'package:http/http.dart' as http;

class LoginApi {
  final prefs = new Preferences();
  final companyDatabase = new CompanyDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();

  Future<int> login(String user, String pass) async {
    try {
      final url = '$apiBaseURL/api/Login/validar_sesion_empresa';

      final resp = await http.post(url, body: {
        'usuario_nickname': '$user',
        'usuario_contrasenha': '$pass',
        'app': 'true'
      });

      final decodedData = json.decode(resp.body);

      final int code = decodedData['result']['code'];

      if (code == 1) {
        final prodTemp = Data.fromJson(decodedData['data']);

        //agrego los datos de usuario al sharePreferences
        prefs.idUser = decodedData['data']['c_u'];
        prefs.idCity = prodTemp.idCity;
        prefs.idPerson = prodTemp.idPerson;
        prefs.userNickname = prodTemp.userNickname;
        prefs.userEmail = prodTemp.userEmail;
        prefs.userImage = prodTemp.userImage;
        prefs.personName = prodTemp.personName;
        prefs.personSurname = prodTemp.personSurname;
        prefs.idRoleUser = prodTemp.idRoleUser;
        prefs.roleName = prodTemp.roleName;
        prefs.token = decodedData['data']['tn'];

        if (decodedData['empresas'].length > 0) {
          for (var i = 0; i < decodedData['empresas'].length; i++) {
            CompanyModel cmodel = CompanyModel();
            cmodel.idCompany = decodedData['empresas'][i]['id_company'];
            cmodel.idUser = decodedData['empresas'][i]['id_user'];
            cmodel.idCity = decodedData['empresas'][i]['id_city'];
            cmodel.idCategory = decodedData['empresas'][i]['id_category'];
            cmodel.companyName = decodedData['empresas'][i]['company_name'];
            cmodel.companyRuc = decodedData['empresas'][i]['company_ruc'];
            cmodel.companyImage = decodedData['empresas'][i]['company_image'];
            cmodel.companyType = decodedData['empresas'][i]['company_type'];
            cmodel.companyShortcode =
                decodedData['empresas'][i]['company_shortcode'];
            cmodel.companyDelivery =
                decodedData['empresas'][i]['company_delivery'];
            cmodel.companyEntrega =
                decodedData['empresas'][i]['company_entrega'];
            cmodel.companyTarjeta =
                decodedData['empresas'][i]['company_tarjeta'];
            cmodel.companyVerified =
                decodedData['empresas'][i]['company_verified'];
            cmodel.companyRating = decodedData['empresas'][i]['company_rating'];
            cmodel.companyCreatedAt =
                decodedData['empresas'][i]['company_created_at'];
            cmodel.companyJoin = decodedData['empresas'][i]['company_join'];
            cmodel.companyStatus = decodedData['empresas'][i]['company_status'];
            cmodel.companyMt = decodedData['empresas'][i]['company_mt'];
            cmodel.miNegocio =
                decodedData['empresas'][i]['mi_negocio'].toString();

            await companyDatabase.insertarCompany(cmodel);

            //final listSucursal = await subsidiaryDatabase.obtenerSubsidiaryPorId(decodedData[i]['id_subsidiary']);

          }
        }

        if (decodedData['sedes'].length > 0) {
          for (var i = 0; i < decodedData['sedes'].length; i++) {
            SubsidiaryModel smodel = SubsidiaryModel();
            smodel.idSubsidiary = decodedData['sedes'][i]['id_subsidiary'];
            smodel.idCompany = decodedData['sedes'][i]['id_company'];
            smodel.subsidiaryName = decodedData['sedes'][i]['subsidiary_name'];
            smodel.subsidiaryCellphone =
                decodedData['sedes'][i]['subsidiary_cellphone'];
            smodel.subsidiaryCellphone =
                decodedData['sedes'][i]['id_subsidiary_cellphone_2'];
            smodel.subsidiaryEmail =
                decodedData['sedes'][i]['subsidiary_email'];
            smodel.subsidiaryCoordX =
                decodedData['sedes'][i]['subsidiary_coord_x'];
            smodel.subsidiaryCoordY =
                decodedData['sedes'][i]['subsidiary_coord_y'];
            smodel.subsidiaryOpeningHours =
                decodedData['sedes'][i]['subsidiary_opening_hours'];
            smodel.subsidiaryPrincipal =
                decodedData['sedes'][i]['subsidiary_principal'];
            smodel.subsidiaryStatus =
                decodedData['sedes'][i]['subsidiary_status'];
            smodel.subsidiaryAddress =
                decodedData['sedes'][i]['subsidiary_address'];
            await subsidiaryDatabase.insertarSubsidiary(smodel);
          }
        }
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
