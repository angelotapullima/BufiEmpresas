import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/bloc/Sucursal/detalleSubisidiaryBloc.dart';
import 'package:bufi_empresas/src/page/Negocio/detalleNegocio.dart';
import 'package:bufi_empresas/src/page/Tabs/cuenta/perfilPage.dart';
import 'package:bufi_empresas/src/page/home.dart';
import 'package:bufi_empresas/src/page/login_page.dart';
import 'package:bufi_empresas/src/page/pruebas.dart';
import 'package:bufi_empresas/src/page/splash.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new Preferences();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderBloc(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<DetailSubsidiaryBloc>(
            create: (_) => DetailSubsidiaryBloc(),
          ),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              //const Locale('en', ''), // English, no country code
              const Locale('es', ''), // Spanish, no country code
            ],
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: lightTheme, //darkTheme,
            //themeMode: ThemeMode.system,
            home: Splash(),
            //initialRoute: 'pruebas',
            routes: {
              "login": (BuildContext context) => LoginPage(),
              "home": (BuildContext context) => HomePage(),
              "pruebas": (BuildContext context) => PuebasPage(),
              //"splash": (BuildContext context) => Splash(),

              //Mi Perfil
              'perfil': (BuildContext context) => PerfilPage(),
              //Detalle Negocio
              "detalleNegocio": (BuildContext context) => DetalleNegocio(),

              // Detalle Sucursal
            }),
      ),
    );
  }
}
