import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:flutter/material.dart';

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
