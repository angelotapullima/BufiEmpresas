import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/widgets/sliver_header_delegate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PrincipalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final preferences = Preferences();
    final responsive = Responsive.of(context);
    //final subsidiary = SubsidiaryModel();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            HeaderWidget(responsive: responsive, preferences: preferences),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: responsive.hp(1),
                  ),
                  /*
                  Container(
                    height: responsive.hp(13),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            IconButton(
                                icon: Icon(Icons.trending_down),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, "listaCategoriasAll");
                                }),
                            Text("Categorias")
                          ],
                        ),
                        SizedBox(
                          width: responsive.wp(1.5),
                        ),
                        Expanded(child: ListCategoriasPrincipal()),
                      ],
                    ),
                  ),*/
                  //ListCategoriasPrincipal(),
                  SizedBox(
                    height: responsive.hp(1),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: responsive.hp(10),
                        width: responsive.wp(40),
                        child: Column(
                          children: [
                            Text('Atendidos',
                                style: TextStyle(color: Colors.white)),
                            Text('400'),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(
                        width: responsive.wp(5),
                      ),
                      Container(
                        height: responsive.hp(10),
                        width: responsive.wp(40),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                      )
                    ],
                  ),
                  Negocios(),
                  Negocios(),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key key,
    @required this.responsive,
    @required this.preferences,
  }) : super(key: key);

  final Responsive responsive;
  final Preferences preferences;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        floating: true,
        delegate: SliverCustomHeaderDelegate(
          maxHeight: responsive.hp(13.5),
          minHeight: responsive.hp(13.5),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
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
                    SizedBox(
                      width: responsive.wp(3),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hola, '),
                        Text(
                          '${preferences.personName}',
                          style: GoogleFonts.pacifico(
                            textStyle: TextStyle(
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class Negocios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final negociosBloc = ProviderBloc.negocios(context);
    negociosBloc.obtenernegocios();
    final responsive = Responsive.of(context);

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
            //SizedBox(width: 30,),
            GestureDetector(
              onTap: () async {
                final buttonBloc = ProviderBloc.tabs(context);
                buttonBloc.changePage(3);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.pink,
                ),
                padding: EdgeInsets.all(responsive.ip(.8)),
                child: Text(
                  "Ver Todos",
                  style: TextStyle(
                      fontSize: responsive.ip(1.5),
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  //textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),
        Container(
          child: StreamBuilder(
            stream: negociosBloc.negociosStream,
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
                  return Center(child: CupertinoActivityIndicator());
                }
              } else {
                return Center(child: CupertinoActivityIndicator());
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _crearItem(
      BuildContext context, CompanyModel servicioData, Responsive responsive) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "detalleNegocio", arguments: servicioData);
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: responsive.wp(42.5),
            child: Card(
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: responsive.ip(10),
                            height: responsive.ip(10),
                            child: CachedNetworkImage(
                              //cacheManager: CustomCacheManager(),
                              placeholder: (context, url) => Image(
                                  image: AssetImage('assets/jar-loading.gif'),
                                  fit: BoxFit.cover),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              imageUrl:
                                  '$apiBaseURL/${servicioData.companyImage}',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.heart,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${servicioData.companyName}',
                      style: TextStyle(
                        fontSize: responsive.ip(2),
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      servicioData.idCompany,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.ip(1.9),
                      ),
                    ),
                    Text(
                      '${servicioData.companyType}',
                      style: TextStyle(
                          fontSize: responsive.ip(1.9),
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
