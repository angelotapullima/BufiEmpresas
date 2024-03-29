import 'dart:io';
import 'dart:typed_data';

import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/PagosModel.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class TicketPago extends StatefulWidget {
  final String idPago;
  TicketPago({Key key, @required this.idPago}) : super(key: key);

  @override
  _TicketPagoState createState() => _TicketPagoState();
}

class _TicketPagoState extends State<TicketPago> {
  Uint8List _imageFile;
  List<String> imagePaths = [];
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    final pagoBloc = ProviderBloc.pagos(context);
    pagoBloc.obtenerPagoXid(widget.idPago);
    final responsive = Responsive.of(context);
    return Scaffold(
      backgroundColor: Color(0xff303c59),
      body: StreamBuilder(
          stream: pagoBloc.pagoIdStream,
          builder: (context, AsyncSnapshot<List<PagosModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                var fecha = obtenerNombreMes(snapshot.data[0].pagoDate);
                return Stack(
                  children: [
                    SafeArea(
                      child: SingleChildScrollView(
                        child: Screenshot(
                          controller: screenshotController,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: responsive.hp(1),
                              horizontal: responsive.wp(2),
                            ),
                            child: VistaDatosPago(
                              fecha: fecha,
                              pagos: snapshot.data,
                              activarScroll: false,
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
                          child: VistaDatosPago(
                            fecha: fecha,
                            pagos: snapshot.data,
                            activarScroll: true,
                          ),
                        ),
                      ),
                    ),
                    // Screenshot(
                    //   controller: screenshotController,
                    //   child: SafeArea(
                    //     child: Container(
                    //       padding: EdgeInsets.symmetric(
                    //         vertical: responsive.hp(1),
                    //         horizontal: responsive.wp(2),
                    //       ),
                    //       child: FlutterTicketWidget(
                    //         width: double.infinity,
                    //         height: double.infinity,
                    //         isCornerRounded: true,

                    //               Padding(
                    //                 padding: EdgeInsets.only(
                    //                     top: responsive.hp(2),
                    //                     left: responsive.wp(10),
                    //                     right: responsive.wp(10)),
                    //                 child: Column(
                    //                   children: [
                    //                     ListView.builder(
                    //                       shrinkWrap: true,
                    //                       itemCount: snapshot
                    //                           .data[0].detallePedido.length,
                    //                       itemBuilder: (BuildContext context,
                    //                           int index) {
                    //                         return Row(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment
                    //                                   .spaceBetween,
                    //                           children: [
                    //                             Column(
                    //                               children: [
                    //                                 Text(
                    //                                     "${snapshot.data[0].detallePedido[index].listProducto[0].productoName} x ${snapshot.data[0].detallePedido[index].cantidad}"),
                    //                                 // Text(
                    //                                 //     "${snapshot.data[0].detallePedido[index].listProducto[0].listMarcaProd[0].marcaProducto}  "),
                    //                                 SizedBox(
                    //                                   height: responsive.hp(.5),
                    //                                 )
                    //                               ],
                    //                             ),
                    //                             Spacer(),
                    //                             Text(
                    //                               'S/. ' +
                    //                                   (double.parse(
                    //                                               '${snapshot.data[0].detallePedido[index].cantidad}') *
                    //                                           double.parse(
                    //                                               '${snapshot.data[0].detallePedido[index].listProducto[0].productoPrice}'))
                    //                                       .toString(),
                    //                               style: TextStyle(
                    //                                   fontSize:
                    //                                       responsive.ip(1.8),
                    //                                   fontWeight:
                    //                                       FontWeight.bold),
                    //                             ),
                    //                           ],
                    //                         );
                    //                       },
                    //                     ),
                    //                     SizedBox(
                    //                       height: responsive.hp(1),
                    //                     ),
                    //                     Divider(),
                    //                     Row(
                    //                       children: [
                    //                         Text("Subtotal"),
                    //                         Spacer(),
                    //                         Text(
                    //                             'S/ ${snapshot.data[0].pagoMonto}',
                    //                             style: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize:
                    //                                     responsive.ip(1.8),
                    //                                 fontWeight:
                    //                                     FontWeight.bold)),
                    //                       ],
                    //                     ),
                    //                     SizedBox(
                    //                       height: responsive.hp(1),
                    //                     ),
                    //                     Row(
                    //                       children: [
                    //                         Text("Envío"),
                    //                         Spacer(),
                    //                         Text(
                    //                             'S/ ${snapshot.data[0].pagoComision}',
                    //                             style: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize:
                    //                                     responsive.ip(1.8),
                    //                                 fontWeight:
                    //                                     FontWeight.bold)),
                    //                       ],
                    //                     ),
                    //                     Divider(),
                    //                     Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         Text('Total',
                    //                             style: TextStyle(
                    //                                 color: Colors.red,
                    //                                 fontSize: responsive.ip(2),
                    //                                 fontWeight:
                    //                                     FontWeight.bold)),
                    //                         Spacer(),
                    //                         Text(
                    //                             'S/ ${snapshot.data[0].pagoTotal}',
                    //                             style: TextStyle(
                    //                                 color: Colors.red,
                    //                                 fontSize:
                    //                                     responsive.ip(2.5),
                    //                                 fontWeight:
                    //                                     FontWeight.bold)),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               Expanded(
                    //                   child: Row(
                    //                 children: [
                    //                   SizedBox(
                    //                     width: responsive.wp(75),
                    //                   ),
                    //                   Image(
                    //                     width: responsive.ip(7.5),
                    //                     height: responsive.ip(7.5),
                    //                     image: AssetImage(
                    //                         'assets/logo_bufeotec.png'),
                    //                     fit: BoxFit.contain,
                    //                   ),
                    //                 ],
                    //               ))
                    //             ]),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                            child: Icon(Icons.share)),
                        onTap: () async {
                          takeScreenshotandShare(widget.idPago);
                        },
                      ),
                    )
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

class VistaDatosPago extends StatefulWidget {
  VistaDatosPago({
    Key key,
    @required this.pagos,
    @required this.fecha,
    @required this.activarScroll,
  }) : super(key: key);

  final List<PagosModel> pagos;
  final String fecha;
  final bool activarScroll;

  @override
  _VistaDatosPagoState createState() => _VistaDatosPagoState();
}

class _VistaDatosPagoState extends State<VistaDatosPago> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return ListView.builder(
        padding: EdgeInsets.only(
          top: responsive.hp(2),
          bottom: responsive.hp(10),
        ),
        shrinkWrap: true,
        physics: (!widget.activarScroll)
            ? NeverScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        itemCount: widget.pagos[0].detallePedido.length + 2,
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
                          '$apiBaseURL/${widget.pagos[0].listCompanySubsidiary[0].companyImage}',
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
                  ),
                ),
                Center(
                  child: Text(
                    'Pago N° ${widget.pagos[0].idPago}',
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
                      ticketDetailsWidget(
                          'Fecha',
                          '${widget.fecha}',
                          'Transferencia N°:',
                          '${widget.pagos[0].transferenciaUENroOperacion} ',
                          responsive),
                      SizedBox(
                        height: responsive.hp(1.15),
                      ),
                      ticketDetailsWidget(
                          'Concepto',
                          '${widget.pagos[0].transferecniaUEConcepto}',
                          'Monto Tranferencia',
                          'S/. ${widget.pagos[0].transferenciaUEMonto}',
                          responsive),
                    ],
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1.5),
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

          if (index == widget.pagos[0].detallePedido.length) {
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
                        'S/ ${widget.pagos[0].detallePedido[0].detallePedidoSubtotal}',
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
                        'S/ ${widget.pagos[0].pagoComision}',
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
                        'S/ ${widget.pagos[0].pagoTotal}',
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
                          "${widget.pagos[0].detallePedido[index].listProducto[0].productoName} ${widget.pagos[0].detallePedido[index].listProducto[0].productoBrand} x ${widget.pagos[0].detallePedido[index].cantidad}"),
                      Text(
                          "Modelo: ${widget.pagos[0].detallePedido[index].listProducto[0].productoModel} "),
                      Text(
                          "Tamaño: ${widget.pagos[0].detallePedido[index].listProducto[0].productoSize}"),
                      Text(
                          "Tipo: ${widget.pagos[0].detallePedido[index].listProducto[0].productoType}"),
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
                                  '${widget.pagos[0].detallePedido[index].cantidad}') *
                              double.parse(
                                  '${widget.pagos[0].detallePedido[index].listProducto[0].productoPrice}'))
                          .toString(),
                  style: TextStyle(
                      fontSize: responsive.ip(1.8),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        });
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
          Container(
            width: responsive.wp(42),
            child: Text(
              dato2,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      )
    ],
  );
}
