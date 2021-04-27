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
    sucursalController.sink.add(await obtnerDetalleSubsidiary(idcompany));
  }

  dispose() {
    negociosController?.close();

    sucursalController?.close();
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
}
