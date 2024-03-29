import 'dart:ui';
import 'package:bufi_empresas/src/models/productoModel.dart';
import 'package:bufi_empresas/src/page/Sucursales/Productos/editarProductoPage.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BienesWidget extends StatefulWidget {
  final ProductoModel producto;

  BienesWidget({
    Key key,
    @required this.producto,
  }) : super(key: key);
  @override
  _BienesWidgetState createState() => _BienesWidgetState();
}

class _BienesWidgetState extends State<BienesWidget> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.wp(1),
        vertical: responsive.hp(1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      width: responsive.wp(42.5),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: responsive.hp(18),
            child: Stack(
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Image(
                          image: AssetImage('assets/jar-loading.gif'),
                          fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl: '$apiBaseURL/${widget.producto.productoImage}',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.producto.productoName,
            style: TextStyle(
                fontSize: responsive.ip(2),
                color: Colors.grey[800],
                fontWeight: FontWeight.w700),
          ),
          Text(
              '${widget.producto.productoCurrency} ${widget.producto.productoPrice}',
              style: TextStyle(
                  fontSize: responsive.ip(2.3),
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          Text(
            widget.producto.productoBrand,
            style: TextStyle(
              color: Colors.grey,
              fontSize: responsive.ip(1.9),
            ),
          ),
          Center(
            child: Column(
              children: [
                Text(
                  (widget.producto.productoStatus == '1')
                      ? 'Habilitado'
                      : 'Deshabilitado',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: responsive.ip(2),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: responsive.wp(80),
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(3),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return EditarProductoPage(productoModel: widget.producto);
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
                child: Text("Editar Producto",
                    style: TextStyle(
                        color: Colors.white, fontSize: responsive.ip(2.2))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
