import 'dart:async';

import 'package:bufi_empresas/src/widgets/widgetBienes.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/productoModel.dart';
import 'package:bufi_empresas/src/page/Sucursales/Productos/detalleProducto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class GridviewProductoPorSucursal extends StatefulWidget {
  final String idSucursal;
  const GridviewProductoPorSucursal({Key key, @required this.idSucursal})
      : super(key: key);

  @override
  _GridviewProductoPorSucursalState createState() =>
      _GridviewProductoPorSucursalState();
}

class _GridviewProductoPorSucursalState
    extends State<GridviewProductoPorSucursal>
    with SingleTickerProviderStateMixin<GridviewProductoPorSucursal> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 100);

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();

    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursal(widget.idSucursal);
    return StreamBuilder(
        stream: productoBloc.productoStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return SafeArea(
                top: false,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: snapshot.data.length,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 100),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              print(snapshot.data[index].productoStatus);
                              return DetalleProductos(
                                  snapshot.data[index],
                                  (snapshot.data[index].productoStatus == '1')
                                      ? true
                                      : false,
                                  (snapshot.data[index].productoStock == '1')
                                      ? true
                                      : false);
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: BienesWidget(
                        producto: snapshot.data[index],
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Text('Sin productos'),
              );
            }
          } else {
            return Center(
              child: Text(''),
            );
          }
        });
  }
}
