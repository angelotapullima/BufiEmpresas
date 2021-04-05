import 'package:bufi_empresas/src/bloc/pantalla_inicio_bloc.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class PuebasPage extends StatefulWidget {
  PuebasPage({Key key}) : super(key: key);

  @override
  _PuebasPageState createState() => _PuebasPageState();
}

class _PuebasPageState extends State<PuebasPage> {
  TextEditingController inputfieldDateController = TextEditingController();
  final responsive = Responsive();
  @override
  Widget build(BuildContext context) {
    final negociosBloc = ProviderBloc.negocios(context);
    negociosBloc.obtenernegocios();
    final prefs = Preferences();
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: _categoria(negociosBloc, prefs.idSeleccionNegocioInicio),
        ),
      ),
    );
  }

  Widget _categoria(PantallaInicioBloc bloc, String id) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 2.0, left: 40.0, right: 40.0),
        child: Row(
          children: <Widget>[
            Text('Negocio'),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: bloc.negociosStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CompanyModel>> snapshot) {
                    if (snapshot.hasData) {
                      final cat = snapshot.data;
                      return DropdownButton(
                        value: id,
                        items: cat.map((e) {
                          return DropdownMenuItem<String>(
                            value: e.idCompany,
                            child: Text(
                              e.companyName,
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          id = value;
                          final prefs = Preferences();
                          prefs.idSeleccionNegocioInicio = id;
                          print(id);
                          this.setState(() {});
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ));
  }
}
