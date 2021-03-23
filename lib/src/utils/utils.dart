import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/marcaProducto_database.dart';
import 'package:bufi_empresas/src/database/modeloProducto_database.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/database/tallaProducto_database.dart';
import 'package:bufi_empresas/src/database/tipoEstadoPedido_db.dart';
import 'package:bufi_empresas/src/models/marcaProductoModel.dart';
import 'package:bufi_empresas/src/models/modeloProductoModel.dart';
import 'package:bufi_empresas/src/models/tallaProductoModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
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

obtenerTiposEstadosPedidos() async {
  final tiposEstadosPedidosDatabase = TiposEstadoPedidosDatabase();

  final listEstados =
      await tiposEstadosPedidosDatabase.obtenerTiposEstadoPedido();
  return listEstados;
}

//Talla del producto
Future<int> cambiarEstadoTalla(
    BuildContext context, TallaProductoModel tallaModel) async {
  final datosProdBloc = ProviderBloc.datosProductos(context);
  final tallaProductoDatabase = TallaProductoDatabase();
//cambiar todos los estado de la tabla asignada a 0.
  await tallaProductoDatabase.updateEstadoa0();

  await tallaProductoDatabase.updateEstadoa1(tallaModel);

  datosProdBloc.listarDatosProducto(tallaModel.idProducto);
  return 1;
}

//Marca del producto
Future<int> cambiarEstadoMarca(
    BuildContext context, MarcaProductoModel marcaModel) async {
  final datosProdBloc = ProviderBloc.datosProductos(context);
  final marcaProductoDatabase = MarcaProductoDatabase();
//cambiar todos los estado de la tabla asignada a 0.
  await marcaProductoDatabase.updateEstadoa0();

  await marcaProductoDatabase.updateEstadoa1(marcaModel);

  datosProdBloc.listarDatosProducto(marcaModel.idProducto);

  return 1;
}

//Modelo del producto
Future<int> cambiarEstadoModelo(
    BuildContext context, ModeloProductoModel modeloModel) async {
  final datosProdBloc = ProviderBloc.datosProductos(context);
  final modeloProductoDatabase = ModeloProductoDatabase();

//cambiar todos los estado de la tabla asignada a 0.
  await modeloProductoDatabase.updateEstadoa0();

  await modeloProductoDatabase.updateEstadoa1(modeloModel);

  datosProdBloc.listarDatosProducto(modeloModel.idProducto);
  return 0;
}

obtenerNombreMes(String date) {
  /* var meses = {
    '01': 'Ene',
    '02': 'Feb',
    '03': 'Mar',
    '04': 'Abr',
    '05': 'May',
    '06': 'Jun',
    '07': 'Jul',
    '08': 'Ago',
    '09': 'Set',
    '10': 'Oct',
    '11': 'Nov',
    '12': 'Dic'
  };*/
  var fecha = DateTime.parse(date);
  final DateFormat formatter = new DateFormat('dd-MMM-yyyy, H:m');
  String formatted = formatter.format(fecha);

  return formatted;
}
