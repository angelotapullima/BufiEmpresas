import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:flutter/material.dart';

class MostrarNegocio extends StatelessWidget {
  const MostrarNegocio({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageController =
        PageController(viewportFraction: 0.9, initialPage: 0);
    final negociosBloc = ProviderBloc.negocios(context);
    negociosBloc.obtenernegocios();
    final responsive = Responsive.of(context);
    //contador para el PageView
    final contadorBloc = ProviderBloc.contadorPagina(context);
    contadorBloc.changeContador(0);
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
                  return PageView.builder(
                      itemCount: snapshot.data.length,
                      controller: _pageController,
                      itemBuilder: (BuildContext context, int index) {
                        return _crearItem(
                            context, snapshot.data[index], responsive);
                      },
                      onPageChanged: (int index) {
                        contadorBloc.changeContador(index);
                        final negociosBloc = ProviderBloc.negocios(context);
                        final preferences = Preferences();

                        preferences.idSeleccionNegocioInicio =
                            snapshot.data[index].idCompany;
                        obtenerprimerIdSubsidiary(
                            preferences.idSeleccionNegocioInicio);
                        negociosBloc.obtenersucursales(
                            preferences.idSeleccionNegocioInicio);
                      });
                } else {
                  return Center(child: Text('No tiene Negocios'));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        StreamBuilder(
          stream: negociosBloc.negociosStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              int totalNegociosPage = snapshot.data.length;
              if (snapshot.data.length > 0) {
                return StreamBuilder(
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
                          border: Border.all(color: Colors.grey[300]),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5),
                          vertical: responsive.hp(1.3),
                        ),
                        child: Text(
                          (contadorBloc.pageContador + 1).toString() +
                              '/' +
                              totalNegociosPage.toString(),
                        ),
                      );
                    });
              } else {
                return Center(child: Text('No tiene Negocios'));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }

  Widget _crearItem(
      BuildContext context, CompanyModel companyData, Responsive responsive) {
    return

        /*Container(
      child: Card(
        elevation: 2,
        color: (companyData.negocioEstadoSeleccion == '1')
            ? Colors.red
            : Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
          child: Text(
            '${companyData.companyName}',
            style: TextStyle(
              fontSize: responsive.ip(2),
              color: Colors.black,
            ),
          ),
        ),
      ),
    );*/

        Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(2, 3),
          ),
        ],
      ),
      margin: EdgeInsets.all(responsive.ip(1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${companyData.companyName}',
            style: TextStyle(
                fontSize: responsive.ip(2.3), fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          Text('${companyData.companyType}'),
          Text('${companyData.companyRating}'),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            SizedBox(width: 5),
            //Text('${data[index].subsidiaryGoodRating}'),
            Text('bien'),
            SizedBox(width: 10),
          ])
        ],
      ),
    );
  }
}
