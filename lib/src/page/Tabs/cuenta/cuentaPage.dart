import 'package:bufi_empresas/src/database/company_db.dart';
import 'package:bufi_empresas/src/database/detallePedido_database.dart';
import 'package:bufi_empresas/src/database/good_db.dart';
import 'package:bufi_empresas/src/database/pedidos_db.dart';
import 'package:bufi_empresas/src/database/producto_bd.dart';
import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/preferencias/preferencias_usuario.dart';
import 'package:bufi_empresas/src/utils/customCacheManager.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CuentaPage extends StatefulWidget {
  CuentaPage({Key key}) : super(key: key);

  @override
  _CuentaPageState createState() => _CuentaPageState();
}

class _CuentaPageState extends State<CuentaPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: _datos(context, responsive),
      )),
    );
  }

  Widget _datos(BuildContext context, Responsive responsive) {
    final prefs = new Preferences();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: responsive.hp(3.5)),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: responsive.ip(1.5),
            ),
            padding: EdgeInsets.symmetric(
              vertical: responsive.hp(2),
              horizontal: responsive.wp(2),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: responsive.ip(10),
                    height: responsive.ip(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager(),
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image(
                              image: AssetImage('assets/no-image.png'),
                              fit: BoxFit.cover),
                        ),
                        errorWidget: (context, url, error) => Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(child: Icon(Icons.error))),
                        imageUrl: '${prefs.userImage}',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: responsive.wp(4.5),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          '${prefs.personName} ${prefs.personSurname}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: responsive.ip(1.8),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${prefs.userEmail}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: responsive.ip(1.8)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${prefs.userNickname}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: responsive.ip(1.8)),
                        ),
                      ],
                    ),
                  )
                ]),
          ),
          SizedBox(
            height: responsive.hp(2),
          ),
          _item(responsive, "Mi perfil", "perfil", FontAwesomeIcons.user),

          /* _item(responsive, "Políticas de Privacidad", "pruebas",
              Icons.privacy_tip_outlined),

          _item(
              responsive, "Términos y Condiciones", "pruebas", Icons.save_alt),

          _item(responsive, "Configuración", "pruebas", Icons.settings),*/

          //SizedBox(height: responsive.hp(2)),

          Container(
              margin: EdgeInsets.symmetric(
                  horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
              width: double.infinity,
              height: responsive.ip(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: ListTile(
                title: Text("Versión de la app",
                    style: TextStyle(
                        //color: Colors.red,
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold)),
                subtitle: Text("Versión 1.0",
                    style: TextStyle(
                        //color: Colors.red,
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold)),
              )),

          Padding(
            padding: EdgeInsets.all(responsive.ip(1.5)),
            child: InkWell(
              onTap: () async {
                prefs.clearPreferences();
                final pedidosDb = PedidosDatabase();
                pedidosDb.deletePedidos();
                final companyDb = CompanyDatabase();
                companyDb.deleteCompany();
                final detallePedidoDb = DetallePedidoDatabase();
                detallePedidoDb.deleteDetallePedidos();
                final goodDb = GoodDatabase();
                goodDb.deleteGood();
                final productosDb = ProductoDatabase();
                productosDb.deleteProducto();
                final subsidiaryDb = SubsidiaryDatabase();
                subsidiaryDb.deleteSubsidiary();

                Navigator.pushNamedAndRemoveUntil(
                    context, 'login', (route) => false);
              },
              child: new Container(
                //width: 100.0,
                height: responsive.hp(6),
                decoration: new BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                  color: Colors.white,
                  border: new Border.all(color: Colors.grey[300], width: 1.0),
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                child: new Center(
                  child: new Text(
                    'Cerrar sesión',
                    style: new TextStyle(
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.w800,
                        color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(Responsive responsive, nombre, ruta, IconData icon) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: responsive.ip(1.5), vertical: responsive.ip(0.5)),
        width: double.infinity,
        height: responsive.ip(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: ListTile(
          title: Text(nombre,
              style: TextStyle(
                  //color: Colors.red,
                  fontSize: responsive.ip(2),
                  fontWeight: FontWeight.bold)),
          leading: Icon(icon),
          trailing: Icon(Icons.arrow_right_outlined),
          onTap: () {
            Navigator.pushNamed(context, ruta);
          },
        ));
  }
}
