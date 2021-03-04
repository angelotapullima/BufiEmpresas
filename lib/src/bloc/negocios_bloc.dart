import 'package:bufi_empresas/src/api/negocios_api.dart';
import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/models/companySubidiaryModel.dart';
import 'package:rxdart/rxdart.dart';

class NegociosBloc {
  final negociosApi = NegociosApi();
  final negociosDatabase = CompanyDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();

  final negociosController = BehaviorSubject<List<CompanyModel>>();
  final listarNegocioController =
      BehaviorSubject<List<CompanySubsidiaryModel>>();
  final detalleNegocioController = BehaviorSubject<List<CompanyModel>>();

  Stream<List<CompanyModel>> get negociosStream => negociosController.stream;
  Stream<List<CompanySubsidiaryModel>> get listarNeg =>
      listarNegocioController.stream;
  Stream<List<CompanyModel>> get detalleNegStream =>
      detalleNegocioController.stream;

  dispose() {
    negociosController?.close();

    listarNegocioController?.close();
    detalleNegocioController?.close();
  }

  void obtenernegocios() async {
    negociosController.sink.add(await negociosDatabase.obtenerCompany());
    await negociosApi.obtenerCompany();

    negociosController.sink.add(await negociosDatabase.obtenerCompany());
  }

  void listarnegocios() async {
    listarNegocioController.sink.add(await listaNegociosPrincipal());
    await negociosApi.listarCompany();

    listarNegocioController.sink.add(await listaNegociosPrincipal());
  }

  Future<List<CompanySubsidiaryModel>> listaNegociosPrincipal() async {
    final listGeneral = List<CompanySubsidiaryModel>();
    final listCompany = await negociosDatabase.obtenerCompany();

    if (listCompany.length > 0) {
      for (var i = 0; i < listCompany.length; i++) {
        final subsi = await subsidiaryDatabase
            .obtenerSubdiaryPrincipal(listCompany[i].idCompany);

        if (subsi.length > 0) {
          CompanySubsidiaryModel companySubsidiaryModel =
              CompanySubsidiaryModel();
          companySubsidiaryModel.idCompany = listCompany[i].idCompany;
          companySubsidiaryModel.companyName = listCompany[i].companyName;
          companySubsidiaryModel.idUser = listCompany[i].idUser;
          companySubsidiaryModel.idCity = listCompany[i].idCity;
          companySubsidiaryModel.idCategory = listCompany[i].idCategory;
          companySubsidiaryModel.companyImage = listCompany[i].companyImage;
          companySubsidiaryModel.companyRuc = listCompany[i].companyRuc;
          companySubsidiaryModel.companyType = listCompany[i].companyType;
          companySubsidiaryModel.companyShortcode =
              listCompany[i].companyShortcode;
          companySubsidiaryModel.companyDelivery =
              listCompany[i].companyDelivery;
          companySubsidiaryModel.companyEntrega = listCompany[i].companyEntrega;
          companySubsidiaryModel.companyTarjeta = listCompany[i].companyTarjeta;
          companySubsidiaryModel.companyVerified =
              listCompany[i].companyVerified;
          companySubsidiaryModel.companyRating = listCompany[i].companyRating;
          companySubsidiaryModel.companyCreatedAt =
              listCompany[i].companyCreatedAt;
          companySubsidiaryModel.companyJoin = listCompany[i].companyJoin;
          companySubsidiaryModel.companyStatus = listCompany[i].companyStatus;
          companySubsidiaryModel.companyMt = listCompany[i].companyMt;
          companySubsidiaryModel.miNegocio = listCompany[i].miNegocio;
          companySubsidiaryModel.cell = listCompany[i].cell;
          companySubsidiaryModel.direccion = listCompany[i].direccion;
          companySubsidiaryModel.favourite = listCompany[i].favourite;
          companySubsidiaryModel.idSubsidiary = subsi[0].idSubsidiary;
          companySubsidiaryModel.subsidiaryName = subsi[0].subsidiaryName;
          companySubsidiaryModel.subsidiaryAddress = subsi[0].subsidiaryAddress;
          companySubsidiaryModel.subsidiaryCellphone =
              subsi[0].subsidiaryCellphone;
          companySubsidiaryModel.subsidiaryCellphone2 =
              subsi[0].subsidiaryCellphone2;
          companySubsidiaryModel.subsidiaryCoordX = subsi[0].subsidiaryCoordX;
          companySubsidiaryModel.subsidiaryCoordY = subsi[0].subsidiaryCoordY;
          companySubsidiaryModel.subsidiaryOpeningHours =
              subsi[0].subsidiaryOpeningHours;
          companySubsidiaryModel.subsidiaryPrincipal =
              subsi[0].subsidiaryPrincipal;
          companySubsidiaryModel.subsidiaryStatus = subsi[0].subsidiaryStatus;
          companySubsidiaryModel.favourite = subsi[0].subsidiaryFavourite;

          listGeneral.add(companySubsidiaryModel);
        }
      }
    }

    return listGeneral;
  }

  void obtenernegociosporID(String id) async {
    detalleNegocioController.sink
        .add(await negociosDatabase.obtenerCompanyPorId(id));
    await negociosApi.obtenerNegocioPorId(id);

    detalleNegocioController.sink
        .add(await negociosDatabase.obtenerCompanyPorId(id));
  }
}
