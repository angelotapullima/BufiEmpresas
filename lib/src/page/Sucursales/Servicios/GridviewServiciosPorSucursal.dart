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
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                        onTap: () {},
                        child: serviceWidget(
                            context,
                            snapshot.data[index],
                            responsive,
                            (snapshot.data[index].subsidiaryServiceStatus ==
                                    '1')
                                ? true
                                : false));
                  },
                  childCount: snapshot.data.length,
                ),
              );
            } else {
              return SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
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
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
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
              ]));
            }
          } else {
            return SliverList(
                delegate: SliverChildListDelegate([
              Padding(
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
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
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
            ]));
          }
        });
  }
}
