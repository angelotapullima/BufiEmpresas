import 'package:bufi_empresas/src/bloc/ContadorPages/contadorPaginaListNegocio_bloc.dart';
import 'package:bufi_empresas/src/bloc/ContadorPages/contadorPaginaListarSucursales.dart';
import 'package:bufi_empresas/src/bloc/config_bloc.dart';
import 'package:bufi_empresas/src/bloc/login_bloc.dart';
import 'package:bufi_empresas/src/bloc/Tab_home_bloc.dart';
import 'package:bufi_empresas/src/bloc/pagos_bloc.dart';
import 'package:bufi_empresas/src/bloc/pantalla_inicio_bloc.dart';
import 'package:bufi_empresas/src/bloc/pedido_bloc.dart';
import 'package:bufi_empresas/src/bloc/producto/datosProductoBloc.dart';
import 'package:bufi_empresas/src/bloc/producto/producto_bloc.dart';
import 'package:bufi_empresas/src/bloc/restablecerPassword_bloc.dart';
import 'package:bufi_empresas/src/bloc/sucursal_bloc.dart';
import 'package:bufi_empresas/src/bloc/tiposEstadosPedidos_bloc.dart';
import 'package:bufi_empresas/src/bloc/servicios/servicios_bloc.dart';
import 'package:flutter/material.dart';

class ProviderBloc extends InheritedWidget {
  static ProviderBloc _instancia;

  final loginBloc = LoginBloc();
  final restaPasswdBloc = RestablecerPasswordBloc();
  final negociosBloc = PantallaInicioBloc();
  final tabsNavigationbloc = TabNavigationBloc();
  final pedidosBloc = PedidoBloc();
  final tipoEstadoPedidosBloc = TiposEstadosPedidosBloc();
  final pagosBloc = PagosBloc();
  final contadorBloc = ContadorPaginaNegocioBloc();
  final contadorSucursalesBloc = ContadorPaginaListarSucursalesBloc();
  final productosBloc = ProductoBloc();
  final datosProductosBloc = DatosProductoBloc();
  final serviciosBloc = ServiciosBloc();
  final sucursalbloc = SucursalBloc();
  final configBloc = ConfigBloc();

  factory ProviderBloc({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new ProviderBloc._internal(key: key, child: child);
    }

    return _instancia;
  }

  ProviderBloc._internal({Key key, Widget child})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(ProviderBloc oldWidget) => true;

  // Regresa el estado actual del widgetbloc
  static LoginBloc login(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .loginBloc;
  }

  //Restablecer Contraseña Bloc
  static RestablecerPasswordBloc restabContra(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .restaPasswdBloc;
  }

  //tab
  static TabNavigationBloc tabs(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .tabsNavigationbloc;
  }

  //Negocios
  static PantallaInicioBloc negocios(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .negociosBloc;
  }

  //Pedidos
  static PedidoBloc pedido(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .pedidosBloc;
  }

  //Estado Pedidos
  static TiposEstadosPedidosBloc tipoEstadoPedidos(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .tipoEstadoPedidosBloc;
  }

  //Pagos
  static PagosBloc pagos(BuildContext contex) {
    return (contex.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .pagosBloc;
  }

  //Contador Pagina Negocio
  static ContadorPaginaNegocioBloc contadorPagina(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .contadorBloc;
  }

  //Contador Pagina Pedidos Listar Sucursales
  static ContadorPaginaListarSucursalesBloc contadorListaSucursales(
      BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .contadorSucursalesBloc;
  }

  //Productos
  static ProductoBloc productos(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .productosBloc;
  }

  //datos de Productos
  static DatosProductoBloc datosProductos(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .datosProductosBloc;
  }

  //Servicios

  static ServiciosBloc servi(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .serviciosBloc;
  }

  //Sucursales
  static SucursalBloc sucursal(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .sucursalbloc;
  }

  //Config Obtner Nombre de la empresa
  static ConfigBloc nameEmpresa(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())
        .configBloc;
  }
}
