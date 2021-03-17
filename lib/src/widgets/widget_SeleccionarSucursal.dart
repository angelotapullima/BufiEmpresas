import 'dart:math';

import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:flutter/material.dart';

class ListarSucursales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _pageController =
        PageController(viewportFraction: 0.4, initialPage: 0);
    final sucursalesBloc = ProviderBloc.negocios(context);
    final preferences = Preferences();
    sucursalesBloc.obtenersucursales(preferences.idSeleccionNegocioInicio);
    final responsive = Responsive.of(context);
    final contadorBloc = ProviderBloc.contadorListaSucursales(context);
    contadorBloc.changeContador(0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mis Sucursales',
              style: TextStyle(
                  fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          height: responsive.hp(8),
          child: StreamBuilder(
            //stream: negociosBloc.negociosStream,
            stream: sucursalesBloc.suscursaStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<SubsidiaryModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return PageView.builder(
                      itemCount: snapshot.data.length,
                      controller: _pageController,
                      itemBuilder: (BuildContext context, int index) {
                        return _crearItem(
                            context, snapshot.data[index], responsive);
                      },
                      onPageChanged: (int index) {
                        contadorBloc.changeContador(index);
                        actualizarEstadoSucursal(
                            context, snapshot.data[index].idSubsidiary);
                        final preferences = new Preferences();
                        preferences.idSeleccionSubsidiaryPedidos =
                            snapshot.data[index].idSubsidiary;
                        final pedidosBloc = ProviderBloc.pedido(context);
                        pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
                            preferences.idSeleccionSubsidiaryPedidos,
                            preferences.idStatusPedidos);
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
        Container(
          height: responsive.hp(5),
          child: StreamBuilder(
            stream: sucursalesBloc.suscursaStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          snapshot.data.length, (index) => _Puntos(index)));
                } else {
                  return Center(child: Text('No tiene Negocios'));
                }
              } else {
                return Center(child: CircularProgressIndicator());
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
        //Navigator.pushNamed(context, "detalleNegocio", arguments: servicioData);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
          /*Colors.primaries[Random().nextInt(Colors.primaries.length)]*/,
          boxShadow: [
            BoxShadow(
              color: (servicioData.subsidiaryStatusPedidos == '1')
                  ? Colors.redAccent
                  : Colors.grey.withOpacity(0.5),
              spreadRadius:
                  (servicioData.subsidiaryStatusPedidos == '1') ? 4 : 1,
              blurRadius: (servicioData.subsidiaryStatusPedidos == '1') ? 4 : 2,
              offset: (servicioData.subsidiaryStatusPedidos == '1')
                  ? Offset(0, 0)
                  : Offset(2, 3),
            ),
          ],
        ),
        margin: EdgeInsets.all(responsive.ip(1)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
          child: Text(
            '${servicioData.subsidiaryName}',
            style: TextStyle(
              fontSize: responsive.ip(2),
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _Puntos extends StatelessWidget {
  final int index;
  _Puntos(this.index);
  @override
  Widget build(BuildContext context) {
    final contadorBloc = ProviderBloc.contadorListaSucursales(context);

    return Container(
      width: 10,
      height: 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: (contadorBloc.pageContador >= index - 0.5 &&
                contadorBloc.pageContador < index + 0.5)
            ? Colors.redAccent
            : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
