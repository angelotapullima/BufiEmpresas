import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

import 'package:bufi_empresas/src/models/itemSubcategoryModel.dart';
import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/galeriaProducto_database.dart';
import 'package:bufi_empresas/src/database/modeloProducto_database.dart';
import 'package:bufi_empresas/src/database/tallaProducto_database.dart';
import 'package:bufi_empresas/src/database/marcaProducto_database.dart';
import 'package:bufi_empresas/src/database/itemSubcategory_db.dart';
import 'package:bufi_empresas/src/database/good_db.dart';
import 'package:bufi_empresas/src/database/producto_bd.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/models/galeriaProductoModel.dart';
import 'package:bufi_empresas/src/models/goodModel.dart';
import 'package:bufi_empresas/src/models/marcaProductoModel.dart';
import 'package:bufi_empresas/src/models/modeloProductoModel.dart';
import 'package:bufi_empresas/src/models/productoModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/models/tallaProductoModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProductosApi {
  final subsidiaryDatabase = SubsidiaryDatabase();
  final productoDatabase = ProductoDatabase();
  final goodDatabase = GoodDatabase();
  final companyDatabase = CompanyDatabase();
  final itemsubCategoryDatabase = ItemsubCategoryDatabase();
  final prefs = Preferences();

  Future<dynamic> listarProductosPorSucursal(String id) async {
    print('listar_productos_por_sucursal');

    final response = await http.post(
        Uri.parse('$apiBaseURL/api/Negocio/listar_productos_por_sucursal'),
        body: {
          'id_sucursal': '$id',
          'id_ciudad': '1',
        });

    final decodedData = json.decode(response.body);

    if (decodedData['results'].length > 0) {
      for (var i = 0; i < decodedData['results'].length; i++) {
        //SubsidiaryGoodModel
        ProductoModel productoModel = ProductoModel();
        productoModel.idProducto =
            decodedData['results'][i]["id_subsidiarygood"];
        productoModel.idSubsidiary = decodedData['results'][i]["id_subsidiary"];
        productoModel.idGood = decodedData['results'][i]["id_good"];
        productoModel.idItemsubcategory =
            decodedData['results'][i]['id_itemsubcategory'];
        productoModel.productoName =
            decodedData['results'][i]['subsidiary_good_name'];
        productoModel.productoPrice =
            decodedData['results'][i]['subsidiary_good_price'];
        productoModel.productoCurrency =
            decodedData['results'][i]['subsidiary_good_currency'];
        productoModel.productoImage =
            decodedData['results'][i]['subsidiary_good_image'];
        productoModel.productoCharacteristics =
            decodedData['results'][i]['subsidiary_good_characteristics'];
        productoModel.productoBrand =
            decodedData['results'][i]['subsidiary_good_brand'];
        productoModel.productoModel =
            decodedData['results'][i]['subsidiary_good_model'];
        productoModel.productoType =
            decodedData['results'][i]['subsidiary_good_type'];
        productoModel.productoSize =
            decodedData['results'][i]['subsidiary_good_size'];
        productoModel.productoStock =
            decodedData['results'][i]['subsidiary_good_stock'];
        productoModel.productoMeasure =
            decodedData['results'][i]['subsidiary_good_stock_measure'];
        productoModel.productoStockStatus =
            decodedData['results'][i]['subsidiary_good_stock_status'];
        productoModel.productoRating =
            decodedData['results'][i]['subsidiary_good_rating'];
        productoModel.productoUpdated =
            decodedData['results'][i]['subsidiary_good_updated'];
        productoModel.productoStatus =
            decodedData['results'][i]['subsidiary_good_status'];

        print(decodedData['results'][i]['subsidiary_good_status']);

        var productList =
            await productoDatabase.obtenerProductoPorIdSubsidiaryGood(
                decodedData['results'][i]['id_subsidiarygood']);

        if (productList.length > 0) {
          productoModel.productoFavourite = productList[0].productoFavourite;
        } else {
          productoModel.productoFavourite = '';
        }
        await productoDatabase.insertarProducto(productoModel);

        SubsidiaryModel submodel = SubsidiaryModel();
        submodel.idCompany = decodedData['results'][i]["id_company"];
        submodel.idSubsidiary = decodedData['results'][i]["id_subsidiary"];
        submodel.subsidiaryName = decodedData['results'][i]['subsidiary_name'];
        submodel.subsidiaryAddress =
            decodedData['results'][i]['subsidiary_address'];
        submodel.subsidiaryCellphone =
            decodedData['results'][i]['subsidiary_cellphone'];
        submodel.subsidiaryCellphone2 =
            decodedData['results'][i]['subsidiary_cellphone_2'];
        submodel.subsidiaryEmail =
            decodedData['results'][i]['subsidiary_email'];
        submodel.subsidiaryCoordX =
            decodedData['results'][i]['subsidiary_coord_x'];
        submodel.subsidiaryCoordY =
            decodedData['results'][i]['subsidiary_coord_y'];
        submodel.subsidiaryOpeningHours =
            decodedData['results'][i]['subsidiary_opening_hours'];
        submodel.subsidiaryPrincipal =
            decodedData['results'][i]['subsidiary_principal'];
        submodel.subsidiaryImg = decodedData["results"][i]['subsidiary_img'];
        submodel.subsidiaryStatus =
            decodedData['results'][i]['subsidiary_status'];

        final list = await subsidiaryDatabase.obtenerSubsidiaryPorIdSubsidiary(
            decodedData['results'][i]["id_subsidiary"]);

        if (list.length > 0) {
          submodel.subsidiaryFavourite = list[0].subsidiaryFavourite;
          //Subsidiary
        } else {
          submodel.subsidiaryFavourite = "0";
        }

        await subsidiaryDatabase.insertarSubsidiary(submodel);

        //BienesModel
        BienesModel goodmodel = BienesModel();
        goodmodel.idGood = decodedData['results'][i]['id_good'];
        goodmodel.goodName = decodedData['results'][i]['good_name'];
        goodmodel.goodSynonyms = decodedData['results'][i]['good_synonyms'];
        await goodDatabase.insertarGood(goodmodel);

        //ItemSubCategoriaModel
        ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
        itemSubCategoriaModel.idSubcategory =
            decodedData['results'][i]['id_subcategory'];
        itemSubCategoriaModel.idItemsubcategory =
            decodedData['results'][i]['itemsubcategory_name'];
        itemSubCategoriaModel.itemsubcategoryName =
            decodedData['results'][i]['itemsubcategory_name'];
        await itemsubCategoryDatabase
            .insertarItemSubCategoria(itemSubCategoriaModel);
      }
    }

    return 0;
  }

  Future<int> deshabilitarSubsidiaryProducto(String id, String status) async {
    try {
      final response = await http.post(
          Uri.parse('$apiBaseURL/api/Negocio/deshabilitar_producto'),
          body: {
            'id_subsidiarygood': '$id',
            'app': 'true',
            'tn': prefs.token,
            'estado': '$status',
          });

      final decodedData = json.decode(response.body);

      return decodedData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<int> cambiarStock(String id, String status) async {
    try {
      final response = await http
          .post(Uri.parse('$apiBaseURL/api/Negocio/cambiar_stock'), body: {
        'id_subsidiarygood': '$id',
        'app': 'true',
        'tn': prefs.token,
        'estado': '$status',
      });

      final decodedData = json.decode(response.body);

      return decodedData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  Future<int> guardarProducto(File _image, ProductoModel producModel) async {
    final preferences = Preferences();

    // open a byteStream
    var stream = new http.ByteStream(Stream.castFrom(_image.openRead()));
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse("$apiBaseURL/api/Negocio/guardar_producto");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["tn"] = preferences.token;
    request.fields["app"] = 'true';
    request.fields["id_sucursal"] = producModel.idSubsidiary;
    request.fields["id_good"] = producModel.idGood;
    request.fields["categoria"] = producModel.idItemsubcategory;
    request.fields["nombre"] = producModel.productoName;
    request.fields["precio"] = producModel.productoPrice;
    request.fields["currency"] = producModel.productoCurrency;
    request.fields["measure"] = producModel.productoMeasure;
    request.fields["marca"] = producModel.productoBrand;
    request.fields["modelo"] = producModel.productoModel;
    request.fields["size"] = producModel.productoSize;
    request.fields["stock"] = producModel.productoStock;

    // multipart that takes file.. here this "image_file" is a key of the API request
    var multipartFile = new http.MultipartFile('producto_img', stream, length,
        filename: basename(_image.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);

        final decodedData = json.decode(value);
        final int code = decodedData['result']['code'];

        if (decodedData['result']['code'] == 1) {
          print('amonos');
          return 1;
        } else if (code == 2) {
          return 2;
        } else {
          return code;
        }
      });
    }).catchError((e) {
      print(e);
    });
    return 1;
  }

  Future<int> editarProducto(File _image, ProductoModel producModel) async {
    final preferences = Preferences();
    var multipartFile;

    if (_image != null) {
      // open a byteStream
      var stream = new http.ByteStream(Stream.castFrom(_image.openRead()));
      // get file length
      var length = await _image.length();
      // multipart that takes file.. here this "image_file" is a key of the API request
      multipartFile = new http.MultipartFile('producto_img', stream, length,
          filename: basename(_image.path));
    }

    // string to uri
    var uri = Uri.parse("$apiBaseURL/api/Negocio/guardar_producto");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // if you need more parameters to parse, add those like this. i added "user_id". here this "user_id" is a key of the API request
    request.fields["tn"] = preferences.token;
    request.fields["app"] = 'true';
    request.fields["id_subsidiarygood"] = producModel.idProducto;
    request.fields["nombre"] = producModel.productoName;
    request.fields["precio"] = producModel.productoPrice;
    request.fields["currency"] = producModel.productoCurrency;
    request.fields["measure"] = producModel.productoMeasure;
    request.fields["marca"] = producModel.productoBrand;
    request.fields["modelo"] = producModel.productoModel;
    request.fields["size"] = producModel.productoSize;
    request.fields["stock"] = producModel.productoStock;

    // add file to multipart
    if (_image != null) {
      request.files.add(multipartFile);
    }

    // send request to upload image
    await request.send().then((response) async {
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);

        final decodedData = json.decode(value);
        if (decodedData['result']['code'] == 1) {
          print('amonos');
        }
      });
    }).catchError((e) {
      print(e);
    });
    return 1;
  }

  Future<int> listarDetalleProductoPorIdProducto(String idProducto) async {
    try {
      final response = await http.post(
          Uri.parse('$apiBaseURL/api/Negocio/listar_detalle_producto'),
          body: {
            'id': idProducto,
          });

      final decodedData = json.decode(response.body);

      //SubsidiaryGoodModel
      ProductoModel productoModel = ProductoModel();
      productoModel.idProducto = decodedData["id_subsidiarygood"];
      productoModel.idSubsidiary = decodedData["id_subsidiary"];
      productoModel.idGood = decodedData["id_good"];
      productoModel.idItemsubcategory = decodedData['id_itemsubcategory'];
      productoModel.productoName = decodedData['subsidiary_good_name'];
      productoModel.productoPrice = decodedData['subsidiary_good_price'];
      productoModel.productoCurrency = decodedData['subsidiary_good_currency'];
      productoModel.productoImage = decodedData['subsidiary_good_image'];
      productoModel.productoCharacteristics =
          decodedData['subsidiary_good_characteristics'];
      productoModel.productoBrand = decodedData['subsidiary_good_brand'];
      productoModel.productoModel = decodedData['subsidiary_good_model'];
      productoModel.productoType = decodedData['subsidiary_good_type'];
      productoModel.productoSize = decodedData['subsidiary_good_size'];
      //productoModel.productoStock = decodedData['subsidiary_good_stock'];
      productoModel.productoMeasure =
          decodedData['subsidiary_good_stock_measure'];
      productoModel.productoStock = decodedData['subsidiary_good_stock_status'];
      productoModel.productoRating = decodedData['subsidiary_good_rating'];
      productoModel.productoUpdated = decodedData['subsidiary_good_updated'];
      productoModel.productoStatus = decodedData['subsidiary_good_status'];

      var productList = await productoDatabase
          .obtenerProductoPorIdSubsidiaryGood(decodedData['id_subsidiarygood']);

      if (productList.length > 0) {
        productoModel.productoFavourite = productList[0].productoFavourite;
      } else {
        productoModel.productoFavourite = '';
      }
      await productoDatabase.insertarProducto(productoModel);

      //Sucursal
      SubsidiaryModel submodel = SubsidiaryModel();
      submodel.idCompany = decodedData["id_company"];
      submodel.idSubsidiary = decodedData["id_subsidiary"];
      submodel.subsidiaryName = decodedData['subsidiary_name'];
      submodel.subsidiaryAddress = decodedData['subsidiary_address'];
      submodel.subsidiaryCellphone = decodedData['subsidiary_cellphone'];
      submodel.subsidiaryCellphone2 = decodedData['subsidiary_cellphone_2'];
      submodel.subsidiaryEmail = decodedData['subsidiary_email'];
      submodel.subsidiaryCoordX = decodedData['subsidiary_coord_x'];
      submodel.subsidiaryCoordY = decodedData['subsidiary_coord_y'];
      submodel.subsidiaryOpeningHours = decodedData['subsidiary_opening_hours'];
      submodel.subsidiaryPrincipal = decodedData['subsidiary_principal'];
      submodel.subsidiaryImg = decodedData['subsidiary_img'];
      submodel.subsidiaryStatus = decodedData['subsidiary_status'];

      final list = await subsidiaryDatabase
          .obtenerSubsidiaryPorIdSubsidiary(decodedData["id_subsidiary"]);

      if (list.length > 0) {
        submodel.subsidiaryFavourite = list[0].subsidiaryFavourite;
        //Subsidiary
      } else {
        submodel.subsidiaryFavourite = "0";
      }

      await subsidiaryDatabase.insertarSubsidiary(submodel);

      //Company
      CompanyModel companyModel = CompanyModel();
      companyModel.idCompany = decodedData['id_company'];
      companyModel.idUser = decodedData['id_user'];
      companyModel.idCity = decodedData['id_city'];
      companyModel.idCategory = decodedData['id_category'];
      companyModel.companyName = decodedData['company_name'];
      companyModel.companyRuc = decodedData['company_ruc'];
      companyModel.companyImage = decodedData['company_image'];
      companyModel.companyType = decodedData['company_type'];
      companyModel.companyShortcode = decodedData['company_shortcode'];
      companyModel.companyDeliveryPropio =
          decodedData['company_delivery_propio'];
      companyModel.companyDelivery = decodedData['company_delivery'];
      companyModel.companyEntrega = decodedData['company_entrega'];
      companyModel.companyTarjeta = decodedData['company_tarjeta'];
      companyModel.companyVerified = decodedData['company_verified'];
      companyModel.companyRating = decodedData['company_rating'];
      companyModel.companyCreatedAt = decodedData['company_created_at'];
      companyModel.companyJoin = decodedData['company_join'];
      companyModel.companyStatus = decodedData['company_status'];
      companyModel.companyMt = decodedData['company_mt'];

      await companyDatabase.insertarCompany(companyModel);

      //BienesModel
      BienesModel goodmodel = BienesModel();
      goodmodel.idGood = decodedData['id_good'];
      goodmodel.goodName = decodedData['good_name'];
      goodmodel.goodSynonyms = decodedData['good_synonyms'];
      await goodDatabase.insertarGood(goodmodel);

      //ItemSubCategoriaModel
      ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
      itemSubCategoriaModel.idSubcategory = decodedData['id_subcategory'];
      itemSubCategoriaModel.idItemsubcategory =
          decodedData['itemsubcategory_name'];
      itemSubCategoriaModel.itemsubcategoryName =
          decodedData['itemsubcategory_name'];
      await itemsubCategoryDatabase
          .insertarItemSubCategoria(itemSubCategoriaModel);

      //Galeria
      for (var i = 0; i < decodedData["galeria"].length; i++) {
        GaleriaProductoModel galeriaProductoModel = GaleriaProductoModel();
        final galeriaProductoDb = GaleriaProductoDatabase();
        galeriaProductoModel.idGaleriaProducto =
            decodedData["galeria"][i]["id_subsidiary_good_galeria"];
        galeriaProductoModel.idProducto =
            decodedData["galeria"][i]['id_subsidiarygood'];
        galeriaProductoModel.galeriaFoto =
            decodedData["galeria"][i]["galeria_foto"];

        final list =
            await galeriaProductoDb.obtenerGaleriaProductoPorIdProducto(
                decodedData["galeria"][i]['id_subsidiarygood']);

        if (list.length > 0) {
          galeriaProductoModel.estado = list[0].estado;
        } else {
          galeriaProductoModel.estado = "0";
        }

        await galeriaProductoDb.insertarGaleriaProducto(galeriaProductoModel);
      }
      //Marca
      for (var j = 0; j < decodedData["marcas"].length; j++) {
        final marcaProductoModel = MarcaProductoModel();
        final marcaProductoDb = MarcaProductoDatabase();
        marcaProductoModel.idMarcaProducto =
            decodedData["marcas"][j]["id_subsidiarygood_brand"];
        marcaProductoModel.idProducto =
            decodedData["marcas"][j]['id_subsidiary_good'];
        marcaProductoModel.marcaProducto =
            decodedData["marcas"][j]["subsidiarygood_brand"];
        marcaProductoModel.marcaStatusProducto =
            decodedData["marcas"][j]["subsidiarygood_brand_status"];

        final list = await marcaProductoDb.obtenerMarcaProductoPorIdProducto(
            decodedData["marcas"][j]['id_subsidiary_good']);

        if (list.length > 0) {
          marcaProductoModel.estado = list[0].estado;
        } else {
          marcaProductoModel.estado = "0";
        }

        await marcaProductoDb.insertarMarcaProducto(marcaProductoModel);
      }

      //Modelo
      for (var k = 0; k < decodedData["modelos"].length; k++) {
        final modeloProductoModel = ModeloProductoModel();
        final modeloProductoDb = ModeloProductoDatabase();
        modeloProductoModel.idModeloProducto =
            decodedData["modelos"][k]["id_subsidiarygood_model"];
        modeloProductoModel.idProducto =
            decodedData["modelos"][k]['id_subsidiarygood'];
        modeloProductoModel.modeloProducto =
            decodedData["modelos"][k]["subsidiarygood_model"];
        modeloProductoModel.modeloStatusProducto =
            decodedData["modelos"][k]["subsidiarygood_model_status"];

        final list = await modeloProductoDb.obtenerModeloProductoPorIdProducto(
            decodedData["modelos"][k]['id_subsidiarygood']);

        if (list.length > 0) {
          modeloProductoModel.estado = list[0].estado;
        } else {
          modeloProductoModel.estado = "0";
        }

        await modeloProductoDb.insertarModeloProducto(modeloProductoModel);
      }

      //Talla
      for (var l = 0; l < decodedData["tallas"].length; l++) {
        final tallaProductoModel = TallaProductoModel();
        final tallaProductoDb = TallaProductoDatabase();
        tallaProductoModel.idTallaProducto =
            decodedData["tallas"][l]["id_subsidiarygood_size"];
        tallaProductoModel.idProducto =
            decodedData["tallas"][l]['id_subsidiarygood'];
        tallaProductoModel.tallaProducto =
            decodedData["tallas"][l]["subsidiarygood_size"];
        tallaProductoModel.tallaProductoStatus =
            decodedData["tallas"][l]["subsidiarygood_size_status"];

        final list = await tallaProductoDb.obtenerTallaProductoPorIdProducto(
            decodedData["tallas"][l]['id_subsidiarygood']);

        if (list.length > 0) {
          tallaProductoModel.estado = list[0].estado;
        } else {
          tallaProductoModel.estado = "0";
        }

        await tallaProductoDb.insertarTallaProducto(tallaProductoModel);
      }

      return 1;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }

  //Retorna el nombre del bien
  Future<dynamic> obtenerGoodAll2() async {
    try {
      var response = await http.post(
          Uri.parse("$apiBaseURL/api/Negocio/listar_all_good"),
          body: {/*'app': 'true', 'tn': prefs.token*/});

      List decodedData = json.decode(response.body);

      for (int i = 0; i < decodedData.length; i++) {
        //final listGood = await goodDatabase.obtenerGood();

        BienesModel goodmodel = BienesModel();

        goodmodel.idGood = decodedData[i]['id_good'];
        goodmodel.goodName = decodedData[i]['good_name'];
        goodmodel.goodSynonyms = decodedData[i]['good_synonyms'];

        await goodDatabase.insertarGood(goodmodel);
      }
      return 0;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
    }
  }
}
