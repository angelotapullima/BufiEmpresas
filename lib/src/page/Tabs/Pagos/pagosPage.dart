import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/PagosModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/colores.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:bufi_empresas/src/widgets/translate_animation.dart';
import 'package:bufi_empresas/src/widgets/widget_SeleccionarSucursal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:shimmer/shimmer.dart';

class PagosPage extends StatelessWidget {
  const PagosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();
    return Scaffold(
      body: Stack(
        children: [
          _backgroundSucursales(context, responsive),
          TranslateAnimation(
            duration: const Duration(milliseconds: 400),
            child: _contenido(responsive, preferences, context),
          ),
        ],
      ),
    );
  }

  Widget _backgroundSucursales(BuildContext context, Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(
        top: responsive.hp(5),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            height: responsive.hp(18),
            child: ListarSucursales(),
          ),
        ],
      ),
    );
  }

  Widget _contenido(
      Responsive responsive, Preferences preferences, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: responsive.hp(22),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 19,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
            color: Colors.white),
        child: Container(
          margin: EdgeInsets.only(top: responsive.hp(1)),
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(height: responsive.hp(1)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                height: responsive.hp(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      height: responsive.hp(8),
                      width: responsive.wp(45),
                      child: ObtenerFecha1(),
                    ),
                    SizedBox(
                      width: responsive.wp(4),
                    ),
                    Container(
                      color: Colors.white,
                      height: responsive.hp(8),
                      width: responsive.wp(45),
                      child: ObtenerFecha2(),
                    ),
                  ],
                ),
              ),
              Container(
                height: responsive.hp(5),
                width: responsive.wp(95),
                child: _botonBuscar(context, responsive),
              ),
              SizedBox(height: responsive.hp(1)),
              Container(
                width: double.infinity,
                height: responsive.hp(3.5),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: responsive.wp(3),
                    ),
                    Text(
                      'Mis Pagos',
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListarPagosPorIdSubsidiaryAndFecha(
                  idSucursal: preferences.idSeleccionSubsidiaryPedidos,
                  fechaI: preferences.fechaI,
                  fechaF: preferences.fechaF,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonBuscar(BuildContext context, Responsive responsive) {
    return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        //padding: EdgeInsets.all(0.0),
        child: Text(
          'Buscar',
          style: TextStyle(
            fontSize: responsive.ip(1.9),
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Colors.redAccent,
        textColor: Colors.white,
        onPressed: () {
          final pagosBloc = ProviderBloc.pagos(context);
          final prefs = Preferences();
          if (prefs.fechaI != '' && prefs.fechaF != '') {
            if (DateTime.parse(prefs.fechaI)
                    .isBefore(DateTime.parse(prefs.fechaF)) ||
                DateTime.parse(prefs.fechaI) == DateTime.parse(prefs.fechaF)) {
              pagosBloc.obtenerPagosXFecha(prefs.idSeleccionSubsidiaryPedidos,
                  prefs.fechaI, prefs.fechaF);
            } else {
              showToast1('Fecha Fin debe ser mayor que fecha Inicio', 3,
                  ToastGravity.CENTER);
            }
          } else {
            showToast1(
                'Seleccione un rango de fechas valido', 3, ToastGravity.CENTER);
          }
        }
        //(snapshot.hasData) ? () => _submit(context, bloc) : null,
        );
  }
}

class ObtenerFecha1 extends StatefulWidget {
  ObtenerFecha1({Key key}) : super(key: key);

  @override
  _ObtenerFechaState1 createState() => _ObtenerFechaState1();
}

class _ObtenerFechaState1 extends State<ObtenerFecha1> {
  TextEditingController inputfieldDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextEditingController inputfieldDateController2 = TextEditingController();
    final preferences = Preferences();
    return TextField(
      decoration: InputDecoration(
        fillColor: Colors.white,
        labelText: 'Fecha Inicio',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      enableInteractiveSelection: true,
      controller: (preferences.fechaI != '')
          ? inputfieldDateController
          : inputfieldDateController2,
      onTap: () {
        FocusScope.of(context).requestFocus(
          new FocusNode(),
        );
        _selectdate(context, inputfieldDateController, preferences.fechaI);
      },
    );
  }

  _selectdate(BuildContext context,
      TextEditingController inputfieldDateController, String _fecha) async {
    DateTime picked = await PlatformDatePicker.showDate(
      context: context,
      backgroundColor: Colors.white,
      firstDate: DateTime(DateTime.now().year - 2),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      /* print('no se por que se muestra ${picked.year}-${picked.month}-${picked.day}');
      String dia = ''; */

      setState(() {
        _fecha =
            "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        inputfieldDateController.text = _fecha;
        final preferences = Preferences();
        preferences.fechaI = _fecha;
      });
    }
  }
}

class ObtenerFecha2 extends StatefulWidget {
  ObtenerFecha2({Key key}) : super(key: key);

  @override
  _ObtenerFechaState2 createState() => _ObtenerFechaState2();
}

class _ObtenerFechaState2 extends State<ObtenerFecha2> {
  TextEditingController inputfieldDateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    TextEditingController inputfieldDateController2 = TextEditingController();
    return TextField(
      decoration: InputDecoration(
        fillColor: Colors.white,
        labelText: 'Fecha Fin',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      enableInteractiveSelection: false,
      controller: (preferences.fechaF != '')
          ? inputfieldDateController
          : inputfieldDateController2,
      onTap: () {
        FocusScope.of(context).requestFocus(
          new FocusNode(),
        );
        _selectdate(context, inputfieldDateController, preferences.fechaF);
      },
    );
  }

  _selectdate(BuildContext context,
      TextEditingController inputfieldDateController, String _fecha) async {
    DateTime picked = await PlatformDatePicker.showDate(
      context: context,
      backgroundColor: Colors.white,
      firstDate: DateTime(DateTime.now().year - 2),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      /* print('no se por que se muestra ${picked.year}-${picked.month}-${picked.day}');
      String dia = ''; */

      setState(() {
        _fecha =
            "${picked.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        inputfieldDateController.text = _fecha;
        final preferences = Preferences();
        preferences.fechaF = _fecha;
      });
    }
  }
}

class ListarPagosPorIdSubsidiaryAndFecha extends StatefulWidget {
  final String idSucursal;
  final String fechaI;
  final String fechaF;
  const ListarPagosPorIdSubsidiaryAndFecha(
      {Key key,
      @required this.idSucursal,
      @required this.fechaI,
      @required this.fechaF})
      : super(key: key);
  @override
  _ListarPagosPorIdSubsidiaryAndFecha createState() =>
      _ListarPagosPorIdSubsidiaryAndFecha();
}

class _ListarPagosPorIdSubsidiaryAndFecha
    extends State<ListarPagosPorIdSubsidiaryAndFecha> {
  ValueNotifier<bool> switchFiltro = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final pagosBloc = ProviderBloc.pagos(context);
    pagosBloc.obtenerPagosXFecha(
        widget.idSucursal, widget.fechaI, widget.fechaF);
    final responsive = Responsive.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
      child: StreamBuilder(
        stream: pagosBloc.cargandoItemsStream,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              bool _enabled = true;
              return Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        enabled: _enabled,
                        child: ListView.builder(
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          itemCount: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ValueListenableBuilder(
                  valueListenable: switchFiltro,
                  builder: (BuildContext context, bool data, Widget child) {
                    return Column(
                      children: [
                        StreamBuilder(
                            stream: pagosBloc.pagosStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.length > 0) {
                                } else {
                                  return Center(
                                      child: Text("No hay pagos para mostrar"));
                                }
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return _crearItem(context,
                                          snapshot.data[index], responsive);
                                    }),
                              );
                            }),
                      ],
                    );
                  });
            }
          } else {
            return Center(
              child: NutsActivityIndicator(
                radius: 12,
                activeColor: Colors.white,
                inactiveColor: Colors.redAccent,
                tickCount: 11,
                startRatio: 0.55,
                animationDuration: Duration(milliseconds: 2003),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _crearItem(
      BuildContext context, PagosModel pagosData, Responsive responsive) {
    var date = obtenerNombreMes(pagosData.transferenciaUEDate);
    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, "detalleNegocio", arguments: servicioData);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(2, 3),
            ),
          ],
        ),
        margin: EdgeInsets.all(responsive.ip(1)),
        height: responsive.hp(13),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(responsive.ip(1)),
              width: responsive.wp(60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Pago N° ${pagosData.idPago}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.2),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                      'Transferencia N° ${pagosData.transferenciaUENroOperacion}'),
                  Text('$date'),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(responsive.ip(1)),
              child: Text(
                'S/. ${pagosData.transferenciaUEMonto}',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: responsive.ip(2.5),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
