import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:rxdart/rxdart.dart';

class PantallaInicioBloc {
  final negociosDatabase = CompanyDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();

  final negociosController = BehaviorSubject<List<CompanyModel>>();
  final sucursalController = BehaviorSubject<List<SubsidiaryModel>>();
  Stream<List<CompanyModel>> get negociosStream => negociosController.stream;
  Stream<List<SubsidiaryModel>> get suscursaStream => sucursalController.stream;

  void obtenernegocios() async {
    negociosController.sink.add(await negociosDatabase.obtenerCompany());
  }

  void obtenersucursales(String idcompany) async {
    sucursalController.sink
        .add(await subsidiaryDatabase.obtenerSubsidiaryPorIdCompany(idcompany));
  }

  dispose() {
    negociosController?.close();

    sucursalController?.close();
  }
}
