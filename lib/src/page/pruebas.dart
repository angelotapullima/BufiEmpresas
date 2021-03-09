import 'package:bufi_empresas/src/api/configuracion_api.dart';
import 'package:flutter/material.dart';

class PuebasPage extends StatefulWidget {
  PuebasPage({Key key}) : super(key: key);

  @override
  _PuebasPageState createState() => _PuebasPageState();
}

class _PuebasPageState extends State<PuebasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text('Hola'),
        ),
      ),
    );
  }
}
