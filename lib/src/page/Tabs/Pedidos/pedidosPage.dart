import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/PedidosModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final preferences = Preferences();
    return Scaffold(
      body: SafeArea(
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
              height: responsive.hp(6.5),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      actualizarIdStatus(context, '3');
                      print(preferences.idStatusPedidos);
                      final pedidosBloc = ProviderBloc.pedido(context);
                      pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
                          preferences.idSeleccionSubsidiaryPedidos,
                          preferences.idStatusPedidos);
                    },
                    child: Container(
                      width: responsive.wp(26),
                      child: Card(
                        elevation: 2,
                        color: (preferences.idStatusPedidos == '3')
                            ? Colors.red
                            : Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(2)),
                          child: Text(
                            'En Envío',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      actualizarIdStatus(context, '4');
                      print(preferences.idStatusPedidos);
                      final pedidosBloc = ProviderBloc.pedido(context);
                      pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
                          preferences.idSeleccionSubsidiaryPedidos,
                          preferences.idStatusPedidos);
                    },
                    child: Container(
                      width: responsive.wp(26),
                      child: Card(
                        elevation: 2,
                        color: (preferences.idStatusPedidos == '4')
                            ? Colors.red
                            : Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(2)),
                          child: Text(
                            'Aceptado',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      actualizarIdStatus(context, '5');
                      print(preferences.idStatusPedidos);
                      final pedidosBloc = ProviderBloc.pedido(context);
                      pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
                          preferences.idSeleccionSubsidiaryPedidos,
                          preferences.idStatusPedidos);
                    },
                    child: Container(
                      width: responsive.wp(26),
                      child: Card(
                        elevation: 2,
                        color: (preferences.idStatusPedidos == '5')
                            ? Colors.red
                            : Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(2)),
                          child: Text(
                            'Cancelado',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
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
            )
          ],
        ),
      ),
    );
  }
}

class ListarSucursales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sucursalesBloc = ProviderBloc.negocios(context);
    final preferences = Preferences();
    sucursalesBloc.obtenersucursales(preferences.idSeleccionNegocioInicio);
    final responsive = Responsive.of(context);

    return Column(
      children: [
        Container(
          height: responsive.hp(8),
          child: StreamBuilder(
            //stream: negociosBloc.negociosStream,
            stream: sucursalesBloc.suscursaStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<SubsidiaryModel>> snapshot) {
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
                  return Center(child: Text("No tiene Sucursales"));
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

  Widget _crearItem(BuildContext context, SubsidiaryModel servicioData,
      Responsive responsive) {
    return GestureDetector(
      onTap: () {
        actualizarEstadoSucursal(context, servicioData.idSubsidiary);
        final preferences = new Preferences();
        preferences.idSeleccionSubsidiaryPedidos = servicioData.idSubsidiary;
        print(preferences.idSeleccionSubsidiaryPedidos);
        final pedidosBloc = ProviderBloc.pedido(context);
        pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
            preferences.idSeleccionSubsidiaryPedidos,
            preferences.idStatusPedidos);
        //Navigator.pushNamed(context, "detalleNegocio", arguments: servicioData);
      },
      child: Container(
        width: responsive.wp(22.5),
        child: Card(
          elevation: 2,
          color: (servicioData.subsidiaryStatusPedidos == '1')
              ? Colors.red
              : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            child: Text(
              '${servicioData.subsidiaryName}',
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}