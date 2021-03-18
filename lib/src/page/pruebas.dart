import 'package:bufi_empresas/src/bloc/pantalla_inicio_bloc.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:platform_date_picker/platform_date_picker.dart';

class PuebasPage extends StatefulWidget {
  PuebasPage({Key key}) : super(key: key);

  @override
  _PuebasPageState createState() => _PuebasPageState();
}

class _PuebasPageState extends State<PuebasPage> {
  TextEditingController inputfieldDateController = TextEditingController();
  String _fecha = '';
  final responsive = Responsive();
  @override
  Widget build(BuildContext context) {
    final negociosBloc = ProviderBloc.negocios(context);
    negociosBloc.obtenernegocios();
    final prefs = Preferences();
    final responsive = Responsive.of(context);
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

  Widget _crearFecha(BuildContext context, Responsive responsive) {
    return TextField(
      decoration: InputDecoration(
        //hintStyle: form2,
        hintText: 'Fecha Inicio',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      enableInteractiveSelection: false,
      controller: inputfieldDateController,
      onTap: () {
        FocusScope.of(context).requestFocus(
          new FocusNode(),
        );
        _selectdate(context);
      },
    );
  }

  _selectdate(BuildContext context) async {
    DateTime picked = await PlatformDatePicker.showDate(
      context: context,
      backgroundColor: Colors.white,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    print('date $picked');
    if (picked != null) {
      /* print('no se por que se muestra ${picked.year}-${picked.month}-${picked.day}');
      String dia = ''; */

      setState(() {
        _fecha =
            "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        inputfieldDateController.text = _fecha;

        print(_fecha);
      });
    }
  }
}
