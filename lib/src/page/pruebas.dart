import 'package:bufi_empresas/src/api/configuracion_api.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: _crearFecha(context, responsive),
        ),
      ),
    );
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
