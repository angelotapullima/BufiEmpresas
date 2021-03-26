import 'package:bufi_empresas/src/api/Pagos/pagos_api.dart';
import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/pagos_db.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi_empresas/src/models/PagosModel.dart';
import 'package:rxdart/rxdart.dart';

class PagosBloc {
  final pagosDatabase = PagosDataBase();
  final subsidiaryDb = SubsidiaryDatabase();
  final companyDb = CompanyDatabase();
  final pagosApi = PagosApi();
  final _pagosController = BehaviorSubject<List<PagosModel>>();
  final _pedidoIdController = BehaviorSubject<List<PagosModel>>();
  final _cargandoItems = BehaviorSubject<bool>();
  Stream<List<PagosModel>> get pagosStream => _pagosController.stream;
  Stream<List<PagosModel>> get pagoIdStream => _pedidoIdController.stream;
  Stream<bool> get cargandoItemsStream => _cargandoItems.stream;
  void dispose() {
    _pagosController?.close();
    _cargandoItems?.close();
    _pedidoIdController?.close();
  }

  void obtenerPagosXFecha(
      String idSubsidiary, String fechaI, String fechaF) async {
    _cargandoItems.sink.add(true);
    _pagosController.sink.add(await pagosDatabase
        .obtenerPagosXIdSubsidiaryAndFecha(idSubsidiary, fechaI, fechaF));

    pagosApi.obtenerPagosXIdSubsidiary(idSubsidiary, fechaI, fechaF);
    _pagosController.sink.add(await pagosDatabase
        .obtenerPagosXIdSubsidiaryAndFecha(idSubsidiary, fechaI, fechaF));
    _cargandoItems.sink.add(false);

    //_pagosController.sink.add(await pagosApi.obtenerPagosXIdSubsidiary(idSubsidiary, fechaIni, fechaFin));
  }

  void obtenerPagoXid(String idPago) async {
    _pedidoIdController.sink.add(await obtenerPedidosPorIdPedido(idPago));
  }

  Future<List<PagosModel>> obtenerPedidosPorIdPedido(String idPago) async {
    List<PagosModel> listaGeneral = List<PagosModel>();

    //obtener todos los pedidos de la bd
    final listPagos = await pagosDatabase.obtenerPagosXIdPago(idPago);

    //Recorremos la lista de todos los pedidos
    for (var i = 0; i < listPagos.length; i++) {
      final pagosModel = PagosModel();

      pagosModel.idPago = listPagos[i].idPago;
      pagosModel.idTransferenciaUE = listPagos[i].idTransferenciaUE;
      pagosModel.transferenciaUENroOperacion =
          listPagos[i].transferenciaUENroOperacion;
      pagosModel.idUsuario = listPagos[i].idUsuario;
      pagosModel.idEmpresa = listPagos[i].idEmpresa;
      pagosModel.transferenciaUEMonto = listPagos[i].transferenciaUEMonto;
      pagosModel.transferecniaUEConcepto = listPagos[i].transferecniaUEConcepto;
      pagosModel.transferenciaUEDate = listPagos[i].transferenciaUEDate;
      pagosModel.transferenciaUEEstado = listPagos[i].transferenciaUEEstado;

      //------Recorrer la lista de compañías y sucursales---------

      //funcion que llama desde la bd a todas las sucursales y compañías
      final listCompany =
          await companyDb.obtenerCompanyPorId(listPagos[i].idEmpresa);
      final listSucursal = await subsidiaryDb
          .obtenerSubsidiaryPorIdSubsidiary(listPagos[i].idSubsidiary);
      final listCompsucursalModel = List<CompanySubsidiaryModel>();

      final compSucursalModel = CompanySubsidiaryModel();
      //Sucursal
      compSucursalModel.subsidiaryName = listSucursal[0].subsidiaryName;
      compSucursalModel.subsidiaryAddress = listSucursal[0].subsidiaryAddress;
      compSucursalModel.subsidiaryCellphone =
          listSucursal[0].subsidiaryCellphone;
      compSucursalModel.subsidiaryCellphone2 =
          listSucursal[0].subsidiaryCellphone2;
      compSucursalModel.subsidiaryEmail = listSucursal[0].subsidiaryEmail;
      compSucursalModel.subsidiaryCoordX = listSucursal[0].subsidiaryCoordX;
      compSucursalModel.subsidiaryCoordY = listSucursal[0].subsidiaryCoordY;
      compSucursalModel.subsidiaryOpeningHours =
          listSucursal[0].subsidiaryOpeningHours;
      compSucursalModel.subsidiaryPrincipal =
          listSucursal[0].subsidiaryPrincipal;
      compSucursalModel.subsidiaryStatus = listSucursal[0].subsidiaryStatus;

      //Company
      compSucursalModel.companyName = listCompany[0].companyName;
      compSucursalModel.companyRuc = listCompany[0].companyRuc;
      compSucursalModel.companyImage = listCompany[0].companyImage;
      compSucursalModel.companyType = listCompany[0].companyType;
      compSucursalModel.companyShortcode = listCompany[0].companyShortcode;
      compSucursalModel.companyDeliveryPropio =
          listCompany[0].companyDeliveryPropio;
      compSucursalModel.companyDelivery = listCompany[0].companyDelivery;
      compSucursalModel.companyEntrega = listCompany[0].companyEntrega;
      compSucursalModel.companyTarjeta = listCompany[0].companyTarjeta;
      compSucursalModel.companyVerified = listCompany[0].companyVerified;
      compSucursalModel.companyRating = listCompany[0].companyRating;
      compSucursalModel.companyCreatedAt = listCompany[0].companyCreatedAt;
      compSucursalModel.companyJoin = listCompany[0].companyJoin;
      compSucursalModel.companyStatus = listCompany[0].companyStatus;
      compSucursalModel.companyMt = listCompany[0].companyMt;

      listCompsucursalModel.add(compSucursalModel);

      pagosModel.listCompanySubsidiary = listCompsucursalModel;

      listaGeneral.add(pagosModel);
    }

    return listaGeneral;
  }
}
