import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
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
            ListarSucursales()
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
          height: responsive.hp(16),
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

  Widget _crearItem(BuildContext context, SubsidiaryModel servicioData,
      Responsive responsive) {
    return GestureDetector(
      onTap: () {
        print("Boton");
        actualizarEstadoSucursal(context, servicioData.idSubsidiary);
        //Navigator.pushNamed(context, "detalleNegocio", arguments: servicioData);
      },
      child: Container(
        width: responsive.wp(42.5),
        child: Card(
          elevation: 2,
          color: (servicioData.subsidiaryStatusPedidos == '1')
              ? Colors.red
              : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${servicioData.subsidiaryName}',
                  style: TextStyle(
                    fontSize: responsive.ip(2),
                    color: Colors.black,
                  ),
                ),
                Text(
                  servicioData.idSubsidiary,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(1.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
