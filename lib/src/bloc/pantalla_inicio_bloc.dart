import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/models/companySubidiaryModel.dart';
import 'package:rxdart/rxdart.dart';

class PantallaInicioBloc {
  final negociosDatabase = CompanyDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();

  final negociosController = BehaviorSubject<List<CompanyModel>>();
  final listarNegocioController =
      BehaviorSubject<List<CompanySubsidiaryModel>>();
  Stream<List<CompanyModel>> get negociosStream => negociosController.stream;

  void obtenernegocios() async {
    negociosController.sink.add(await negociosDatabase.obtenerCompany());
  }

  dispose() {
    negociosController?.close();

    listarNegocioController?.close();
  }
}
