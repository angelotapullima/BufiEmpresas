import 'dart:convert';
import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/detallePedido_database.dart';
import 'package:bufi_empresas/src/database/good_db.dart';
import 'package:bufi_empresas/src/database/pedidos_db.dart';
import 'package:bufi_empresas/src/database/producto_bd.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/DetallePedidoModel.dart';
import 'package:bufi_empresas/src/models/PedidosModel.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/models/goodModel.dart';
import 'package:bufi_empresas/src/models/productoModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PedidoApi {
  final prefs = new Preferences();

  final pedidoDb = PedidosDatabase();
  final companyDb = CompanyDatabase();
  final detallePedidoDb = DetallePedidoDatabase();
  final sucursalDb = SubsidiaryDatabase();
  final goodDb = GoodDatabase();

  Future<dynamic> obtenerPedidosPorIdSucursal(String idSucursal) async {
    final response = await http
        .post("$apiBaseURL/api/Pedido/pedidos_por_subsidiary_ws", body: {
      'id_subsidiary': '$idSucursal',
      'estado': '99',
      'tn': prefs.token,
      'app': 'true'
    });

    final decodedData = json.decode(response.body);

//recorremos la lista de pedidos
    for (var i = 0; i < decodedData["result"].length; i++) {
      final pedidosModel = PedidosModel();

      pedidosModel.idPedido = decodedData["result"][i]['id_delivery'];
      pedidosModel.idUser = decodedData["result"][i]['id_user'];
      pedidosModel.idCity = decodedData["result"][i]['id_city'];
      pedidosModel.idSubsidiary = decodedData["result"][i]['id_subsidiary'];
      pedidosModel.idCompany = decodedData["result"][i]['id_company'];
      pedidosModel.deliveryNumber = decodedData["result"][i]['delivery_number'];
      pedidosModel.deliveryName = decodedData["result"][i]['delivery_name'];
      pedidosModel.deliveryEmail = decodedData["result"][i]['delivery_email'];
      pedidosModel.deliveryCel = decodedData["result"][i]['delivery_cel'];
      pedidosModel.deliveryAddress =
          decodedData["result"][i]['delivery_address'];
      pedidosModel.deliveryDescription =
          decodedData["result"][i]['delivery_description'];
      pedidosModel.deliveryCoordX =
          decodedData["result"][i]['delivery_coord_x'];
      pedidosModel.deliveryCoordY =
          decodedData["result"][i]['delivery_coord_y'];
      pedidosModel.deliveryAddInfo =
          decodedData["result"][i]['delivery_add_info'];
      pedidosModel.deliveryPrice = decodedData["result"][i]['delivery_price'];
      pedidosModel.deliveryTotalOrden =
          decodedData["result"][i]['delivery_total_orden'];
      pedidosModel.deliveryPayment =
          decodedData["result"][i]['delivery_payment'];
      pedidosModel.deliveryEntrega =
          decodedData["result"][i]['delivery_entrega'];
      pedidosModel.deliveryDatetime =
          decodedData["result"][i]['delivery_datetime'];
      pedidosModel.deliveryStatus = decodedData["result"][i]['delivery_status'];
      pedidosModel.deliveryMt = decodedData["result"][i]['delivery_mt'];
      //insertar a la tabla de Pedidos
      await pedidoDb.insertarPedido(pedidosModel);

      final sucursalModel = SubsidiaryModel();

      sucursalModel.idSubsidiary = decodedData["result"][i]['id_subsidiary'];
      sucursalModel.idCompany = decodedData["result"][i]['id_company'];
      sucursalModel.subsidiaryName =
          decodedData["result"][i]['subsidiary_name'];
      sucursalModel.subsidiaryAddress =
          decodedData["result"][i]['subsidiary_address'];
      sucursalModel.subsidiaryCellphone =
          decodedData["result"][i]['subsidiary_cellphone'];
      sucursalModel.subsidiaryCellphone2 =
          decodedData["result"][i]['subsidiary_cellphone_2'];
      sucursalModel.subsidiaryEmail =
          decodedData["result"][i]['subsidiary_email'];
      sucursalModel.subsidiaryCoordX =
          decodedData["result"][i]['subsidiary_coord_x'];
      sucursalModel.subsidiaryCoordY =
          decodedData["result"][i]['subsidiary_coord_y'];
      sucursalModel.subsidiaryOpeningHours =
          decodedData["result"][i]['subsidiary_opening_hours'];
      sucursalModel.subsidiaryPrincipal =
          decodedData["result"][i]['subsidiary_principal'];
      sucursalModel.subsidiaryImg = decodedData["result"][i]['subsidiary_img'];
      sucursalModel.subsidiaryStatus =
          decodedData["result"][i]['subsidiary_status'];

      //Obtener la lista de sucursales para asignar a estado seleccion Pedido
      final list = await sucursalDb.obtenerSubsidiaryPorIdSubsidiary(
          decodedData["result"][i]['id_subsidiary']);

      if (list.length > 0) {
        sucursalModel.subsidiaryStatusPedidos = list[0].subsidiaryFavourite;
      } else {
        sucursalModel.subsidiaryFavourite = "0";
      }
      //insertar a la tabla sucursal
      await sucursalDb.insertarSubsidiary(sucursalModel);

      final companyModel = CompanyModel();
      companyModel.idCompany = decodedData["result"][i]['id_company'];
      companyModel.idUser = decodedData["result"][i]['id_user'];
      companyModel.idCity = decodedData["result"][i]['id_city'];
      companyModel.idCategory = decodedData["result"][i]['id_category'];
      companyModel.companyName = decodedData["result"][i]['company_name'];
      companyModel.companyRuc = decodedData["result"][i]['company_ruc'];
      companyModel.companyImage = decodedData["result"][i]['company_image'];
      companyModel.companyType = decodedData["result"][i]['company_type'];
      companyModel.companyShortcode =
          decodedData["result"][i]['company_shortcode'];
      companyModel.companyDeliveryPropio =
          decodedData["result"][i]['company_delivery_propio'];
      companyModel.companyDelivery =
          decodedData["result"][i]['company_delivery'];
      companyModel.companyEntrega = decodedData["result"][i]['company_entrega'];
      companyModel.companyTarjeta = decodedData["result"][i]['company_tarjeta'];
      companyModel.companyVerified =
          decodedData["result"][i]['company_verified'];
      companyModel.companyRating = decodedData["result"][i]['company_rating'];
      companyModel.companyCreatedAt =
          decodedData["result"][i]['company_created_at'];
      companyModel.companyJoin = decodedData["result"][i]['company_join'];
      companyModel.companyStatus = decodedData["result"][i]['company_status'];
      companyModel.companyMt = decodedData["result"][i]['company_mt'];
      companyModel.miNegocio = decodedData["result"][i]['mi_negocio'];

      //Obtener la lista de Company
      final listCompany = await companyDb
          .obtenerCompanyPorId(decodedData["result"][i]['id_company']);

      if (listCompany.length > 0) {
        companyModel.miNegocio = listCompany[0].miNegocio;
      } else {
        companyModel.miNegocio = "";
      }
      //insertar a la tabla de Company
      await companyDb.insertarCompany(companyModel);

      //recorremos la segunda lista de detalle de pedidos
      for (var j = 0;
          j < decodedData["result"][i]["detalle_pedido"].length;
          j++) {
        final detallePedido = DetallePedidoModel();
        detallePedido.idDetallePedido =
            decodedData["result"][i]["detalle_pedido"][j]["id_delivery_detail"];
        detallePedido.idPedido =
            decodedData["result"][i]["detalle_pedido"][j]["id_delivery"];
        detallePedido.idProducto =
            decodedData["result"][i]["detalle_pedido"][j]["id_subsidiarygood"];
        detallePedido.cantidad = decodedData["result"][i]["detalle_pedido"][j]
            ["delivery_detail_qty"];
        detallePedido.detallePedidoSubtotal = decodedData["result"][i]
            ["detalle_pedido"][j]["delivery_detail_subtotal"];

        //insertamos en la bd los productos
        ProductoModel subsidiaryGoodModel = ProductoModel();
        final productoDb = ProductoDatabase();
        subsidiaryGoodModel.idProducto =
            decodedData["result"][i]["detalle_pedido"][j]['id_subsidiarygood'];
        subsidiaryGoodModel.idSubsidiary =
            decodedData["result"][i]["detalle_pedido"][j]['id_subsidiary'];
        subsidiaryGoodModel.idGood =
            decodedData["result"][i]["detalle_pedido"][j]['id_good'];
        subsidiaryGoodModel.productoName = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_name'];
        subsidiaryGoodModel.productoPrice = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_price'];
        subsidiaryGoodModel.productoCurrency = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_currency'];
        subsidiaryGoodModel.productoImage = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_image'];
        subsidiaryGoodModel.productoCharacteristics = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_characteristics'];
        subsidiaryGoodModel.productoBrand = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_brand'];
        subsidiaryGoodModel.productoModel = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_model'];
        subsidiaryGoodModel.productoType = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_type'];
        subsidiaryGoodModel.productoSize = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_size'];
        subsidiaryGoodModel.productoStock = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_stock'];
        subsidiaryGoodModel.productoMeasure = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_stock_measure'];
        subsidiaryGoodModel.productoRating = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_rating'];
        subsidiaryGoodModel.productoUpdated = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_updated'];
        subsidiaryGoodModel.productoStatus = decodedData["result"][i]
            ["detalle_pedido"][j]['subsidiary_good_status'];

        //Obtener la lista de Company
        final listProducto = await productoDb
            .obtenerProductoPorIdSubsidiaryGood(decodedData["result"][i]
                ["detalle_pedido"][j]['id_subsidiarygood']);

        if (listProducto.length > 0) {
          subsidiaryGoodModel.productoFavourite =
              listProducto[0].productoFavourite;
        } else {
          subsidiaryGoodModel.productoFavourite = "";
        }
        //insertar a la tabla Producto
        await productoDb.insertarProducto(subsidiaryGoodModel);

        //insertamos en la bd el bien
        final goodModel = BienesModel();
        goodModel.idGood =
            decodedData["result"][i]["detalle_pedido"][j]['id_good'];
        goodModel.goodName =
            decodedData["result"][i]["detalle_pedido"][j]['good_name'];
        goodModel.goodSynonyms =
            decodedData["result"][i]["detalle_pedido"][j]['good_synonyms'];
        //insertar a la tabla de Company
        await goodDb.insertarGood(goodModel);

        //insertar a la tabla de Detalle de Pedidos
        await detallePedidoDb.insertarDetallePedido(detallePedido);
      }
    }
    //print(decodedData);
    return 0;
  }

  Future<dynamic> updateStatus(String id, String estado) async {
    try {
      final response =
          await http.post('$apiBaseURL/api/Pedido/update_status', body: {
        'id': '$id',
        'app': 'true',
        'tn': prefs.token,
        'status': '$estado',
      });

      final decodedData = json.decode(response.body);

      return decodedData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }
}
