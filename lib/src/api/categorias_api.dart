import 'dart:convert';

import 'package:bufi_empresas/src/database/category_db.dart';
import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/good_db.dart';
import 'package:bufi_empresas/src/database/itemSubcategory_db.dart';
import 'package:bufi_empresas/src/database/producto_bd.dart';
import 'package:bufi_empresas/src/database/service_db.dart';
import 'package:bufi_empresas/src/database/subcategory_db.dart';
import 'package:bufi_empresas/src/database/subsidiaryService_db.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/categoriaModel.dart';
import 'package:bufi_empresas/src/models/itemSubcategoryModel.dart';
import 'package:bufi_empresas/src/models/subcategoryModel.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class CategoriasApi {
  final categoryDatabase = CategoryDatabase();
  final subcategoryDatabase = SubcategoryDatabase();
  final itemsubCategoryDatabase = ItemsubCategoryDatabase();
  final companyDatabase = CompanyDatabase();
  final subsidiaryDatabase = SubsidiaryDatabase();
  final productoDatabase = ProductoDatabase();
  final subisdiaryServiceDatabase = SubsidiaryServiceDatabase();
  final goodDatabase = GoodDatabase();
  final serviceDatabase = ServiceDatabase();

  Future<int> obtenerCategorias() async {
    //List<CategoriaModel> categoriaList = [];
    try {
      var response = await http.post(
          Uri.parse("$apiBaseURL/api/Inicio/listar_categorias"),
          body: {});
      var res = jsonDecode(response.body);

      for (var i = 0; i < res.length; i++) {
        CategoriaModel categ = CategoriaModel();
        categ.idCategory = res[i]["id_category"];
        categ.categoryName = res[i]["category_name"];

        //categoriaList.add(categ);
        await categoryDatabase.insertarCategory(categ);

        SubcategoryModel subcategoryModel = SubcategoryModel();
        subcategoryModel.idCategory = res[i]["id_category"];
        subcategoryModel.idSubcategory = res[i]["id_subcategory"];
        subcategoryModel.subcategoryName = res[i]["subcategory_name"];

        await subcategoryDatabase.insertarSubCategory(subcategoryModel);

        //Insertamos el itemsubcategoria
        ItemSubCategoriaModel itemSubCategoriaModel = ItemSubCategoriaModel();
        itemSubCategoriaModel.idItemsubcategory = res[i]['id_itemsubcategory'];
        itemSubCategoriaModel.idSubcategory = res[i]['id_subcategory'];
        itemSubCategoriaModel.itemsubcategoryName =
            res[i]['itemsubcategory_name'];
        await itemsubCategoryDatabase
            .insertarItemSubCategoria(itemSubCategoriaModel);
      }
      return 0;
      //return categoriaList;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      return 0;
      //return categoriaList;
    }
  }
}
