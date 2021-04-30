import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/bloc/Sucursal/detalleSubisidiaryBloc.dart';
import 'package:bufi_empresas/src/page/Sucursales/Productos/GridviewProductosPorSucursal.dart';
import 'package:bufi_empresas/src/page/Sucursales/Servicios/GridviewServiciosPorSucursal.dart';
import 'package:bufi_empresas/src/page/Sucursales/editarSubsidiaryPage.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/customCacheManager.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DetalleSubsidiary extends StatefulWidget {
  final String nombreSucursal;
  final String idSucursal;
  final String imgSucursal;

  const DetalleSubsidiary(
      {Key key,
      @required this.nombreSucursal,
      @required this.idSucursal,
      @required this.imgSucursal})
      : super(key: key);

  @override
  _DetalleSubsidiaryState createState() => _DetalleSubsidiaryState();
}

class _DetalleSubsidiaryState extends State<DetalleSubsidiary>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();

  TabController tabController;

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final provider =
            Provider.of<DetailSubsidiaryBloc>(context, listen: false);

        _scrollController.addListener(
          () {
            print(_scrollController.position.pixels);
            if (_scrollController.position.pixels > 200) {
              provider.ocultarSafeArea.value = false;
            } else if (_scrollController.position.pixels < 10) {
              provider.ocultarSafeArea.value = true;
            }

            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              final productoBloc = ProviderBloc.productos(context);
              productoBloc.listarProductosPorSucursal(widget.idSucursal);

              final serviciosBloc = ProviderBloc.servi(context);
              serviciosBloc.listarServiciosPorSucursal(widget.idSucursal);
            }
          },
        );
      },
    );

    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                flexibleSpace: CebeceraItem(
                  nombreSucursal: widget.nombreSucursal,
                  idSucursal: widget.idSucursal,
                  imgSucursal: widget.imgSucursal,
                ),
                expandedHeight: responsive.hp(20),
                collapsedHeight: responsive.hp(9),
                //floating: true,
                //primary: true,
                pinned: true,

                bottom: new TabBar(
                  labelStyle: TextStyle(
                      fontSize: responsive.ip(1.5),
                      fontWeight: FontWeight.bold),
                  isScrollable: true,
                  tabs: [
                    Tab(
                      child: Text(
                        'Información',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(1.8),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Productos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(1.8),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Servicios',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(1.8),
                        ),
                      ),
                    ),
                  ],
                  controller: tabController,
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              Scaffold(
                body: InformacionWidget(
                  idSucursal: widget.idSucursal,
                ),
              ),
              Scaffold(
                body: GridviewProductoPorSucursal(
                  idSucursal: widget.idSucursal,
                ),
              ),
              Scaffold(
                body: GridviewServiciosPorSucursal(
                  idSucursal: widget.idSucursal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CebeceraItem extends StatelessWidget {
  const CebeceraItem(
      {Key key,
      @required this.nombreSucursal,
      @required this.idSucursal,
      @required this.imgSucursal})
      : super(key: key);

  final String idSucursal;
  final String nombreSucursal;
  final String imgSucursal;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Container(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    cacheManager: CustomCacheManager(),
                    placeholder: (context, url) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image(
                          image: AssetImage('assets/jar-loading.gif'),
                          fit: BoxFit.cover),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: Icon(Icons.error),
                      ),
                    ),
                    //imageUrl: '$apiBaseURL/${companyModel.companyImage}',
                    imageUrl: '$apiBaseURL/$imgSucursal',
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
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(.5),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: responsive.hp(2),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: responsive.wp(13),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(
                    left: responsive.ip(5),
                    top: responsive.ip(1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.store, color: Colors.white),
                      SizedBox(
                        width: responsive.wp(2),
                      ),
                      Text(
                        nombreSucursal,
                        style: TextStyle(
                            fontSize: responsive.ip(2.4),
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                //Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InformacionWidget extends StatelessWidget {
  final String idSucursal;
  const InformacionWidget({Key key, @required this.idSucursal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sucursalBloc = ProviderBloc.sucursal(context);
    sucursalBloc.obtenerSucursalporId(idSucursal);

    final responsive = Responsive.of(context);
    return Container(
      color: Colors.white,
      height: double.infinity,
      child: StreamBuilder(
        stream: sucursalBloc.subsidiaryIdStream,
        builder: (context, AsyncSnapshot<List<SubsidiaryModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: responsive.hp(3),
                    left: responsive.wp(3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   children: [
                      //     Container(
                      //       width: responsive.wp(40),
                      //       child: RatingBar.readOnly(
                      //         size: responsive.ip(3),
                      //         initialRating: double.parse(
                      //             '${snapshot.data[0].subsidiaryStatus}'),
                      //         isHalfAllowed: true,
                      //         halfFilledIcon: Icons.star_half,
                      //         filledIcon: Icons.star,
                      //         emptyIcon: Icons.star_border,
                      //         filledColor: Colors.yellow,
                      //       ),
                      //     ),
                      //     /* Text(
                      //       '${snapshot.data[0].subsidiaryStatus}',
                      //       style: TextStyle(
                      //         fontSize: responsive.ip(2),
                      //       ),
                      //     ), */
                      //   ],
                      // ),
                      //
                      ('${snapshot.data[0].subsidiaryPrincipal}') == '1'
                          ? Row(
                              children: [
                                Text("Oficina Principal de",
                                    style: TextStyle(
                                        fontSize: responsive.ip(2),
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: responsive.wp(2),
                                ),
                                Text(
                                  '${snapshot.data[0].subsidiaryName}',
                                  style: TextStyle(
                                      fontSize: responsive.ip(2),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            )
                          : Container(
                              child: Text("Sucursal",
                                  style: TextStyle(
                                      fontSize: responsive.ip(2),
                                      fontWeight: FontWeight.bold)),
                            ),
                      SizedBox(
                        height: responsive.hp(3),
                      ),
                      Text(
                        "Información",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: responsive.ip(3),
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(color: Colors.grey),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: responsive.ip(3.5), color: Colors.red[700]),
                          SizedBox(
                            width: responsive.wp(2),
                          ),
                          Text(
                            '${snapshot.data[0].subsidiaryAddress}',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsive.hp(2.5),
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.clock,
                            color: Colors.red,
                            size: responsive.ip(3.5),
                          ),
                          SizedBox(
                            width: responsive.wp(2),
                          ),
                          Text(
                            '${snapshot.data[0].subsidiaryOpeningHours}',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsive.hp(2.5),
                      ),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.phoneAlt,
                              color: Colors.red[700], size: responsive.ip(3)),
                          SizedBox(
                            width: responsive.wp(2),
                          ),
                          Text(
                            '${snapshot.data[0].subsidiaryCellphone}',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                            ),
                          ),
                          (snapshot.data[0].subsidiaryCellphone2 != '')
                              ? Text(
                                  ' - ${snapshot.data[0].subsidiaryCellphone2}',
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                )
                              : Text('')
                        ],
                      ),
                      SizedBox(
                        height: responsive.hp(2.5),
                      ),
                      Row(
                        children: [
                          Icon(Icons.mail,
                              size: responsive.ip(3.5), color: Colors.red[700]),
                          SizedBox(
                            width: responsive.wp(2),
                          ),
                          Text(
                              ('${snapshot.data[0].subsidiaryEmail}') == 'null'
                                  ? ''
                                  : '${snapshot.data[0].subsidiaryEmail}',
                              style: TextStyle(
                                fontSize: responsive.ip(2),
                              ))
                          // Text(
                          //   '${snapshot.data[0].subsidiaryEmail}',
                          //   style: TextStyle(
                          //     fontSize: responsive.ip(2),
                          //   ),
                          // ),
                        ],
                      ),

                      SizedBox(height: responsive.hp(2.5)),

                      Row(
                        children: [
                          Text("Coordenada X:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: responsive.wp(2),
                          ),
                          Text(
                            '${snapshot.data[0].subsidiaryCoordX}',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsive.hp(2.5),
                      ),
                      Row(
                        children: [
                          Text("Coordenada Y:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: responsive.wp(2),
                          ),
                          Text(
                            '${snapshot.data[0].subsidiaryCoordY}',
                            style: TextStyle(
                              fontSize: responsive.ip(2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsive.hp(2.5),
                      ),
                      // ('${snapshot.data[0].subsidiaryPrincipal}')=='1' ?
                      // Row(
                      //   children: [
                      //     Text("Oficina Principal de",
                      //       style: TextStyle(fontSize: responsive.ip(2),
                      //         fontWeight: FontWeight.bold)),
                      //     SizedBox(
                      //       width: responsive.wp(2),
                      //     ),

                      //     Text(
                      //       '${snapshot.data[0].subsidiaryName}',
                      //       style: TextStyle(
                      //         fontSize: responsive.ip(2),
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.red
                      //       ),
                      //     ),
                      //   ],
                      // ): Container(),
                      SizedBox(height: responsive.hp(2.5)),
                      Center(
                        child: SizedBox(
                          width: responsive.wp(80),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(3),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return EditarSubsidiaryPage(
                                      subsidiaryModel: snapshot.data[0]);
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = Offset(0.0, 1.0);
                                  var end = Offset.zero;
                                  var curve = Curves.ease;

                                  var tween =
                                      Tween(begin: begin, end: end).chain(
                                    CurveTween(curve: curve),
                                  );

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ));
                            },
                            child: Text("Editar Información",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsive.ip(2.2))),
                          ),
                        ),
                      ),
                      // Column(
                      //   children: [
                      //     Text("Descripción:",
                      //         style: TextStyle(
                      //             fontSize: responsive.ip(2),
                      //             fontWeight: FontWeight.bold)),
                      //     Text(('${snapshot.data[0].subsidiaryDescription}') ==
                      //             "null"
                      //         ? ''
                      //         : '${snapshot.data[0].subsidiaryDescription}')
                      //   ],
                      // ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
