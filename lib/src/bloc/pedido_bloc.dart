import 'package:bufi_empresas/src/api/Pedidos/Pedido_api.dart';
import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/detallePedido_database.dart';
import 'package:bufi_empresas/src/database/pedidos_db.dart';
import 'package:bufi_empresas/src/database/producto_bd.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi_empresas/src/models/DetallePedidoModel.dart';
import 'package:bufi_empresas/src/models/PedidosModel.dart';
import 'package:bufi_empresas/src/models/productoModel.dart';
import 'package:rxdart/subjects.dart';

class PedidoBloc {
  final pedidoDb = PedidosDatabase();
  final detallePedidoDb = DetallePedidoDatabase();
  final productoDb = ProductoDatabase();
  final subsidiaryDb = SubsidiaryDatabase();
  final companyDb = CompanyDatabase();
  final pedidoApi = PedidoApi();

  final _pedidoController = BehaviorSubject<List<PedidosModel>>();
  final _pedidoIDController = BehaviorSubject<List<PedidosModel>>();
  final _cargandoItems = BehaviorSubject<bool>();

  final _pedidosAtendidosController = BehaviorSubject<List<PedidosModel>>();
  final _pedidosPendientesController = BehaviorSubject<List<PedidosModel>>();

  Stream<List<PedidosModel>> get pedidoStream => _pedidoController.stream;
  Stream<List<PedidosModel>> get pedidosAtendidosStream =>
      _pedidosAtendidosController.stream;
  Stream<List<PedidosModel>> get pedidosPendientesStream =>
      _pedidosPendientesController.stream;
  Stream<List<PedidosModel>> get pedidoPorIdStream =>
      _pedidoIDController.stream;
  Stream<bool> get cargandoItemsStream => _cargandoItems.stream;

  void dispose() {
    _pedidoController?.close();
    _pedidoIDController?.close();
    _cargandoItems?.close();
    _pedidosAtendidosController?.close();
    _pedidosPendientesController?.close();
    //_detallePedidoController?.close();
  }

  void obtenerPedidosAtendidos(String idCompany) async {
    _pedidosAtendidosController.sink
        .add(await pedidoDb.obtenerTotalPedidosAtendidos(idCompany));
  }

  void obtenerPedidosPendientes(String idCompany) async {
    _pedidosPendientesController.sink
        .add(await pedidoDb.obtenerTotalPedidosPendientes(idCompany));
  }

  void obtenerPedidosPorIdSubsidiaryAndIdStatus(
      String idSubsidiary, String idStatus) async {
    if (idStatus == '99') {
      _cargandoItems.sink.add(true);
      _pedidoController.sink
          .add(await pedidoDb.obtenerPedidosXidSubsidiary(idSubsidiary));

      pedidoApi.obtenerPedidosPorIdSucursal(idSubsidiary);
      _cargandoItems.sink.add(false);
      _pedidoController.sink
          .add(await pedidoDb.obtenerPedidosXidSubsidiary(idSubsidiary));
    } else {
      _cargandoItems.sink.add(true);
      _pedidoController.sink.add(await pedidoDb
          .obtenerPedidosXidSubsidiaryAndIdEstado(idSubsidiary, idStatus));

      pedidoApi.obtenerPedidosPorIdSucursal(idSubsidiary);
      _cargandoItems.sink.add(false);
      _pedidoController.sink.add(await pedidoDb
          .obtenerPedidosXidSubsidiaryAndIdEstado(idSubsidiary, idStatus));
    }
  }

  void obtenerPedidoPorId(String idPedido) async {
    _pedidoIDController.sink.add(await obtenerPedidosPorIdPedido(idPedido));
  }

  Future<List<PedidosModel>> obtenerPedidosPorIdPedido(String idPedido) async {
    List<PedidosModel> listaGeneral = [];

    //obtener todos los pedidos de la bd
    final listPedidos = await pedidoDb.obtenerPedidosXidPedido(idPedido);

    //Recorremos la lista de todos los pedidos
    for (var i = 0; i < listPedidos.length; i++) {
      final pedidosModel = PedidosModel();

      pedidosModel.idPedido = listPedidos[i].idPedido;
      pedidosModel.idUser = listPedidos[i].idUser;
      pedidosModel.idCity = listPedidos[i].idCity;
      pedidosModel.idSubsidiary = listPedidos[i].idSubsidiary;
      pedidosModel.idCompany = listPedidos[i].idCompany;
      pedidosModel.deliveryNumber = listPedidos[i].deliveryNumber;
      pedidosModel.deliveryName = listPedidos[i].deliveryName;
      pedidosModel.deliveryEmail = listPedidos[i].deliveryEmail;
      pedidosModel.deliveryCel = listPedidos[i].deliveryCel;
      pedidosModel.deliveryAddress = listPedidos[i].deliveryAddress;
      pedidosModel.deliveryDescription = listPedidos[i].deliveryDescription;
      pedidosModel.deliveryCoordX = listPedidos[i].deliveryCoordX;
      pedidosModel.deliveryCoordY = listPedidos[i].deliveryCoordY;
      pedidosModel.deliveryAddInfo = listPedidos[i].deliveryAddInfo;
      pedidosModel.deliveryPrice = listPedidos[i].deliveryPrice;
      pedidosModel.deliveryTotalOrden = listPedidos[i].deliveryTotalOrden;
      pedidosModel.deliveryPayment = listPedidos[i].deliveryPayment;
      pedidosModel.deliveryEntrega = listPedidos[i].deliveryEntrega;
      pedidosModel.deliveryDatetime = listPedidos[i].deliveryDatetime;
      pedidosModel.deliveryStatus = listPedidos[i].deliveryStatus;
      pedidosModel.deliveryMt = listPedidos[i].deliveryMt;

      //funcion que llama desde la bd a todos los detalles del pedido pasando el idPedido como argumento
      final listdetallePedido = await detallePedidoDb
          .obtenerDetallePedidoxIdPedido(listPedidos[i].idPedido);
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

      pedidosModel.detallePedido = listDetallePedidoModel;

      //------Recorrer la lista de compañías y sucursales---------

      //funcion que llama desde la bd a todas las sucursales y compañías
      final listCompany =
          await companyDb.obtenerCompanyPorId(listPedidos[i].idCompany);
      final listSucursal = await subsidiaryDb
          .obtenerSubsidiaryPorIdSubsidiary(listPedidos[i].idSubsidiary);
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

      pedidosModel.listCompanySubsidiary = listCompsucursalModel;

      listaGeneral.add(pedidosModel);
    }

    return listaGeneral;
  }
}
