import 'package:bufi_empresas/src/bloc/login_bloc.dart';
import 'package:bufi_empresas/src/bloc/Tab_home_bloc.dart';
import 'package:bufi_empresas/src/bloc/pantalla_inicio_bloc.dart';
import 'package:flutter/material.dart';

class ProviderBloc extends InheritedWidget {
  static ProviderBloc _instancia;

  final loginBloc = LoginBloc();
  final negociosBloc = PantallaInicioBloc();
  final tabsNavigationbloc = TabNavigationBloc();

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
}
