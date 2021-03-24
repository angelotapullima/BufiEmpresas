import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/PedidosModel.dart';
import 'package:bufi_empresas/src/models/tipoEstadoPedidoModel.dart';
import 'package:bufi_empresas/src/page/Tabs/Pedidos/detallePedidoPage.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:bufi_empresas/src/widgets/translate_animation.dart';
import 'package:bufi_empresas/src/widgets/widget_SeleccionarSucursal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shimmer/shimmer.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();
    return Scaffold(
      body: Stack(
        children: [
          _backgroundSucursales(responsive),
          TranslateAnimation(
            duration: const Duration(milliseconds: 400),
            child: _contenido(responsive, preferences),
          )
        ],
      ),
    );
  }

  Widget _backgroundSucursales(Responsive responsive) {
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

  Widget _contenido(Responsive responsive, Preferences preferences) {
    return Container(
      margin: EdgeInsets.only(top: responsive.hp(22)),
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
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
              height: responsive.hp(10),
              child: ListarTiposEstadosPedidos(),
            ),
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
                    'Mis pedidos',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListarPedidosPorIdSubsidiary(
                idSucursal: preferences.idSeleccionSubsidiaryPedidos,
                idStatus: preferences.idStatusPedidos,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListarTiposEstadosPedidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tipoEstadoPedidos = ProviderBloc.tipoEstadoPedidos(context);
    tipoEstadoPedidos.obtenerTiposEstadosPedidos();
    final responsive = Responsive.of(context);

    return Column(
      children: [
        Container(
          height: responsive.hp(9),
          child: StreamBuilder(
            //stream: negociosBloc.negociosStream,
            stream: tipoEstadoPedidos.tiposEstadosPedidosStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<TipoEstadoPedidoModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return _crearItem(
                            context, snapshot.data[index], responsive);
                      });
                } else {
                  return Center(child: Text("Lista Vacia"));
                }
              } else {
                return Center(child: Text("Lista Nula"));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _crearItem(BuildContext context, TipoEstadoPedidoModel tipoEstadodata,
      Responsive responsive) {
    return GestureDetector(
      onTap: () {
        actualizarIdStatusPedidos(context, tipoEstadodata.idTipoEstado);
        final preferences = new Preferences();
        preferences.idStatusPedidos = tipoEstadodata.idTipoEstado;

        final pedidosBloc = ProviderBloc.pedido(context);
        pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
            preferences.idSeleccionSubsidiaryPedidos,
            tipoEstadodata.idTipoEstado);
        //Navigator.pushNamed(context, "detalleNegocio", arguments: servicioData);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: (tipoEstadodata.tipoEstadoSelect == '1')
              ? Colors.redAccent
              : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(2, 3),
            ),
          ],
        ),
        margin: EdgeInsets.all(responsive.ip(1)),
        width: responsive.wp(30),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(1)),
          child: Text(
            '${tipoEstadodata.tipoEstadoNombre}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: responsive.ip(2),
              fontWeight: (tipoEstadodata.tipoEstadoSelect == '1')
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: (tipoEstadodata.tipoEstadoSelect == '1')
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class ListarPedidosPorIdSubsidiary extends StatefulWidget {
  final String idSucursal;
  final String idStatus;
  const ListarPedidosPorIdSubsidiary(
      {Key key, @required this.idSucursal, @required this.idStatus})
      : super(key: key);
  @override
  _ListarPedidosPorIdSubsidiaryState createState() =>
      _ListarPedidosPorIdSubsidiaryState();
}

class _ListarPedidosPorIdSubsidiaryState
    extends State<ListarPedidosPorIdSubsidiary> {
  ValueNotifier<bool> switchFiltro = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final pedidosBloc = ProviderBloc.pedido(context);
    pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
        widget.idSucursal, widget.idStatus);
    final responsive = Responsive.of(context);
    final preferences = new Preferences();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
      child: StreamBuilder(
        stream: pedidosBloc.cargandoItemsStream,
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
                            stream: pedidosBloc.pedidoStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.length > 0) {
                                } else {
                                  return Center(
                                      child:
                                          Text("No hay pedidos para mostrar"));
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
                                      return _crearItem(
                                        context,
                                        snapshot.data[index],
                                        responsive,
                                        preferences.idStatusPedidos,
                                      );
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
    BuildContext context,
    PedidosModel pedidosData,
    Responsive responsive,
    String idStatus,
    /*TipoEstadoPedidoModel tipoEstadodata*/
  ) {
    var date = obtenerNombreMes(pedidosData.deliveryDatetime);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return TickectPedido(
              idPedido: pedidosData.idPedido,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(2, 3),
            ),
          ],
        ),
        margin: EdgeInsets.all(responsive.ip(1)),
        height: responsive.hp(15),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(responsive.ip(1)),
              width: responsive.wp(60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Pedido N° ${pedidosData.idPedido}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.1),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text('${pedidosData.deliveryName}'),
                  Text('${pedidosData.deliveryAddress}'),
                  Text('$date'),
                ],
              ),
            ),
            Container(
              child: (idStatus == '99')
                  ? Column(
                      children: [
                        Text(''),
                        Text(
                          'S/. ${pedidosData.deliveryTotalOrden}',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Text(
                      'S/. ${pedidosData.deliveryTotalOrden}',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: responsive.ip(2),
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
