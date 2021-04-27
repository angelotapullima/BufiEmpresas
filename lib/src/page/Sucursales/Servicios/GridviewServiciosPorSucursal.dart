import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/subsidiaryService.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/widgets/widgetServicios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridviewServiciosPorSucursal extends StatefulWidget {
  final String idSucursal;
  const GridviewServiciosPorSucursal({
    Key key,
    @required this.idSucursal,
  }) : super(key: key);

  @override
  _GridviewProductoPorSucursalState createState() =>
      _GridviewProductoPorSucursalState();
}

class _GridviewProductoPorSucursalState
    extends State<GridviewServiciosPorSucursal> {
  @override
  Widget build(BuildContext context) {
    final serviciosBloc = ProviderBloc.servi(context);
    serviciosBloc.listarServiciosPorSucursal(widget.idSucursal);

    final responsive = Responsive.of(context);

    return StreamBuilder(
        stream: serviciosBloc.serviciostream,
        builder: (BuildContext context,
            AsyncSnapshot<List<SubsidiaryServiceModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {},
                      child: serviceWidget(
                          context,
                          snapshot.data[index],
                          responsive,
                          (snapshot.data[index].subsidiaryServiceStatus == '1')
                              ? true
                              : false));
                },
              );
            } else {
              return Center(
                child: Text("No cuenta con ningún servicio por el momento"),
              );
            }
          } else {
            return Center(
              child: Text(""),
            );
          }
        });
  }
}
