import 'dart:io';
import 'dart:typed_data';

import 'package:bufi_empresas/src/api/Pedidos/Pedido_api.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/PedidosModel.dart';
import 'package:bufi_empresas/src/models/tipoEstadoPedidoModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bufi_empresas/src/utils/utils.dart' as utils;
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class TickectPedido extends StatefulWidget {
  final String idPedido;
  const TickectPedido({Key key, @required this.idPedido}) : super(key: key);

  @override
  _TickectPedidoState createState() => _TickectPedidoState();
}

class _TickectPedidoState extends State<TickectPedido> {
  Uint8List _imageFile;
  List<String> imagePaths = [];
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    final pedidoBloc = ProviderBloc.pedido(context);
    pedidoBloc.obtenerPedidoPorId(widget.idPedido);
    return Scaffold(
      backgroundColor: Color(0xff303c59),
      body: StreamBuilder(
          stream: pedidoBloc.pedidoPorIdStream,
          builder: (context, AsyncSnapshot<List<PedidosModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                var fecha = obtenerNombreMes(snapshot.data[0].deliveryDatetime);
                return Stack(
                  children: [
                    SafeArea(
                      child: SingleChildScrollView(
                        child: Screenshot(
                          child: Screenshot(
                            controller: screenshotController,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: responsive.hp(1),
                                horizontal: responsive.wp(2),
                              ),
                              child: VistaDatosPedido(
                                fecha: fecha,
                                pedidos: snapshot.data,
                                activarScroll: false,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.hp(1),
                          horizontal: responsive.wp(2),
                        ),
                        child: FlutterTicketWidget(
                          width: double.infinity,
                          height: double.infinity,
                          isCornerRounded: true,
                          child: VistaDatosPedido(
                            fecha: fecha,
                            pedidos: snapshot.data,
                            activarScroll: true,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: responsive.hp(8),
                      left: responsive.wp(6),
                      child: GestureDetector(
                        child: Container(
                          width: responsive.ip(5),
                          height: responsive.ip(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey[200],
                          ),
                          child: Center(child: BackButton()),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Positioned(
                      top: responsive.hp(8.5),
                      right: responsive.wp(4),
                      child: GestureDetector(
                        child: Container(
                          width: responsive.ip(5),
                          height: responsive.ip(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey[200],
                          ),
                          child: Icon(Icons.share),
                        ),
                        onTap: () async {
                          takeScreenshotandShare(widget.idPedido);
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            } else {
              return Center(
                child: Center(
                  child: Text("No se encuentra información"),
                ),
              );
            }
          }),
    );
  }

  takeScreenshotandShare(String nombre) async {
    var now = DateTime.now();
    nombre = now.microsecond.toString();
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((Uint8List image) async {
      setState(() {
        _imageFile = image;
      });

      await ImageGallerySaver.saveImage(image);

      // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver

      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile;
      File imgFile = new File('$directory/Screenshot$nombre.png');
      imgFile.writeAsBytes(pngBytes);

      imagePaths.add(imgFile.path);
      final RenderBox box = context.findRenderObject() as RenderBox;
      await Share.shareFiles(imagePaths,
          text: '',
          subject: '',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }).catchError((onError) {
      print(onError);
    });
  }
}

class VistaDatosPedido extends StatelessWidget {
  const VistaDatosPedido(
      {Key key,
      @required this.pedidos,
      @required this.fecha,
      @required this.activarScroll})
      : super(key: key);

  final List<PedidosModel> pedidos;
  final String fecha;
  final bool activarScroll;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return ListView.builder(
      padding: EdgeInsetsDirectional.only(
        top: responsive.hp(2),
        bottom: responsive.hp(10),
      ),
      shrinkWrap: true,
      physics: (!activarScroll)
          ? NeverScrollableScrollPhysics()
          : BouncingScrollPhysics(),
      itemCount: pedidos[0].detallePedido.length + 2,
      itemBuilder: (context, index2) {
        if (index2 == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: responsive.hp(1),
                ),
                child: Center(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Image(
                      image: AssetImage('assets/jar-loading.gif'),
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Image(
                        image: AssetImage('assets/carga_fallida.jpg'),
                        fit: BoxFit.cover),
                    imageUrl:
                        '$apiBaseURL/${pedidos[0].listCompanySubsidiary[0].companyImage}',
                    imageBuilder: (context, imageProvider) => Container(
                      width: responsive.ip(10),
                      height: responsive.ip(10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  /*,*/
                ),
              ),
              Center(
                child: Text(
                  'Pedido N° ${pedidos[0].idPedido}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: responsive.ip(2.3),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: responsive.hp(2.5),
                  left: responsive.wp(5),
                  right: responsive.wp(5),
                ),
                child: Column(
                  children: <Widget>[
                    ticketDetailsWidget('Fecha', '$fecha', 'Estado del Pedido',
                        '${pedidos[0].deliveryStatus}', responsive),
                  ],
                ),
              ),
              SizedBox(
                height: responsive.hp(1.5),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                child: Text('Datos del Cliente'),
              ),
              SizedBox(
                height: responsive.hp(1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          '${pedidos[0].deliveryName}',
                          style: TextStyle(
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.pin_drop),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text('${pedidos[0].deliveryAddress}'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text('${pedidos[0].deliveryCel}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: responsive.hp(1.5),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                child: Text('Datos del Negocio'),
              ),
              SizedBox(
                height: responsive.hp(1),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.store),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          '${pedidos[0].listCompanySubsidiary[0].subsidiaryName}',
                          style: TextStyle(
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.pin_drop),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                            '${pedidos[0].listCompanySubsidiary[0].subsidiaryAddress}'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                            '${pedidos[0].listCompanySubsidiary[0].subsidiaryCellphone}'),
                        ('${pedidos[0].listCompanySubsidiary[0].subsidiaryCellphone2}' !=
                                '')
                            ? Text(
                                ' - ${pedidos[0].listCompanySubsidiary[0].subsidiaryCellphone2}')
                            : Text('')
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Center(
                child: Text(
                  'Productos',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: responsive.ip(2.5),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(),
            ],
          );
        }

        int index = index2 - 1;
        if (index == pedidos[0].detallePedido.length) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(4),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: responsive.hp(1),
                ),
                Divider(),
                Row(
                  children: [
                    Text("Subtotal"),
                    Spacer(),
                    Text(
                      'S/ ${pedidos[0].deliveryTotalOrden}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: responsive.ip(1.8),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Row(
                  children: [
                    Text("Envío"),
                    Spacer(),
                    Text(
                      'S/ ${pedidos[0].deliveryPrice}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: responsive.ip(1.8),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      'S/ ${pedidos[0].deliveryTotalOrden}',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: responsive.ip(2.5),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Row(
                  children: [
                    (pedidos[0].deliveryStatus != '5')
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        opaque: false,
                                        transitionDuration:
                                            const Duration(milliseconds: 700),
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return ChangeStatus(
                                              '${pedidos[0].deliveryStatus}',
                                              '${pedidos[0].idPedido}');
                                          //return DetalleProductitos(productosData: productosData);
                                        },
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                      ));
                                },
                                child: Container(
                                  width: responsive.wp(30),
                                  height: responsive.hp(5),
                                  margin: EdgeInsets.all(responsive.ip(1)),
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Text(
                                      'Cambiar Estado',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Spacer(),
                    Spacer(),
                    Image(
                      width: responsive.ip(7.5),
                      height: responsive.ip(7.5),
                      image: AssetImage('assets/logo_bufeotec.png'),
                      fit: BoxFit.contain,
                    ),
                  ],
                )
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsive.hp(.5),
            horizontal: responsive.wp(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${pedidos[0].detallePedido[index].listProducto[0].productoName} ${pedidos[0].detallePedido[index].listProducto[0].productoBrand} x ${pedidos[0].detallePedido[index].cantidad}"),
                    Text(
                        "Modelo: ${pedidos[0].detallePedido[index].listProducto[0].productoModel} "),
                    Text(
                        "Tamaño: ${pedidos[0].detallePedido[index].listProducto[0].productoSize}"),
                    Text(
                        "Tipo: ${pedidos[0].detallePedido[index].listProducto[0].productoType}"),
                    SizedBox(
                      height: responsive.hp(.5),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: responsive.wp(3),
              ),
              Text(
                'S/. ' +
                    (double.parse(
                                '${pedidos[0].detallePedido[index].cantidad}') *
                            double.parse(
                                '${pedidos[0].detallePedido[index].listProducto[0].productoPrice}'))
                        .toString(),
                style: TextStyle(
                    fontSize: responsive.ip(1.8), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget ticketDetailsWidget(String cabecera1, String dato1, String cabecera2,
    String dato2, Responsive responsive) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: [
          Container(
            width: responsive.wp(42),
            child: Text(
              cabecera1,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            width: responsive.wp(2),
          ),
          Container(
            width: responsive.wp(42),
            child: Text(
              cabecera2,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Container(
            width: responsive.wp(42),
            child: Text(
              dato1,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: responsive.wp(2),
          ),
          FutureBuilder(
              future: getEstadoPedido(dato2),
              builder:
                  (context, AsyncSnapshot<TipoEstadoPedidoModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('');
                } else {
                  return Container(
                    width: responsive.wp(42),
                    child: Text(
                      '${snapshot.data.tipoEstadoNombre}',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                }
              }),
        ],
      )
    ],
  );
}

class ChangeStatus extends StatefulWidget {
  final String idEstatus;
  final String idPedido;
  ChangeStatus(this.idEstatus, this.idPedido);

  @override
  _ChangeStatusState createState() => _ChangeStatusState();
}

class _ChangeStatusState extends State<ChangeStatus> {
  final _cargando = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final tipoEstadoPedidos = ProviderBloc.tipoEstadoPedidos(context);
    tipoEstadoPedidos.obtenerTiposEstadosPedidos2(widget.idEstatus);
    final responsive = Responsive.of(context);
    return Material(
      color: Colors.black45,
      child: Stack(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.transparent)),
          Center(
            child: Container(
                margin: EdgeInsets.only(
                    left: responsive.ip(1), right: responsive.ip(1)),
                height: responsive.hp(40),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: StreamBuilder(
                  stream: tipoEstadoPedidos.tiposEstadosPedidosStream2,
                  builder: (context,
                      AsyncSnapshot<List<TipoEstadoPedidoModel>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                            itemCount: snapshot.data.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Container(
                                    child: Center(
                                  child: Text('Cambiar Estado',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: responsive.ip(3),
                                          fontWeight: FontWeight.bold)),
                                ));
                              }
                              index = index - 1;
                              return _item(
                                  responsive,
                                  widget.idPedido,
                                  snapshot.data[index],
                                  Icons.arrow_forward_ios);
                            });
                      } else {
                        return Center(
                          child: Text('Sin estados disponibles'),
                        );
                      }
                    } else {
                      return Center(
                        child: NutsActivityIndicator(
                          radius: 12,
                          activeColor: Colors.white,
                          inactiveColor: Colors.redAccent,
                          tickCount: 11,
                          startRatio: 0.55,
                          animationDuration: Duration(milliseconds: 2003),
                        ),
                      );
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _item(Responsive responsive, idpedido, TipoEstadoPedidoModel data,
      IconData icon) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
        width: double.infinity,
        height: responsive.ip(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: ListTile(
          title: Text(data.tipoEstadoNombre,
              style: TextStyle(
                  //color: Colors.red,
                  fontSize: responsive.ip(2),
                  fontWeight: FontWeight.bold)),
          leading: Icon(icon),
          onTap: () {
            _submit(context, data);
          },
        ));
  }

  Future _submit(BuildContext context, TipoEstadoPedidoModel data) async {
    final pedidoApi = PedidoApi();
    final pedidosBloc = ProviderBloc.pedido(context);
    final preferences = Preferences();
    _cargando.value = true;
    final int res =
        await pedidoApi.updateStatus(widget.idPedido, data.idTipoEstado);
    if (res == 1) {
      eliminarPedidos(widget.idPedido);
      pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
          preferences.idSeleccionSubsidiaryPedidos,
          preferences.idStatusPedidos);
      utils.showToast(context, 'Estado Actualizado');
      Navigator.pop(context);
    } else {
      utils.showToast(context, 'Error al Actualizar');
    }

    _cargando.value = false;
    Navigator.pop(context);
  }
}
