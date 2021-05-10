import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:rxdart/rxdart.dart';

class PantallaInicioBloc {
  final negociosDatabase = CompanyDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();

  final negociosController = BehaviorSubject<List<CompanyModel>>();
  final detalleNegocioController =
      BehaviorSubject<List<CompanySubsidiaryModel>>();
  final _negocioController = BehaviorSubject<List<CompanyModel>>();
  final sucursalController = BehaviorSubject<List<SubsidiaryModel>>();
  Stream<List<CompanyModel>> get negociosStream => negociosController.stream;
  Stream<List<CompanyModel>> get negocioStream => _negocioController.stream;
  Stream<List<SubsidiaryModel>> get suscursaStream => sucursalController.stream;
  Stream<List<CompanySubsidiaryModel>> get detalleNegStream =>
      detalleNegocioController.stream;
  void obtenernegocios() async {
    negociosController.sink.add(await negociosDatabase.obtenerCompany());
  }

  void obtenernegociosxID(String idCompany) async {
    detalleNegocioController.sink
        .add(await obtenerCompanyXIdCompany(idCompany));
    // _negocioController.sink
    //     .add(await negociosDatabase.obtenerCompanyPorId(idCompany));
  }

  void obtenersucursales(String idcompany) async {
    sucursalController.sink.add(await obtnerDetalleSubsidiary(idcompany));
  }

  dispose() {
    negociosController?.close();
    _negocioController?.close();
    sucursalController?.close();
    detalleNegocioController?.close();
  }

  Future<List<SubsidiaryModel>> obtnerDetalleSubsidiary(
      String idCompany) async {
    final List<SubsidiaryModel> listaGeneral = [];
    final listSucursales =
        await subsidiaryDatabase.obtenerSubsidiaryPorIdCompany(idCompany);
    for (var i = 0; i < listSucursales.length; i++) {
      SubsidiaryModel sucursalModel = SubsidiaryModel();
      sucursalModel.idSubsidiary = listSucursales[i].idSubsidiary;
      sucursalModel.idCompany = listSucursales[i].idCompany;
      sucursalModel.subsidiaryName = listSucursales[i].subsidiaryName;
      sucursalModel.subsidiaryAddress = listSucursales[i].subsidiaryAddress;
      sucursalModel.subsidiaryCellphone = listSucursales[i].subsidiaryCellphone;
      sucursalModel.subsidiaryCellphone2 =
          listSucursales[i].subsidiaryCellphone2;
      sucursalModel.subsidiaryEmail = listSucursales[i].subsidiaryEmail;
      sucursalModel.subsidiaryCoordX = listSucursales[i].subsidiaryCoordX;
      sucursalModel.subsidiaryCoordY = listSucursales[i].subsidiaryCoordY;
      sucursalModel.subsidiaryOpeningHours =
          listSucursales[i].subsidiaryOpeningHours;
      sucursalModel.subsidiaryPrincipal = listSucursales[i].subsidiaryPrincipal;
      sucursalModel.subsidiaryStatus = listSucursales[i].subsidiaryStatus;
      sucursalModel.subsidiaryFavourite = listSucursales[i].subsidiaryFavourite;
      sucursalModel.subsidiaryImg = listSucursales[i].subsidiaryImg;
      sucursalModel.subsidiaryStatusPedidos =
          listSucursales[i].subsidiaryStatusPedidos;

      final listCompany = await negociosDatabase
          .obtenerCompanyPorId(listSucursales[i].idCompany);
      CompanyModel companyModel = CompanyModel();
      companyModel.idCompany = listCompany[0].idCompany;
      companyModel.idUser = listCompany[0].idUser;
      companyModel.idCity = listCompany[0].idCity;
      companyModel.idCategory = listCompany[0].idCategory;
      companyModel.companyName = listCompany[0].companyName;
      companyModel.companyRuc = listCompany[0].companyRuc;
      companyModel.companyImage = listCompany[0].companyImage;
      companyModel.companyType = listCompany[0].companyType;
      companyModel.companyShortcode = listCompany[0].companyShortcode;
      companyModel.companyDeliveryPropio = listCompany[0].companyDeliveryPropio;
      companyModel.companyDelivery = listCompany[0].companyDelivery;
      companyModel.companyEntrega = listCompany[0].companyEntrega;
      companyModel.companyTarjeta = listCompany[0].companyTarjeta;
      companyModel.companyVerified = listCompany[0].companyVerified;
      companyModel.companyRating = listCompany[0].companyRating;
      companyModel.companyCreatedAt = listCompany[0].companyCreatedAt;
      companyModel.companyJoin = listCompany[0].companyJoin;
      companyModel.companyStatus = listCompany[0].companyStatus;
      companyModel.companyMt = listCompany[0].companyMt;
      companyModel.miNegocio = listCompany[0].miNegocio;
      companyModel.cell = listCompany[0].cell;
      companyModel.direccion = listCompany[0].direccion;
      companyModel.favourite = listCompany[0].favourite;
      companyModel.negocioEstadoSeleccion =
          listCompany[0].negocioEstadoSeleccion;

      sucursalModel.listCompany = companyModel;

      listaGeneral.add(sucursalModel);
    }

    return listaGeneral;
  }

  Future<List<CompanySubsidiaryModel>> obtenerCompanyXIdCompany(
      String idCompany) async {
    final List<CompanySubsidiaryModel> listGeneral = [];
    final listCompany = await negociosDatabase.obtenerCompanyPorId(idCompany);

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
          companySubsidiaryModel.subsidiaryDescription =
              subsi[0].subsidiaryDescription;
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
}
