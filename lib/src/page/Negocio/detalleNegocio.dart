import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi_empresas/src/models/companyModel.dart';
import 'package:bufi_empresas/src/page/Negocio/editarNegocioPage.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rating_bar/rating_bar.dart';

class DetalleNegocio extends StatefulWidget {
  // String idCompany;
  // DetalleNegocio(this.idCompany);

  @override
  _DetalleNegocioState createState() => _DetalleNegocioState();
}

class _DetalleNegocioState extends State<DetalleNegocio>
    with SingleTickerProviderStateMixin {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    //definir una variable que se paso por el navigator
    CompanyModel company = ModalRoute.of(context).settings.arguments;
    final detallenegocio = ProviderBloc.negocios(context);
    detallenegocio.obtenernegociosxID(company.idCompany);
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: detallenegocio.detalleNegStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<CompanySubsidiaryModel>> snapshot) {
            List<CompanySubsidiaryModel> negocio = snapshot.data;
            if (snapshot.hasData) {
              return _custonScroll(responsive, negocio[0]);
              //_crearAppbar(responsive, negocio[0]);
            } else if (snapshot.hasError) {
              return snapshot.error;
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _custonScroll(Responsive responsive, CompanySubsidiaryModel company) {
    var dateCreacion = obtenerNombreMes(company.companyCreatedAt);
    return CustomScrollView(
      controller: controller,
      slivers: [
        _crearAppbar(responsive, company),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: responsive.hp(3),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: responsive.wp(30),
                        child: RatingBar.readOnly(
                          size: 20,
                          initialRating:
                              double.parse('${company.companyStatus}'),
                          isHalfAllowed: true,
                          halfFilledIcon: Icons.star_half,
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          filledColor: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: responsive.hp(3),
                    ),
                    Text(
                      "Información",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: responsive.ip(2.7),
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(height: responsive.hp(2.5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Delivery:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: responsive.wp(1),
                            ),
                            ('${company.companyDelivery}') == "1"
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)),
                                    child: Container(
                                        color: Colors.red,
                                        child: Icon(Icons.check,
                                            color: Colors.white, size: 22)),
                                  )
                                : Icon(Icons.error,
                                    color: Colors.black, size: 26),
                          ],
                        ),
                        SizedBox(width: responsive.wp(4)),
                        Row(
                          children: [
                            Text("Entrega:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(width: responsive.wp(1)),
                            ('${company.companyEntrega}') == "1"
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)),
                                    child: Container(
                                        color: Colors.red,
                                        child: Icon(Icons.check,
                                            color: Colors.white, size: 22)),
                                  )
                                : Icon(Icons.error,
                                    color: Colors.black, size: 26),
                          ],
                        ),
                        SizedBox(width: responsive.wp(4)),
                        Row(
                          children: [
                            Text("Tarjeta:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            // Icon(FontAwesomeIcons.phoneAlt,
                            //     color: Colors.red[700], size: 22),
                            SizedBox(
                              width: responsive.wp(1),
                            ),
                            ('${company.companyTarjeta}') == "1"
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22)),
                                    child: Container(
                                        color: Colors.red,
                                        child: Icon(Icons.check,
                                            color: Colors.white, size: 22)),
                                  )
                                : Icon(Icons.error,
                                    color: Colors.black, size: 26),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.hp(5)),
                    Row(
                      children: [
                        Text("Codigo Corto:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          '${company.companyShortcode}',
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
                        Text("Fecha de fundación:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          '$dateCreacion',
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("id Negocio:"),
                        SizedBox(
                          width: responsive.wp(2),
                        ),
                        Text(
                          ('${company.idCompany}'),
                          style: TextStyle(
                            fontSize: responsive.ip(2),
                          ),
                        )
                      ],
                    ),
                  ],
                )),
            SizedBox(
              height: responsive.hp(20),
            ),
            Center(
              child: SizedBox(
                width: responsive.wp(80),
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return EditarNegocioPage(companyModel: company);
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
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
                  child: Text("Editar Información",
                      style: TextStyle(
                          color: Colors.white, fontSize: responsive.ip(2.2))),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _crearAppbar(
      Responsive responsive, CompanySubsidiaryModel companyModel) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.white,
      expandedHeight: responsive.hp(30),
      floating: false,
      actions: [
        // GestureDetector(
        //   onTap: () {
        //     //Mandar el id company
        //     Navigator.pushNamed(context, 'actualizarNegocio',
        //         arguments: companyModel.idCompany);
        //   },
        //   child: Container(
        //     margin: EdgeInsets.symmetric(vertical: responsive.hp(1)),
        //     width: responsive.wp(25),
        //     decoration: BoxDecoration(
        //       color: Colors.red,
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     child: Center(
        //       child: Text(
        //         'Actualizar',
        //         style: TextStyle(color: Colors.white),
        //         textAlign: TextAlign.center,
        //       ),
        //     ),
        //   ),
        // ),
      ],
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          //color: Colors.red,
          height: responsive.hp(4),
          child: Text(
            '${companyModel.companyName}',
            style: TextStyle(
                color: Colors.black,
                fontSize: responsive.ip(3),
                fontWeight: FontWeight.bold),
          ),
        ),
        background: Stack(
          children: [
            Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    //cacheManager: CustomCacheManager(),
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
                    imageUrl: '$apiBaseURL/${companyModel.companyImage}',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black.withOpacity(.1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
