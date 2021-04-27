import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:rxdart/subjects.dart';

class SucursalBloc {
  final sucursalDatabase = SubsidiaryDatabase();
  final negociosDatabase = CompanyDatabase();

//obtener subsidiary por idCompany
  final _sucursalController = BehaviorSubject<List<SubsidiaryModel>>();
  final _listarsucursalesController = BehaviorSubject<List<SubsidiaryModel>>();

  //Controller de subsidiary por id
  final _subsidiaryController = BehaviorSubject<List<SubsidiaryModel>>();

//Stream de subsidiary por idCompany
  Stream<List<SubsidiaryModel>> get sucursalStream =>
      _sucursalController.stream;

//Stream de subsidiary por id
  Stream<List<SubsidiaryModel>> get subsidiaryIdStream =>
      _subsidiaryController.stream;

  void dispose() {
    _sucursalController?.close();
    _listarsucursalesController?.close();
    _subsidiaryController?.close();
  }

  void obtenerSucursalporIdCompany(String id) async {
    _sucursalController.sink
        .add(await sucursalDatabase.obtenerSubsidiaryPorIdCompany(id));
  }

  void obtenerSucursales() async {
    _sucursalController.sink.add(await sucursalDatabase.obtenerSubsidiary());
  }

  void obtenerSucursalporId(String id) async {
    _subsidiaryController.sink.add(await obtnerDetalleSubsidiary(id));
  }

  Future<List<SubsidiaryModel>> obtnerDetalleSubsidiary(String id) async {
    final List<SubsidiaryModel> listaGeneral = [];
    final listSucursales =
        await sucursalDatabase.obtenerSubsidiaryPorIdSubsidiary(id);
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
