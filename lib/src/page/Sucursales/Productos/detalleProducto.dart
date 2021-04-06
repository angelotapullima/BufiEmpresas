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
  //controlador del PageView
  final _pageController = PageController(viewportFraction: 1, initialPage: 0);
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
    //contador para el PageView
    final contadorBloc = ProviderBloc.contadorPagina(context);
    contadorBloc.changeContador(0);

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
          builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
            List<ProductoModel> listProd = snapshot.data;
            bool _enabled = true;
            if (snapshot.hasData) {
              if (listProd[0].listTallaProd.length > 0) {
                return Stack(
                  children: <Widget>[
                    _backgroundImage(
                        context, responsive, listProd, contadorBloc),

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
                            //contador de páginas
                            StreamBuilder(
                                stream: contadorBloc.selectContadorStream,
                                builder: (context, snapshot) {
                                  return Container(
                                    height: responsive.hp(3),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: responsive.wp(2),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.grey[300]),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: responsive.wp(5),
                                      vertical: responsive.hp(1.3),
                                    ),
                                    child: Text(
                                      (contadorBloc.pageContador + 1)
                                              .toString() +
                                          '/' +
                                          listProd[0]
                                              .listFotos
                                              .length
                                              .toString(),
                                    ),
                                  );
                                }),
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
                      child: _contenido(responsive, context, listProd),
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

  Widget _backgroundImage(BuildContext context, Responsive responsive,
      List<ProductoModel> listProd, contadorBloc) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.47,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
              itemCount: listProd[0].listFotos.length,
              controller: _pageController,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      /*Navigator.pushNamed(context, 'detalleProductoFoto',
                          arguments: listProd[0]);*/
                    },
                    child: Hero(
                      tag:
                          '$apiBaseURL/${listProd[0].listFotos[index].galeriaFoto}',
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

                          imageUrl:
                              '$apiBaseURL/${listProd[0].listFotos[index].galeriaFoto}',

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
                );
              },
              onPageChanged: (int index) {
                contadorBloc.changeContador(index);
              }),
        ],
      ),
    );
  }

  Widget _contenido(Responsive responsive, BuildContext context,
      List<ProductoModel> listProd) {
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
                        TitleText(
                            text: "${widget.producto.productoName}",
                            fontSize: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TitleText(
                                  text: "S/ ",
                                  fontSize: 18,
                                  color: LightColor.red,
                                ),
                                TitleText(
                                  text: "${widget.producto.productoPrice}",
                                  fontSize: 25,
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star_border, size: 17),
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
                  (listProd[0].listTallaProd.length > 1)
                      ? _talla(responsive, listProd)
                      : Container(),
                  (listProd[0].listMarcaProd.length > 1)
                      ? _marca(responsive, listProd)
                      : Container(),
                  (listProd[0].listModeloProd.length > 1)
                      ? _modelo(responsive, listProd)
                      : Container(),

                  Center(child: _swichtEstado(context, listProd)),
                  Center(child: _swichtEstadoStock(context, listProd)),
                  //_description(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _swichtEstado(BuildContext context, List<ProductoModel> listProd) {
    return SwitchListTile(
      value: isSwitched,
      title: (listProd[0].productoStatus == '1')
          ? Text('Producto Habilitado')
          : Text('Producto Deshabilitado'),
      onChanged: (value) {
        setState(() {
          isSwitched = value;
          String estatus = '0';
          if (value) {
            estatus = '1';
          }
          habilitarDesProducto(context, widget.producto.idProducto, estatus);
        });
      },
      activeTrackColor: Colors.yellow,
      activeColor: Colors.orangeAccent,
    );
  }

  Widget _swichtEstadoStock(
      BuildContext context, List<ProductoModel> listProd) {
    return SwitchListTile(
      value: isSwitched2,
      title: (listProd[0].productoStock == '1')
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

  Widget _talla(Responsive responsive, List<ProductoModel> listProd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: "Tallas",
          fontSize: 14,
        ),
        Container(
          height: responsive.hp(8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: listProd[0].listTallaProd.length,
            itemBuilder: (BuildContext context, int index) {
              return _tallaWidget(listProd, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _marca(Responsive responsive, List<ProductoModel> listProd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: "Marcas",
          fontSize: 14,
        ),
        SizedBox(
          height: responsive.hp(1),
        ),
        Container(
          height: responsive.hp(8),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: listProd[0].listMarcaProd.length,
            itemBuilder: (BuildContext context, int index) {
              return _marcaWidget(listProd, index);
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: <Widget>[
              //     _marcaWidget(listProd, index),
              //     //_sizeWidget("US 7", isSelected: true),
              //   ],
              // );
            },
          ),
        ),
      ],
    );
  }

  Widget _modelo(Responsive responsive, List<ProductoModel> listProd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: "Modelo",
          fontSize: 14,
        ),
        SizedBox(height: responsive.hp(1)),
        Container(
          height: responsive.hp(8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: listProd[0].listModeloProd.length,
            itemBuilder: (BuildContext context, int index) {
              return _modeloWidget(listProd, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _tallaWidget(List<ProductoModel> listProd, int index) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color: LightColor.iconColor,
              style: (listProd[0].listTallaProd[index].estado == '1')
                  ? BorderStyle.solid
                  : BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: (listProd[0].listTallaProd[index].estado == '1')
              ? LightColor.red
              : Theme.of(context).backgroundColor,
        ),
        child: TitleText(
          text: listProd[0].listTallaProd[index].tallaProducto,
          fontSize: 16,
          color: (listProd[0].listTallaProd[index].estado == '1')
              ? LightColor.background
              : LightColor.titleTextColor,
        ),
      ).ripple(() async {},
          borderRadius: BorderRadius.all(Radius.circular(13))),
    );
  }

  Widget _marcaWidget(List<ProductoModel> listProd, int index,
      {bool isSelected = false}) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color: LightColor.iconColor,
              style: !isSelected ? BorderStyle.solid : BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: (listProd[0].listMarcaProd[index].estado == '1')
              ? LightColor.red
              : Theme.of(context).backgroundColor,
        ),
        child: TitleText(
          text: listProd[0].listMarcaProd[index].marcaProducto,
          fontSize: 16,
          color: (listProd[0].listMarcaProd[index].estado == '1')
              ? LightColor.background
              : LightColor.titleTextColor,
        ),
      ).ripple(
        () async {},
        borderRadius: BorderRadius.all(
          Radius.circular(13),
        ),
      ),
    );
  }

  Widget _modeloWidget(List<ProductoModel> listProd, int index,
      {bool isSelected = false}) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color: LightColor.iconColor,
              style: !isSelected ? BorderStyle.solid : BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: (listProd[0].listModeloProd[index].estado == '1')
              ? LightColor.red
              : Theme.of(context).backgroundColor,
        ),
        child: TitleText(
          text: listProd[0].listModeloProd[index].modeloProducto,
          fontSize: 16,
          color: (listProd[0].listModeloProd[index].estado == '1')
              ? LightColor.background
              : LightColor.titleTextColor,
        ),
      ).ripple(
        () async {},
        borderRadius: BorderRadius.all(
          Radius.circular(13),
        ),
      ),
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
