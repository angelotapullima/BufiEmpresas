import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/PedidosModel.dart';
import 'package:bufi_empresas/src/models/tipoEstadoPedidoModel.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:screenshot/screenshot.dart';

class TickectPedido extends StatefulWidget {
  final String idPedido;
  const TickectPedido({Key key, @required this.idPedido}) : super(key: key);

  @override
  _TickectPedidoState createState() => _TickectPedidoState();
}

class _TickectPedidoState extends State<TickectPedido> {
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

                                      /*,*/
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Pedido N° ${snapshot.data[0].idPedido}',
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
                                            'Estado del Pedido',
                                            '${snapshot.data[0].deliveryStatus}',
                                            responsive),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(1.5),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(5)),
                                    child: Text('Datos del Cliente'),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(5)),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.person),
                                            SizedBox(
                                              width: responsive.wp(2),
                                            ),
                                            Text(
                                              '${snapshot.data[0].deliveryName}',
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
                                                '${snapshot.data[0].deliveryAddress}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.phone),
                                            SizedBox(
                                              width: responsive.wp(2),
                                            ),
                                            Text(
                                                '${snapshot.data[0].deliveryCel}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(1.5),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(5)),
                                    child: Text('Datos del Negocio'),
                                  ),
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(5)),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.store),
                                            SizedBox(
                                              width: responsive.wp(2),
                                            ),
                                            Text(
                                              '${snapshot.data[0].listCompanySubsidiary[0].subsidiaryName}',
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
                                                '${snapshot.data[0].listCompanySubsidiary[0].subsidiaryAddress}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.phone),
                                            SizedBox(
                                              width: responsive.wp(2),
                                            ),
                                            Text(
                                                '${snapshot.data[0].listCompanySubsidiary[0].subsidiaryCellphone} - ${snapshot.data[0].listCompanySubsidiary[0].subsidiaryCellphone2}'),
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
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: responsive.hp(2),
                                        left: responsive.wp(10),
                                        right: responsive.wp(10)),
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot
                                              .data[0].detallePedido.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                        "${snapshot.data[0].detallePedido[index].listProducto[0].productoName} x ${snapshot.data[0].detallePedido[index].cantidad}"),
                                                    // Text(
                                                    //     "${snapshot.data[0].detallePedido[index].listProducto[0].listMarcaProd[0].marcaProducto}  "),
                                                    SizedBox(
                                                      height: responsive.hp(.5),
                                                    )
                                                  ],
                                                ),
                                                Spacer(),
                                                Text(
                                                  'S/. ' +
                                                      (double.parse(
                                                                  '${snapshot.data[0].detallePedido[index].cantidad}') *
                                                              double.parse(
                                                                  '${snapshot.data[0].detallePedido[index].listProducto[0].productoPrice}'))
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          responsive.ip(1.8),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: responsive.hp(1),
                                        ),
                                        Divider(),
                                        Row(
                                          children: [
                                            Text("Subtotal"),
                                            Spacer(),
                                            Text(
                                                'S/ ${snapshot.data[0].deliveryTotalOrden}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        responsive.ip(1.8),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: responsive.hp(1),
                                        ),
                                        Row(
                                          children: [
                                            Text("Envío"),
                                            Spacer(),
                                            Text('S/ 0.00',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        responsive.ip(1.8),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Total',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: responsive.ip(2),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Spacer(),
                                            Text(
                                                'S/ ${snapshot.data[0].deliveryTotalOrden}',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize:
                                                        responsive.ip(2.5),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Row(
                                    children: [
                                      (snapshot.data[0].deliveryStatus != '5')
                                          ? Row(
                                              children: [
                                                SizedBox(
                                                  width: responsive.wp(5),
                                                ),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    width: responsive.wp(30),
                                                    height: responsive.hp(5),
                                                    margin: EdgeInsets.all(
                                                        responsive.ip(1)),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blueGrey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Center(
                                                      child: Text(
                                                        'Cambiar Estado',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: responsive.wp(35),
                                                ),
                                              ],
                                            )
                                          : SizedBox(
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
}
