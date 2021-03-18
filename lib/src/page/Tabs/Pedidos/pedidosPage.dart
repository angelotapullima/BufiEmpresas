import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/PedidosModel.dart';
import 'package:bufi_empresas/src/models/tipoEstadoPedidoModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:bufi_empresas/src/widgets/translate_animation.dart';
import 'package:bufi_empresas/src/widgets/widget_SeleccionarSucursal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();
    return Scaffold(
      body: Stack(
        children: [
          _backgroundNegocio(responsive),
          TranslateAnimation(
            duration: const Duration(milliseconds: 400),
            child: _contenido(responsive, preferences),
          )
        ],
      ),

      /*SafeArea(
        child: Column(
          children: [
            Text(
              'Sucursales',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: responsive.ip(2.5),
                  fontWeight: FontWeight.bold),
            ),
            Container(height: responsive.hp(10), child: ListarSucursales()),
            Container(
              height: responsive.hp(10),
              child: ListarTiposEstadosPedidos(),
            ),
            Expanded(
              child: ListarPedidosPorIdSubsidiary(
                idSucursal: preferences.idSeleccionSubsidiaryPedidos,
                idStatus: preferences.idStatusPedidos,
              ),
            )
          ],
        ),
      ),*/
    );
  }

  Widget _backgroundNegocio(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(
        top: responsive.hp(5),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            height: responsive.hp(17),
            child: ListarSucursales(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            height: responsive.hp(10),
            child: ListarTiposEstadosPedidos(),
          ),
        ],
      ),
    );
  }

  Widget _contenido(Responsive responsive, Preferences preferences) {
    return Container(
      margin: EdgeInsets.only(
        top: responsive.hp(5),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.65,
        builder: (context, scrollController) {
          return Container(
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
              child: SingleChildScrollView(
                controller: scrollController,
                child: ListarPedidosPorIdSubsidiary(
                  idSucursal: preferences.idSeleccionSubsidiaryPedidos,
                  idStatus: preferences.idStatusPedidos,
                ),
              ));
        },
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
          height: responsive.hp(10),
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
        width: responsive.wp(25),
        child: Card(
          elevation: 2,
          color: (tipoEstadodata.tipoEstadoSelect == '1')
              ? Colors.red
              : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            child: Text(
              '${tipoEstadodata.tipoEstadoNombre}',
              style: TextStyle(
                fontSize: responsive.ip(2),
                color: Colors.black,
              ),
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
  @override
  Widget build(BuildContext context) {
    final pedidosBloc = ProviderBloc.pedido(context);
    pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
        widget.idSucursal, widget.idStatus);
    final responsive = Responsive.of(context);

    return StreamBuilder(
      stream: pedidosBloc.pedidoStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Text('Pedidos');
                  }

                  int i = index - 1;
                  return _crearItem(context, snapshot.data[i], responsive);
                });
          } else {
            return Center(child: Text('No tiene Pedidos'));
          }
        } else {
          return Center(child: CupertinoActivityIndicator());
        }
      },
    );
  }

  Widget _crearItem(
      BuildContext context, PedidosModel pedidosData, Responsive responsive) {
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
              color: Colors.white.withOpacity(0.5),
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
              width: responsive.wp(53),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${pedidosData.deliveryStatus}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.3),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text('${pedidosData.deliveryName}'),
                  Text('${pedidosData.deliveryAddress}'),
                  Text('${pedidosData.idSubsidiary}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
