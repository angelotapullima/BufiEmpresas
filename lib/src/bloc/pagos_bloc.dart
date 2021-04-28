import 'package:bufi_empresas/src/api/Pagos/pagos_api.dart';
import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/detallePedido_database.dart';
import 'package:bufi_empresas/src/database/pagos_db.dart';
import 'package:bufi_empresas/src/database/producto_bd.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi_empresas/src/models/DetallePedidoModel.dart';
import 'package:bufi_empresas/src/models/PagosModel.dart';
import 'package:bufi_empresas/src/models/listPagosGeneralModel.dart';
import 'package:bufi_empresas/src/models/productoModel.dart';
import 'package:rxdart/rxdart.dart';

class PagosBloc {
  final pagosDatabase = PagosDataBase();
  final productoDb = ProductoDatabase();
  final subsidiaryDb = SubsidiaryDatabase();
  final detallePedidoDb = DetallePedidoDatabase();
  final companyDb = CompanyDatabase();
  final pagosApi = PagosApi();
  final _pagosController = BehaviorSubject<List<PagosModel>>();
  final _pagosGeneralController =
      BehaviorSubject<List<ListPagosGeneralModel>>();
  final _pedidoIdController = BehaviorSubject<List<PagosModel>>();
  final _cargandoItems = BehaviorSubject<bool>();
  Stream<List<PagosModel>> get pagosStream => _pagosController.stream;
  Stream<List<ListPagosGeneralModel>> get pagosGeneralStream =>
      _pagosGeneralController.stream;
  Stream<List<PagosModel>> get pagoIdStream => _pedidoIdController.stream;
  Stream<bool> get cargandoItemsStream => _cargandoItems.stream;
  void dispose() {
    _pagosController?.close();
    _cargandoItems?.close();
    _pedidoIdController?.close();
    _pagosGeneralController?.close();
  }

  void obtenerPagosXFecha(
      String idSubsidiary, String fechaI, String fechaF) async {
    _pagosController.sink.add(await pagosDatabase
        .obtenerPagosXIdSubsidiaryAndFecha(idSubsidiary, fechaI, fechaF));
    _cargandoItems.sink.add(true);
    pagosApi.obtenerPagosXIdSubsidiary(idSubsidiary, fechaI, fechaF);
    _cargandoItems.sink.add(false);
    _pagosController.sink.add(await pagosDatabase
        .obtenerPagosXIdSubsidiaryAndFecha(idSubsidiary, fechaI, fechaF));

    //_pagosController.sink.add(await pagosApi.obtenerPagosXIdSubsidiary(idSubsidiary, fechaIni, fechaFin));
  }

  void obtenerPagosGeneral(
      String idSubsidiary, String fechaI, String fechaF) async {
    _pagosGeneralController.sink
        .add(await obtenerPagosXFechaYCantidad(idSubsidiary, fechaI, fechaF));
    _cargandoItems.sink.add(true);
    pagosApi.obtenerPagosXIdSubsidiary(idSubsidiary, fechaI, fechaF);
    _cargandoItems.sink.add(false);
    _pagosGeneralController.sink
        .add(await obtenerPagosXFechaYCantidad(idSubsidiary, fechaI, fechaF));
  }

  void obtenerPagoXid(String idPago) async {
    _pedidoIdController.sink.add(await obtenerPedidosPorIdPedido(idPago));
  }

  Future<List<ListPagosGeneralModel>> obtenerPagosXFechaYCantidad(
      String idSubsidiary, String fechaI, String fechaF) async {
    List<ListPagosGeneralModel> listaGeneral = [];
    List<PagosModel> listaPago = [];

    //Obtener todos los pedidos de la Db
    final listPagos = await pagosDatabase.obtenerPagosXIdSubsidiaryAndFecha(
        idSubsidiary, fechaI, fechaF);
    double total = 0;
    //Recorremos la lista de todos los pagos
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

      pagosModel.idDelivery = listPagos[i].idDelivery;
      pagosModel.pagoTipo = listPagos[i].pagoTipo;
      pagosModel.pagoMonto = listPagos[i].pagoMonto;
      pagosModel.pagoComision = listPagos[i].pagoComision;
      pagosModel.pagoTotal = listPagos[i].pagoTotal;
      pagosModel.pagoDate = listPagos[i].pagoDate;
      pagosModel.pagoEstado = listPagos[i].pagoEstado;
      pagosModel.pagoMicrotime = listPagos[i].pagoMicrotime;

      total = double.parse(listPagos[i].pagoTotal) + total;

      listaPago.add(pagosModel);
    }
    ListPagosGeneralModel pagosGeneral = ListPagosGeneralModel();
    pagosGeneral.pagos = listaPago;
    pagosGeneral.total = total.toString();
    listaGeneral.add(pagosGeneral);
    return listaGeneral;
  }

  Future<List<PagosModel>> obtenerPedidosPorIdPedido(String idPago) async {
    List<PagosModel> listaGeneral = [];

    //obtener todos los pagos de la bd
    final listPagos = await pagosDatabase.obtenerPagosXIdPago(idPago);

    //Recorremos la lista de todos los pagos
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

      pagosModel.idDelivery = listPagos[i].idDelivery;
      pagosModel.pagoTipo = listPagos[i].pagoTipo;
      pagosModel.pagoMonto = listPagos[i].pagoMonto;
      pagosModel.pagoComision = listPagos[i].pagoComision;
      pagosModel.pagoTotal = listPagos[i].pagoTotal;
      pagosModel.pagoDate = listPagos[i].pagoDate;
      pagosModel.pagoEstado = listPagos[i].pagoEstado;
      pagosModel.pagoMicrotime = listPagos[i].pagoMicrotime;

      //funcion que llama desde la bd a todos los detalles del pedido pasando el idPedido como argumento
      final listdetallePedido = await detallePedidoDb
          .obtenerDetallePedidoxIdPedido(listPagos[i].idDelivery);
      //crear lista vacia para llenar el detalle del pedido
      final List<DetallePedidoModel> listDetallePedidoModel = [];

      // recorrer la tabla de detalle de pedido
      for (var j = 0; j < listdetallePedido.length; j++) {
        final detallePedido = DetallePedidoModel();

        detallePedido.idDetallePedido = listdetallePedido[j].idDetallePedido;
        detallePedido.idPedido = listdetallePedido[j].idPedido;
        detallePedido.idProducto = listdetallePedido[j].idProducto;
        detallePedido.cantidad = listdetallePedido[j].cantidad;
        detallePedido.detallePedidoSubtotal =
            listdetallePedido[j].detallePedidoSubtotal;

        //crear lista vacia para el modelo de Producto
        final List<ProductoModel> listProductosModel = [];

        final listProductos =
            await productoDb.obtenerProductoPorIdSubsidiaryGood(
                listdetallePedido[j].idProducto);
        //Recorrer la lista de la tabla productos para obtenr todos los datos
        for (var l = 0; l < listProductos.length; l++) {
          final productoModel = ProductoModel();

          productoModel.idProducto = listProductos[0].idProducto;
          productoModel.idSubsidiary = listProductos[0].idSubsidiary;
          productoModel.productoName = listProductos[0].productoName;
          productoModel.productoPrice = listProductos[0].productoPrice;
          productoModel.productoCurrency = listProductos[l].productoCurrency;
          productoModel.productoImage = listProductos[0].productoImage;
          productoModel.productoCharacteristics =
              listProductos[0].productoCharacteristics;
          productoModel.productoBrand = listProductos[0].productoBrand;
          productoModel.productoModel = listProductos[0].productoModel;
          productoModel.productoMeasure = listProductos[0].productoMeasure;

          listProductosModel.add(productoModel);
        }
        detallePedido.listProducto = listProductosModel;

        listDetallePedidoModel.add(detallePedido);
      }

      pagosModel.detallePedido = listDetallePedidoModel;

      //------Recorrer la lista de compañías y sucursales---------

      //funcion que llama desde la bd a todas las sucursales y compañías

      final listSucursal = await subsidiaryDb
          .obtenerSubsidiaryPorIdSubsidiary(listPagos[i].idSubsidiary);
      final listaCompany =
          await companyDb.obtenerCompanyPorId(listSucursal[0].idCompany);
      final List<CompanySubsidiaryModel> listCompsucursalModel = [];

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
      compSucursalModel.companyName = listaCompany[0].companyName;
      compSucursalModel.companyRuc = listaCompany[0].companyRuc;
      compSucursalModel.companyImage = listaCompany[0].companyImage;
      compSucursalModel.companyType = listaCompany[0].companyType;
      compSucursalModel.companyShortcode = listaCompany[0].companyShortcode;
      compSucursalModel.companyDeliveryPropio =
          listaCompany[0].companyDeliveryPropio;
      compSucursalModel.companyDelivery = listaCompany[0].companyDelivery;
      compSucursalModel.companyEntrega = listaCompany[0].companyEntrega;
      compSucursalModel.companyTarjeta = listaCompany[0].companyTarjeta;
      compSucursalModel.companyVerified = listaCompany[0].companyVerified;
      compSucursalModel.companyRating = listaCompany[0].companyRating;
      compSucursalModel.companyCreatedAt = listaCompany[0].companyCreatedAt;
      compSucursalModel.companyJoin = listaCompany[0].companyJoin;
      compSucursalModel.companyStatus = listaCompany[0].companyStatus;
      compSucursalModel.companyMt = listaCompany[0].companyMt;

      listCompsucursalModel.add(compSucursalModel);

      pagosModel.listCompanySubsidiary = listCompsucursalModel;

      listaGeneral.add(pagosModel);
    }

    return listaGeneral;
  }
}
