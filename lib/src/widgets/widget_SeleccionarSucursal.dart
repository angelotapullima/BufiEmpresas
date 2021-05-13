import 'dart:math';

import 'package:bufi_empresas/src/bloc/ContadorPages/contadorPaginaListarSucursales.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ListarSucursales extends StatelessWidget {
  final CarouselController buttonCarouselController = CarouselController();
  //final ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    /*final _pageController =
        PageController(viewportFraction: 0.6, initialPage: 0);*/
    final sucursalesBloc = ProviderBloc.negocios(context);
    final preferences = Preferences();
    sucursalesBloc.obtenersucursales(preferences.idSeleccionNegocioInicio);
    final responsive = Responsive.of(context);
    final contadorBloc = ProviderBloc.contadorListaSucursales(context);
    contadorBloc.changeContador(0);
    final empresaNameBloc = ProviderBloc.nameEmpresa(context);
    empresaNameBloc.changeEmpresaName(preferences.nombreCompany);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder(
                stream: empresaNameBloc.empresaNameStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      empresaNameBloc.empresaName,
                      style: TextStyle(
                          fontSize: responsive.ip(2.5),
                          fontWeight: FontWeight.bold),
                    );
                  } else {
                    return Center(child: Text(''));
                  }
                }),
          ],
        ),
        Container(
          height: responsive.hp(9),
          child: StreamBuilder(
            //stream: negociosBloc.negociosStream,
            stream: sucursalesBloc.suscursaStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<SubsidiaryModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  final size = MediaQuery.of(context).size;
                  return CarouselSlider.builder(
                    itemCount: snapshot.data.length,
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      height: size.height,
                      aspectRatio: 2,
                      viewportFraction: 0.7,
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
                        actualizarEstadoSucursal(
                            context, snapshot.data[index].idSubsidiary);
                        actualizarBusquedaPagos(context);
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
                        actualizarEstadoSucursal(
                            context, snapshot.data[index].idSubsidiary);
                        actualizarBusquedaPagos(context);
                      });*/
                } else {
                  return Center(child: Text("No tiene Sucursales"));
                }
              } else {
                return Center(child: Text("Lista Nula"));
              }
            },
          ),
        ),
        Container(
          height: responsive.hp(5),
          child: StreamBuilder(
            stream: sucursalesBloc.suscursaStream,
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
      SubsidiaryModel servicioData,
      Responsive responsive,
      ContadorPaginaListarSucursalesBloc contadorBloc,
      int index) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, "detalleNegocio", arguments: servicioData);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
          /*Colors.primaries[Random().nextInt(Colors.primaries.length)]*/,
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: responsive.wp(5),
                backgroundColor:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: Icon(Icons.store, color: Colors.white),
              ),
              SizedBox(
                width: responsive.wp(2),
              ),
              Text(
                '${servicioData.subsidiaryName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: responsive.ip(2.2),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
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
    final contadorBloc = ProviderBloc.contadorListaSucursales(context);

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
