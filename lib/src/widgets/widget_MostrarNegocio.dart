import 'dart:math';

import 'package:bufi_empresas/src/bloc/ContadorPages/contadorPaginaListNegocio_bloc.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MostrarNegocio extends StatelessWidget {
  final CarouselController buttonCarouselController = CarouselController();
  //final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    /*final _pageController =
        PageController(viewportFraction: 0.7, initialPage: 0);*/
    final negociosBloc = ProviderBloc.negocios(context);
    negociosBloc.obtenernegocios();
    final responsive = Responsive.of(context);
    //contador para el PageView
    final contadorBloc = ProviderBloc.contadorPagina(context);
    contadorBloc.changeContador(0);
    obtenerprimerIdCompany(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mis Negocios',
              style: TextStyle(
                  fontSize: responsive.ip(2.5), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          height: responsive.hp(15),
          child: StreamBuilder(
            stream: negociosBloc.negociosStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  final size = MediaQuery.of(context).size;
                  return CarouselSlider.builder(
                    itemCount: snapshot.data.length,
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      height: size.height,
                      aspectRatio: 2,
                      viewportFraction: 0.6,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      /*onScrolled: (data) {
                        _scrollController.animateTo(
                          data * size.width,
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 100),
                        );
                      },*/
                      onPageChanged: (index, reason) {
                        contadorBloc.changeContador(index);
                        final negociosBloc = ProviderBloc.negocios(context);
                        final preferences = Preferences();
                        preferences.idSeleccionNegocioInicio =
                            snapshot.data[index].idCompany;
                        preferences.nombreCompany =
                            snapshot.data[index].companyName;
                        preferences.fechaF = '';
                        preferences.fechaI = '';
                        actualizarBusquedaPagos(context);
                        final pedidoAtendidoBloc = ProviderBloc.pedido(context);
                        pedidoAtendidoBloc.obtenerPedidosAtendidos(
                            preferences.idSeleccionNegocioInicio);
                        final pedidoPendienteBloc =
                            ProviderBloc.pedido(context);
                        pedidoPendienteBloc.obtenerPedidosPendientes(
                            preferences.idSeleccionNegocioInicio);
                        final empresaNameBloc =
                            ProviderBloc.nameEmpresa(context);
                        empresaNameBloc
                            .changeEmpresaName(preferences.nombreCompany);
                        actualizarSeleccionCompany(
                            context, preferences.idSeleccionNegocioInicio);
                        obtenerprimerIdSubsidiary(
                            context, preferences.idSeleccionNegocioInicio);
                        negociosBloc.obtenersucursales(
                            preferences.idSeleccionNegocioInicio);
                      },
                    ),
                    itemBuilder: (BuildContext context, int index, int) {
                      return _crearItem(context, snapshot.data[index],
                          responsive, contadorBloc, index);
                    },
                  );

                  /*PageView.builder(
                      itemCount: snapshot.data.length,
                      controller: _pageController,
                      itemBuilder: (BuildContext context, int index) {
                        return _crearItem(context, snapshot.data[index],
                            responsive, contadorBloc, index);
                      },
                      onPageChanged: (int index) {
                        contadorBloc.changeContador(index);
                        final negociosBloc = ProviderBloc.negocios(context);
                        final preferences = Preferences();
                        preferences.idSeleccionNegocioInicio =
                            snapshot.data[index].idCompany;
                        actualizarSeleccionCompany(
                            context, preferences.idSeleccionNegocioInicio);
                        obtenerprimerIdSubsidiary(
                            context, preferences.idSeleccionNegocioInicio);
                        negociosBloc.obtenersucursales(
                            preferences.idSeleccionNegocioInicio);
                      });*/

                } else {
                  return Center(child: Text('No tiene Negocios'));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Container(
          height: responsive.hp(5),
          child: StreamBuilder(
            stream: negociosBloc.negociosStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          snapshot.data.length, (index) => _Puntos(index)));
                } else {
                  return Center(child: Text(''));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _crearItem(
      BuildContext context,
      CompanyModel companyData,
      Responsive responsive,
      ContadorPaginaNegocioBloc contadorBloc,
      int index) {
    return Container(
      height: responsive.hp(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: (contadorBloc.pageContador >= index - 0.5 &&
                    contadorBloc.pageContador < index + 0.5)
                ? Colors.redAccent
                : Colors.grey.withOpacity(0.5),
            spreadRadius: (contadorBloc.pageContador >= index - 0.5 &&
                    contadorBloc.pageContador < index + 0.5)
                ? 4
                : 1,
            blurRadius: (contadorBloc.pageContador >= index - 0.5 &&
                    contadorBloc.pageContador < index + 0.5)
                ? 4
                : 2,
            offset: (contadorBloc.pageContador >= index - 0.5 &&
                    contadorBloc.pageContador < index + 0.5)
                ? Offset(0, 0)
                : Offset(2, 3),
          ),
        ],
      ),
      margin: EdgeInsets.all(responsive.ip(1)),
      child: ClipRRect(
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
          width: responsive.wp(50),
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
                imageUrl: '$apiBaseURL/${companyData.companyImage}',
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
                        '${companyData.companyName}',
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
    );
  }
}

class _Puntos extends StatelessWidget {
  final int index;
  _Puntos(this.index);

  @override
  Widget build(BuildContext context) {
    final contadorBloc = ProviderBloc.contadorPagina(context);
    return Container(
      width: 10,
      height: 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: (contadorBloc.pageContador >= index - 0.5 &&
                contadorBloc.pageContador < index + 0.5)
            ? Colors.redAccent
            : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
