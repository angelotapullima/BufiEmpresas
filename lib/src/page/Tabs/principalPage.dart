import 'package:bufi_empresas/src/bloc/Sucursal/detalleSubisidiaryBloc.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/page/Sucursales/detalleSubsidiary.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/colores.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/widgets/translate_animation.dart';
import 'package:bufi_empresas/src/widgets/widget_MostrarNegocio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';

class PrincipalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    final responsive = Responsive.of(context);
    final negociosBloc = ProviderBloc.negocios(context);
    negociosBloc.obtenernegocios();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _backgroundNegocio(context, responsive),
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'perfil');
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hola,  ',
                            ),
                            Text(
                              '${preferences.personName}',
                              style: GoogleFonts.pacifico(
                                textStyle: TextStyle(
                                  fontSize: responsive.ip(2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'perfil');
                        },
                        child: Container(
                          width: responsive.ip(5),
                          height: responsive.ip(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: '${preferences.userImage}',
                              //cacheManager: CustomCacheManager(),
                              placeholder: (context, url) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Image(
                                    image: AssetImage('assets/loading.gif'),
                                    fit: BoxFit.cover),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          TranslateAnimation(
            duration: const Duration(milliseconds: 400),
            child: _contenido(responsive),
          )
        ],
      ),
    );
  }

  Widget _backgroundNegocio(BuildContext context, Responsive responsive) {
    final preferences = Preferences();
    final pedidoAtendidoBloc = ProviderBloc.pedido(context);
    pedidoAtendidoBloc
        .obtenerPedidosAtendidos(preferences.idSeleccionNegocioInicio);
    final pedidoPendienteBloc = ProviderBloc.pedido(context);
    pedidoPendienteBloc
        .obtenerPedidosPendientes(preferences.idSeleccionNegocioInicio);
    return Container(
      margin: EdgeInsets.only(
        top: responsive.hp(10),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            height: responsive.hp(25),
            child: MostrarNegocio(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  final prefs = Preferences();
                  prefs.idStatusPedidos = '5';
                  final pedidosBloc = ProviderBloc.pedido(context);
                  pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
                      prefs.idSeleccionSubsidiaryPedidos,
                      prefs.idStatusPedidos);
                  final buttonBloc = ProviderBloc.tabs(context);
                  buttonBloc.changePage(1);
                },
                child: Container(
                  height: responsive.hp(11),
                  width: responsive.wp(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Atendidos',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.bold)),
                      StreamBuilder(
                          stream: pedidoAtendidoBloc.pedidosAtendidosStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.length > 0) {
                                return Text(
                                  '${snapshot.data.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsive.ip(3),
                                  ),
                                );
                              } else {
                                return Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsive.ip(3),
                                  ),
                                );
                              }
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                width: responsive.wp(5),
              ),
              GestureDetector(
                onTap: () {
                  final prefs = Preferences();
                  prefs.idStatusPedidos = '99';
                  final pedidosBloc = ProviderBloc.pedido(context);
                  pedidosBloc.obtenerPedidosPorIdSubsidiaryAndIdStatus(
                      prefs.idSeleccionSubsidiaryPedidos,
                      prefs.idStatusPedidos);
                  final buttonBloc = ProviderBloc.tabs(context);
                  buttonBloc.changePage(1);
                },
                child: Container(
                  height: responsive.hp(11),
                  width: responsive.wp(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Pendientes',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.ip(2),
                              fontWeight: FontWeight.bold)),
                      StreamBuilder(
                          stream: pedidoPendienteBloc.pedidosPendientesStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.length > 0) {
                                return Text(
                                  '${snapshot.data.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsive.ip(3),
                                  ),
                                );
                              } else {
                                return Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsive.ip(3),
                                  ),
                                );
                              }
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _contenido(Responsive responsive) {
    return Container(
      margin: EdgeInsets.only(
        top: responsive.hp(30),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.65,
        builder: (context, scrollController) {
          return Container(
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
                child: Sucursales(),
              ));
        },
      ),
    );
  }
}

class Sucursales extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final negociosBloc = ProviderBloc.negocios(context);
    final preferences = Preferences();
    negociosBloc.obtenersucursales(preferences.idSeleccionNegocioInicio);
    final responsive = Responsive.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
      child: Column(
        children: [
          SizedBox(height: 10),
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
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mis Sucursales',
                style: TextStyle(
                    fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          StreamBuilder(
            stream: negociosBloc.suscursaStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return _crearItem(
                            context, snapshot.data[index], responsive);
                      });
                } else {
                  return Center(child: Text('No tiene Sucursales'));
                }
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _crearItem(BuildContext context, SubsidiaryModel servicioData,
      Responsive responsive) {
    return GestureDetector(
      onTap: () {
        final provider =
            Provider.of<DetailSubsidiaryBloc>(context, listen: false);

        provider.changeToInformation();

        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return DetalleSubsidiary(
              idSucursal: servicioData.idSubsidiary,
              nombreSucursal: servicioData.subsidiaryName,
              imgSucursal: servicioData.subsidiaryImg,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(2, 3),
            ),
          ],
        ),
        margin: EdgeInsets.all(responsive.ip(0.2)),
        height: responsive.hp(15),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                width: responsive.wp(42),
                child: Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      placeholder: (context, url) => Image(
                        image: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image(
                          image: AssetImage('assets/carga_fallida.jpg'),
                          fit: BoxFit.cover),
                      imageUrl: '$apiBaseURL/${servicioData.subsidiaryImg}',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: responsive.hp(.5),
                          //horizontal: responsive.wp(2)
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${servicioData.subsidiaryName}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(2),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: responsive.wp(53),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${servicioData.subsidiaryName}',
                    style: TextStyle(
                        fontSize: responsive.ip(2.3),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text('${servicioData.subsidiaryAddress}'),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(width: 5),
                    //Text('${data[index].subsidiaryGoodRating}'),
                    Row(
                      children: [
                        Container(
                          width: responsive.wp(30),
                          child: RatingBar.readOnly(
                            size: 20,
                            initialRating:
                                ('${servicioData.listCompany.companyRating}' !=
                                            null &&
                                        '${servicioData.listCompany.companyRating}' !=
                                            'null')
                                    ? double.parse(
                                        '${servicioData.listCompany.companyRating}')
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
                    SizedBox(width: 10),
                  ])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
