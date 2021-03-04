import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart' as T;

void showToast(BuildContext context, String msg, {int duration, int gravity}) {
  T.Toast.show(msg, context, duration: duration, gravity: gravity);
}

void showToast1(String msg, int duration, ToastGravity gravity) {
  Fluttertoast.showToast(
      msg: '$msg',
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: duration,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

String format(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
}

//Actualizar Negocio
/*  void actualizarNegocio(
      BuildContext context, CompanySubsidiaryModel model) async {
    final detallenegocio = ProviderBloc.negocios(context);
    //final actualizarNeg = ProviderBloc.actualizarNeg(context);

    final sucursalDb = SubsidiaryDatabase();
    final companyDb = CompanyDatabase();
    final sucursalModel = SubsidiaryModel();
    final companyModel = CompanyModel();

//datos que se reciben desde los controllers
    sucursalModel.idSubsidiary = model.idSubsidiary;
    sucursalModel.subsidiaryCellphone = model.subsidiaryCellphone;
    sucursalModel.subsidiaryCellphone2 = model.subsidiaryCellphone2;
    sucursalModel.subsidiaryCoordX = model.subsidiaryCoordX;
    sucursalModel.subsidiaryCoordY = model.subsidiaryCoordY;
    sucursalModel.subsidiaryOpeningHours = model.subsidiaryOpeningHours;
    sucursalModel.subsidiaryAddress = model.subsidiaryAddress;

//obtener todos los datos de la sucursal para pasar como argumento en update
    final listSucursales =
        await sucursalDb.obtenerSubsidiaryPorId(model.idSubsidiary);

    sucursalModel.idCompany = listSucursales[0].idCompany;
    sucursalModel.subsidiaryName = listSucursales[0].subsidiaryName;
    sucursalModel.subsidiaryEmail = listSucursales[0].subsidiaryEmail;
    sucursalModel.subsidiaryPrincipal = listSucursales[0].subsidiaryPrincipal;
    sucursalModel.subsidiaryStatus = listSucursales[0].subsidiaryStatus;

    await sucursalDb.updateSubsidiary(sucursalModel);

//Obtener datos de company
    companyModel.idCompany = model.idCompany;
    companyModel.idCategory = model.idCategory;
    companyModel.companyName = model.companyName;
    companyModel.companyRuc = model.companyRuc;
    companyModel.companyImage = model.companyImage;
    companyModel.companyType = model.companyType;
    companyModel.companyShortcode = model.companyShortcode;
    companyModel.companyDelivery = model.companyDelivery;
    companyModel.companyEntrega = model.companyEntrega;
    companyModel.companyTarjeta = model.companyTarjeta;

    final listCompany = await companyDb.obtenerCompanyPorId(model.idCompany);

    companyModel.idCompany = listCompany[0].idCompany;
    companyModel.idUser = listCompany[0].idUser;
    companyModel.idCity = listCompany[0].idCity;
    companyModel.idCategory = listCompany[0].idCategory;
    companyModel.companyVerified = listCompany[0].companyVerified;
    companyModel.companyRating = listCompany[0].companyRating;
    companyModel.companyCreatedAt = listCompany[0].companyCreatedAt;
    companyModel.companyJoin = listCompany[0].companyJoin;
    companyModel.companyStatus = listCompany[0].companyStatus;
    companyModel.companyMt = listCompany[0].companyMt;
    companyModel.miNegocio = listCompany[0].miNegocio;

    await companyDb.updateCompany(companyModel);
    //actualizarNeg.updateNegocio(id)
    detallenegocio.obtenernegociosporID(model.idCompany);
  }
} */
