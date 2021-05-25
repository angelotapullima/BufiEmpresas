import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/database/marcaProducto_database.dart';
import 'package:bufi_empresas/src/database/modeloProducto_database.dart';
import 'package:bufi_empresas/src/database/tallaProducto_database.dart';
import 'package:bufi_empresas/src/models/productoModel.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:bufi_empresas/src/widgets/extentions.dart';
import 'package:bufi_empresas/src/widgets/translate_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:shimmer/shimmer.dart';

class DetalleProductos extends StatefulWidget {
  final ProductoModel producto;
  final bool estado;
  final bool stock;
  DetalleProductos(this.producto, this.estado, this.stock);

  @override
  _DetalleProductosState createState() => _DetalleProductosState();
}

class _DetalleProductosState extends State<DetalleProductos> {
  //int pagActual = 0;
  final tallaProductoDb = TallaProductoDatabase();
  final marcaProductoDb = MarcaProductoDatabase();
  final modeloProductoDb = ModeloProductoDatabase();

  bool isSwitched;
  bool isSwitched2;

  @override
  void initState() {
    isSwitched = widget.estado;
    isSwitched2 = widget.stock;
    limpiarOpciones();
    super.initState();
  }

  void limpiarOpciones() {
    tallaProductoDb.updateEstadoa0();
    marcaProductoDb.updateEstadoa0();
    modeloProductoDb.updateEstadoa0();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final datosProdBloc = ProviderBloc.datosProductos(context);
    datosProdBloc.listarDatosProducto(widget.producto.idProducto);

    Widget _icon(
      IconData icon, {
      Color color = LightColor.iconColor,
      double size,
      double padding = 10,
      bool isOutLine = false,
      Function onPressed,
    }) {
      return Container(
        height: responsive.ip(4),
        width: responsive.ip(4),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[300],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
          color: isOutLine ? Colors.white : Colors.white,
        ),
        child: Center(
          child: Icon(icon, color: color, size: size),
        ),
      ).ripple(
        () {
          if (onPressed != null) {
            onPressed();
          }
        },
        borderRadius: BorderRadius.all(
          Radius.circular(13),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder(
          stream: datosProdBloc.datosProdStream,
          builder: (context, AsyncSnapshot<List<ProductoModel>> listaGeneral) {
            List<ProductoModel> listProd = listaGeneral.data;

            bool _enabled = true;
            if (listaGeneral.hasData) {
              if (listProd.length > 0) {
                return Stack(
                  children: <Widget>[
                    _backgroundImage(context, responsive, listProd[0]),

                    // Iconos arriba de la imagen del producto
                    SafeArea(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: Row(
                          children: <Widget>[
                            //BackButton(),

                            SizedBox(
                              width: responsive.wp(5),
                            ),
                            _icon(
                              Icons.arrow_back_ios,
                              color: Colors.black54,
                              size: responsive.ip(1.7),
                              padding: responsive.ip(1.25),
                              isOutLine: true,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Spacer(),
                            GestureDetector(
                              child: Icon(Icons.arrow_right_outlined),
                              onTap: () {
                                final buttonBloc = ProviderBloc.tabs(context);
                                buttonBloc.changePage(2);
                              },
                            ),

                            SizedBox(
                              width: responsive.wp(5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TranslateAnimation(
                      duration: const Duration(milliseconds: 400),
                      child: _contenido(responsive, context, listProd[0]),
                    ),
                  ],
                );
              } else {
                return SafeArea(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: responsive.wp(5),
                          ),
                          BackButton(),
                          Spacer()
                        ],
                      ),
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
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0),
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
              }
            } else {
              return SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: responsive.wp(5),
                        ),
                        BackButton(),
                        Spacer()
                      ],
                    ),
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
            }
          }),
    );
  }

  Widget _backgroundImage(
      BuildContext context, Responsive responsive, ProductoModel producto) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.47,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                /*Navigator.pushNamed(context, 'detalleProductoFoto',
                          arguments: listProd[0]);*/
              },
              child: Hero(
                tag: '$apiBaseURL/${producto.productoImage}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    //cacheManager: CustomCacheManager(),

                    placeholder: (context, url) => Image(
                        image: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover),

                    errorWidget: (context, url, error) => Image(
                        image: AssetImage('assets/carga_fallida.jpg'),
                        fit: BoxFit.cover),

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
            ),
          )
        ],
      ),
    );
  }

  Widget _contenido(
      Responsive responsive, BuildContext context, ProductoModel producto) {
    return Container(
      margin: EdgeInsets.only(
        top: responsive.hp(21),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.7,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: LightColor.iconColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: responsive.wp(50),
                          child: TitleText(
                              text: "${producto.productoName}", fontSize: 25),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TitleText(
                                  text: "${producto.productoCurrency}",
                                  fontSize: 18,
                                  color: LightColor.red,
                                ),
                                TitleText(
                                  text: "${producto.productoPrice}",
                                  fontSize: 25,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: responsive.wp(30),
                                  child: RatingBar.readOnly(
                                    size: 20,
                                    initialRating:
                                        ('${producto.productoRating}' != null &&
                                                '${producto.productoRating}' !=
                                                    'null')
                                            ? double.parse(
                                                '${producto.productoRating}')
                                            : 0,
                                    isHalfAllowed: true,
                                    halfFilledIcon: Icons.star_half,
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                    filledColor: Colors.yellow,
                                  ),
                                ),
                                // Text(('${servicioData.subsidiaryStatus}' != null)
                                //     ? '${servicioData.listCompany.companyName}'
                                //     : ''),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Center(child: _swichtEstado(context, producto)),
                  Center(child: _swichtEstadoStock(context, producto)),
                  SizedBox(
                    height: responsive.hp(2),
                  ),
                  // Center(
                  //   child: SizedBox(
                  //     width: responsive.wp(80),
                  //     child: ElevatedButton(
                  //       style: ButtonStyle(
                  //         elevation: MaterialStateProperty.all(3),
                  //         shape: MaterialStateProperty.all(
                  //             RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(30.0))),
                  //         backgroundColor:
                  //             MaterialStateProperty.all(Colors.red),
                  //       ),
                  //       onPressed: () {
                  //         Navigator.of(context).push(PageRouteBuilder(
                  //           pageBuilder:
                  //               (context, animation, secondaryAnimation) {
                  //             return EditarProductoPage(
                  //                 productoModel: producto);
                  //           },
                  //           transitionsBuilder: (context, animation,
                  //               secondaryAnimation, child) {
                  //             var begin = Offset(0.0, 1.0);
                  //             var end = Offset.zero;
                  //             var curve = Curves.ease;

                  //             var tween = Tween(begin: begin, end: end).chain(
                  //               CurveTween(curve: curve),
                  //             );

                  //             return SlideTransition(
                  //               position: animation.drive(tween),
                  //               child: child,
                  //             );
                  //           },
                  //         ));
                  //       },
                  //       child: Text("Editar producto",
                  //           style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: responsive.ip(2.2))),
                  //     ),
                  //   ),
                  // ),
                  //_description(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _swichtEstado(BuildContext context, ProductoModel producto) {
    return SwitchListTile(
      value: isSwitched,
      title: (producto.productoStatus == '1')
          ? Text('Producto Habilitado')
          : Text('Producto Deshabilitado'),
      onChanged: (value) {
        setState(() {
          isSwitched = value;
          String estatus = '0';
          if (value) {
            estatus = '1';
          }
          habilitarDesProducto(context, producto.idProducto, estatus);
        });
      },
      activeTrackColor: Colors.yellow,
      activeColor: Colors.orangeAccent,
    );
  }

  Widget _swichtEstadoStock(BuildContext context, ProductoModel producto) {
    return SwitchListTile(
      value: isSwitched2,
      title: (producto.productoStockStatus == '1')
          ? Text('Stock Habilitado')
          : Text('Stock Deshabilitado'),
      onChanged: (value) {
        setState(() {
          isSwitched2 = value;
          String estatus = '0';
          if (value) {
            estatus = '1';
          }
          cambiarStock(context, widget.producto.idProducto, estatus);
        });
      },
      activeTrackColor: Colors.yellow,
      activeColor: Colors.orangeAccent,
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const TitleText(
      {Key key,
      this.text,
      this.fontSize = 18,
      this.color = LightColor.titleTextColor,
      this.fontWeight = FontWeight.w800})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.muli(
            fontSize: fontSize, fontWeight: fontWeight, color: color));
  }
}

class LightColor {
  static const Color background = Color(0XFFFFFFFF);

  static const Color titleTextColor = const Color(0xff1d2635);
  static const Color subTitleTextColor = const Color(0xff797878);

  static const Color skyBlue = Color(0xff2890c8);
  static const Color lightBlue = Color(0xff5c3dff);

  static const Color orange = Color(0xffE65829);
  static const Color red = Color(0xffF72804);

  static const Color lightGrey = Color(0xffE1E2E4);
  static const Color grey = Color(0xffA1A3A6);
  static const Color darkgrey = Color(0xff747F8F);

  static const Color iconColor = Color(0xffa8a09b);
  static const Color yellowColor = Color(0xfffbba01);

  static const Color black = Color(0xff20262C);
  static const Color lightblack = Color(0xff5F5F60);
}
