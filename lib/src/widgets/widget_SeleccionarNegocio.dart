import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:flutter/material.dart';

class SeleccionarNegocio extends StatefulWidget {
  SeleccionarNegocio({Key key}) : super(key: key);

  @override
  _SeleccionarNegocioState createState() => _SeleccionarNegocioState();
}

class _SeleccionarNegocioState extends State<SeleccionarNegocio> {
  @override
  Widget build(BuildContext context) {
    final prefs = Preferences();
    final negociosBloc = ProviderBloc.negocios(context);
    negociosBloc.obtenernegocios();
    return Row(
      children: <Widget>[
        Text('Negocio'),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: StreamBuilder(
              stream: negociosBloc.negociosStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<CompanyModel>> snapshot) {
                if (snapshot.hasData) {
                  final cat = snapshot.data;
                  return DropdownButton(
                    value: prefs.idSeleccionNegocioInicio,
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
                      prefs.idSeleccionNegocioInicio = value;
                      obtenerprimerIdSubsidiary(prefs.idSeleccionNegocioInicio);
                      prefs.idStatusPedidos = '99';
                      actualizarIdStatusPedidos(context, prefs.idStatusPedidos);
                      Navigator.pushReplacementNamed(context, "home");
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
    );
  }
}
