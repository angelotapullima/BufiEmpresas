import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:bufi_empresas/src/bloc/Sucursal/detalleSubisidiaryBloc.dart';
import 'package:bufi_empresas/src/page/Sucursales/Productos/GridviewProductosPorSucursal.dart';
import 'package:bufi_empresas/src/page/Sucursales/Servicios/GridviewServiciosPorSucursal.dart';
import 'package:bufi_empresas/src/theme/theme.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/widgets/sliver_header_delegate.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';

class DetalleSubsidiary extends StatelessWidget {
  const DetalleSubsidiary({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubsidiaryModel sucursal = ModalRoute.of(context).settings.arguments;
    final productoBloc = ProviderBloc.productos(context);
    productoBloc.listarProductosPorSucursal(sucursal.idSubsidiary);

    final provider = Provider.of<DetailSubsidiaryBloc>(context, listen: false);

    provider.changeToInformation();

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                CebeceraItem(
                  nombreSucursal: sucursal.subsidiaryName,
                ),
                SelectCategory(),
                ValueListenableBuilder<PageDetailsSucursal>(
                    valueListenable: provider.page,
                    builder: (_, value, __) {
                      return (value == PageDetailsSucursal.productos)
                          ? GridviewProductoPorSucursal(
                              idSucursal: sucursal.idSubsidiary,
                            )
                          : (value == PageDetailsSucursal.informacion)
                              ? InformacionWidget(
                                  idSucursal: sucursal.idSubsidiary,
                                )
                              : (value == PageDetailsSucursal.servicios)
                                  ? GridviewServiciosPorSucursal(
                                      idSucursal: sucursal.idSubsidiary,
                                    )
                                  : Container();
                    })
              ],
            ),
          )
        ],
      ),
    ));
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
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 10),
      sliver: SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          child: StreamBuilder(
              stream: sucursalBloc.subsidiaryIdStream,
              builder:
                  (context, AsyncSnapshot<List<SubsidiaryModel>> snapshot) {
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
                            Row(
                              children: [
                                Container(
                                  width: responsive.wp(30),
                                  child: RatingBar.readOnly(
                                    size: 20,
                                    initialRating:
                                        ('${snapshot.data[0].listCompany.companyRating}' !=
                                                    null &&
                                                '${snapshot.data[0].listCompany.companyRating}' !=
                                                    'null')
                                            ? double.parse(
                                                '${snapshot.data[0].listCompany.companyRating}')
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
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 28, color: Colors.red[700]),
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
                            SizedBox(height: responsive.hp(2.5)),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.clock,
                                  color: Colors.red,
                                  size: 22,
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
                                    color: Colors.red[700], size: 22),
                                SizedBox(
                                  width: responsive.wp(2),
                                ),
                                Text(
                                  '${snapshot.data[0].subsidiaryCellphone}',
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
                                Icon(Icons.mail,
                                    size: 28, color: Colors.red[700]),
                                SizedBox(
                                  width: responsive.wp(2),
                                ),
                                Text(
                                  '${snapshot.data[0].subsidiaryEmail}',
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: responsive.hp(2.5)),
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.home,
                                    color: Colors.red, size: 22),
                                SizedBox(width: responsive.wp(2)),
                                Text(
                                  '${snapshot.data[0].subsidiaryPrincipal}',
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: responsive.hp(2.5)),
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.home,
                                    color: Colors.red[800], size: 22),
                                SizedBox(width: responsive.wp(2)),
                                Text(
                                  '${snapshot.data[0].subsidiaryCoordX}',
                                  style: TextStyle(
                                    fontSize: responsive.ip(2),
                                  ),
                                ),
                              ],
                            )
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
              }),
        ),
      ),
    );
  }
}

const selectCategory = <String>['Información', 'Productos', 'Servicios'];

class SelectCategory extends StatelessWidget {
  final _selected = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetailSubsidiaryBloc>(context, listen: false);

    final responsive = Responsive.of(context);
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverCustomHeaderDelegate(
        maxHeight: responsive.hp(6),
        minHeight: responsive.hp(6),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              selectCategory.length,
              (i) => ValueListenableBuilder(
                valueListenable: _selected,
                builder: (_, value, __) => CupertinoButton(
                  padding: EdgeInsets.zero,
                  pressedOpacity: 1,
                  onPressed: () {
                    _selected.value = i;

                    if (i == 0) {
                      provider.changeToInformation();
                    } else if (i == 1) {
                      provider.changeToProductos();
                    } else {
                      provider.changeToServicios();
                    }
                    print(i);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: responsive.hp(.2),
                      left: responsive.wp(5),
                      right: responsive.wp(5),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: (i == value)
                                ? InstagramColors.pink
                                : Colors.transparent,
                            width: 2.5),
                      ),
                    ),
                    child: Text(
                      selectCategory[i],
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          color: (i == value)
                              ? null
                              : Theme.of(context).dividerColor,
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.ip(1.7)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CebeceraItem extends StatelessWidget {
  final String nombreSucursal;
  const CebeceraItem({Key key, @required this.nombreSucursal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 10),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: responsive.hp(5),
          child: Row(
            children: [
              BackButton(),
              Text(
                nombreSucursal,
                style: TextStyle(
                    fontSize: responsive.ip(2), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
