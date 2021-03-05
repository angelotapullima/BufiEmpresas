import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/page/elegirNegocio_page.dart';
import 'package:bufi_empresas/src/page/home.dart';
import 'package:bufi_empresas/src/page/login_page.dart';
import 'package:bufi_empresas/src/page/splash.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/theme/theme.dart';
import 'package:flutter/material.dart';

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
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: lightTheme, //darkTheme,
          //themeMode: ThemeMode.system,
          home: Splash(),
          //initialRoute:(prefs.idUser=="" || prefs.idUser==null)?'login':'home',
          routes: {
            "login": (BuildContext context) => LoginPage(),
            "home": (BuildContext context) => HomePage(),
            "elegirNegocio": (BuildContext context) => ElegirNegocioPage(),
            //"splash": (BuildContext context) => Splash(),
          }),
    );
  }
}
