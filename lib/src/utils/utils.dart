import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/database/tipoEstadoPedido_db.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:intl/intl.Dart';
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

void actualizarEstadoSucursal(BuildContext context, String idSubsdiary) async {
  final sucursalesBloc = ProviderBloc.negocios(context);
  final preferences = Preferences();
  preferences.idSeleccionSubsidiaryPedidos = idSubsdiary;
  sucursalesBloc.obtenersucursales(preferences.idSeleccionNegocioInicio);
  final pedidosBloc = ProviderBloc.pedido(context);
  pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
      preferences.idSeleccionSubsidiaryPedidos, preferences.idStatusPedidos);
}

void actualizarIdStatusPedidos(
    BuildContext context, String idTipoEstadoPago) async {
  final tiposEstadosPedidosDatabase = TiposEstadoPedidosDatabase();
  final tipoEstadoPedidos = ProviderBloc.tipoEstadoPedidos(context);

  await tiposEstadosPedidosDatabase.desSeleccionarTiposEstadosPedido();
  await tiposEstadosPedidosDatabase
      .updateSeleccionarTipoEstadoPedido(idTipoEstadoPago);
  tipoEstadoPedidos.obtenerTiposEstadosPedidos();
}

void obtenerprimerIdSubsidiary(BuildContext context, String idCompany) async {
  final subsidiaryDatabase = SubsidiaryDatabase();
  final preferences = Preferences();

  //Obtener el primer sucursal de cada Negocio
  final listSucursal =
      await subsidiaryDatabase.obtenerPrimerIdSubsidiary(idCompany);
  preferences.idSeleccionSubsidiaryPedidos = listSucursal[0].idSubsidiary;

  //Actualizar lista de Pedidos de la Pagina de Pedidos
  final pedidosBloc = ProviderBloc.pedido(context);
  pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
      preferences.idSeleccionSubsidiaryPedidos, preferences.idStatusPedidos);
}

void actualizarSeleccionCompany(BuildContext context, String idCompany) async {
  //Actualizar lista de Negocios Pagina Principal
  final negociosBloc = ProviderBloc.negocios(context);
  negociosBloc.obtenernegocios();

  //Inicializar al primer sucursal de la lista de Sucursales de la pagina de Pedidos
  final contadorBloc = ProviderBloc.contadorListaSucursales(context);
  contadorBloc.changeContador(0);
}

void obtenerprimerIdCompany(BuildContext context) async {
  final companyDatabase = CompanyDatabase();
  final preferences = Preferences();
  final listCompany = await companyDatabase.obtenerCompany();
  preferences.idSeleccionNegocioInicio = listCompany[0].idCompany;
  preferences.nombreCompany = listCompany[0].companyName;
  final empresaNameBloc = ProviderBloc.nameEmpresa(context);
  empresaNameBloc.changeEmpresaName(preferences.nombreCompany);
  final negociosBloc = ProviderBloc.negocios(context);
  negociosBloc.obtenersucursales(preferences.idSeleccionNegocioInicio);
  final contadorBloc = ProviderBloc.contadorPagina(context);
  contadorBloc.changeContador(0);
}

void actualizarBusquedaPagos(BuildContext context) {
  final pagosBloc = ProviderBloc.pagos(context);
  final prefs = Preferences();
  pagosBloc.obtenerPagosXFecha(
      prefs.idSeleccionSubsidiaryPedidos, prefs.fechaI, prefs.fechaF);
}

obtenerNombreMes(String date) {
  var fecha = DateTime.parse(date);

  final DateFormat fech = new DateFormat('dd MMM yyyy, H:m', 'es');

  return fech.format(fecha);
}

obtenerEstadoPedido(String id) async {
  final tiposEstadosPedidosDatabase = TiposEstadoPedidosDatabase();

  final preferences = Preferences();

  final listEstado =
      await tiposEstadosPedidosDatabase.obtenerTiposEstadoPedidoXid(id);

  for (int i = 0; i < listEstado.length; i++)
    preferences.nombreEstadoPedido = listEstado[i].tipoEstadoNombre;
}

habilitarDesProducto(BuildContext context, String id) async {
  final productosBloc = ProviderBloc.productos(context);
  final res = await productosBloc.habilitarDesProducto(id);
  if (res == 1) {
    productosBloc.listarProductosPorSucursal(id);
  }
}
