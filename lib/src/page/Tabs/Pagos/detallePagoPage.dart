import 'dart:io';
import 'dart:typed_data';

import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/PagosModel.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class TicketPago extends StatefulWidget {
  final String idPago;
  TicketPago({Key key, @required this.idPago}) : super(key: key);

  @override
  _TicketPagoState createState() => _TicketPagoState();
}

class _TicketPagoState extends State<TicketPago> {
  File _imageFile;
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
                var fecha =
                    obtenerNombreMes(snapshot.data[0].transferenciaUEDate);
                return Stack(
                  children: [
                    Screenshot(
                      controller: screenshotController,
                      child: SafeArea(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: responsive.hp(1),
                            horizontal: responsive.wp(2),
                          ),
                          child: FlutterTicketWidget(
                            width: double.infinity,
                            height: double.infinity,
                            isCornerRounded: true,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: responsive.hp(1),
                                    ),
                                    child: Center(
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) => Image(
                                          image: AssetImage(
                                              'assets/jar-loading.gif'),
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image(
                                                image: AssetImage(
                                                    'assets/carga_fallida.jpg'),
                                                fit: BoxFit.cover),
                                        imageUrl:
                                            '$apiBaseURL/${snapshot.data[0].listCompanySubsidiary[0].companyImage}',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
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
                                      'Pago N° ${snapshot.data[0].idPago}',
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
                                            '$fecha',
                                            'Transferencia N°:',
                                            '${snapshot.data[0].transferenciaUENroOperacion} ',
                                            responsive),
                                        SizedBox(
                                          height: responsive.hp(1.15),
                                        ),
                                        ticketDetailsWidget(
                                            'Concepto',
                                            '${snapshot.data[0].transferecniaUEConcepto}',
                                            'Monto Tranferencia',
                                            'S/. ${snapshot.data[0].transferenciaUEMonto}',
                                            responsive),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(1.5),
                                  ),
                                  Divider(),
                                  Expanded(
                                      child: Row(
                                    children: [
                                      SizedBox(
                                        width: responsive.wp(75),
                                      ),
                                      Image(
                                        width: responsive.ip(7.5),
                                        height: responsive.ip(7.5),
                                        image: AssetImage(
                                            'assets/logo_bufeotec.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  ))
                                ]),
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
                            child: Icon(Icons.share)),
                        onTap: () async {
                          takeScreenshotandShare();
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

  takeScreenshotandShare() async {
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
      });

      await ImageGallerySaver.saveImage(image.readAsBytesSync());
      // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
      print("File Saved to Gallery");

      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile.readAsBytesSync();
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");
      await Share.file('Anupam', 'screenshot.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
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
}
