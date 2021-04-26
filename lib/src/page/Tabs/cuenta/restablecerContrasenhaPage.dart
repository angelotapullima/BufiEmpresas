import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/bloc/restablecerPassword_bloc.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class RestablecerContrasenhaPage extends StatefulWidget {
  const RestablecerContrasenhaPage({Key key}) : super(key: key);

  @override
  _RestablecerContrasenhaPageState createState() =>
      _RestablecerContrasenhaPageState();
}

class _RestablecerContrasenhaPageState
    extends State<RestablecerContrasenhaPage> {
  final _cargando = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final passwordBloc = ProviderBloc.restabContra(context);
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _cargando,
          builder: (BuildContext context, bool dataToque, Widget child) {
            return Stack(
              children: [
                SafeArea(
                  child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
                _form(context, responsive, passwordBloc),
                (dataToque)
                    ? Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: responsive.wp(10)),
                          padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(10)),
                          width: double.infinity,
                          height: responsive.hp(13),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: responsive.wp(10),
                                vertical: responsive.wp(6)),
                            height: responsive.ip(4),
                            width: responsive.ip(4),
                            child: Image(
                                image: AssetImage('assets/loading.gif'),
                                fit: BoxFit.contain),
                          ),
                        ),
                      )
                    : Container()
              ],
            );
          }),
    );
  }

  Widget _form(BuildContext context, Responsive responsive,
      RestablecerPasswordBloc passwordBloc) {
    return SafeArea(
        child: Container(
      child: Center(
        child: Column(
          children: [
            Spacer(),
            Text(
              "Restablecer Contraseña",
              style: TextStyle(
                  fontSize: responsive.ip(3), fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: responsive.wp(10),
            ),
            _pass(responsive, 'Nueva contraseña', passwordBloc),
            _pass2(responsive, 'Confirmar contraseña', passwordBloc),
            _botonLogin(context, passwordBloc, responsive),
            Spacer()
          ],
        ),
      ),
    ));
  }

  Widget _pass(Responsive responsive, String titulo,
      RestablecerPasswordBloc passwordBloc) {
    return StreamBuilder(
      stream: passwordBloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: responsive.hp(2),
            left: responsive.wp(6),
            right: responsive.wp(6),
          ),
          child: TextField(
            obscureText: true,
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              fillColor: Theme.of(context).dividerColor,
              hintText: titulo,
              hintStyle: TextStyle(
                  fontSize: responsive.ip(1.8),
                  fontFamily: 'Montserrat',
                  color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              contentPadding: EdgeInsets.all(
                responsive.ip(2),
              ),
              errorText: snapshot.error,
              suffixIcon: Icon(
                Icons.lock_outline,
                color: Color(0xFFF93963),
              ),
            ),
            onChanged: passwordBloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _pass2(Responsive responsive, String titulo,
      RestablecerPasswordBloc passwordBloc) {
    return StreamBuilder(
      stream: passwordBloc.passwordConfirmStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: responsive.hp(2),
            left: responsive.wp(6),
            right: responsive.wp(6),
          ),
          child: TextField(
            obscureText: true,
            textAlign: TextAlign.left,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              fillColor: Theme.of(context).dividerColor,
              hintText: titulo,
              hintStyle: TextStyle(
                  fontSize: responsive.ip(1.8),
                  fontFamily: 'Montserrat',
                  color: Colors.black54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              contentPadding: EdgeInsets.all(
                responsive.ip(2),
              ),
              errorText: snapshot.error,
              suffixIcon: Icon(
                Icons.lock_outline,
                color: Color(0xFFF93963),
              ),
            ),
            onChanged: passwordBloc.changePasswordConfirm,
          ),
        );
      },
    );
  }

  Widget _botonLogin(BuildContext context, RestablecerPasswordBloc passwordBloc,
      Responsive responsive) {
    return StreamBuilder(
        stream: passwordBloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Padding(
            padding: EdgeInsets.only(
              top: responsive.hp(2),
              left: responsive.wp(6),
              right: responsive.wp(6),
            ),
            child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.all(0.0),
                  child: Text('Confirmar'),
                  color: Color(0xFFF93963),
                  textColor: Colors.white,
                  onPressed: (snapshot.hasData)
                      ? () => _submit(context, passwordBloc)
                      : null,
                )),
          );
        });
  }

  _submit(BuildContext context, RestablecerPasswordBloc bloc) async {
    _cargando.value = true;
    // final int code = await bloc.login('${bloc.email}', '${bloc.password}');

    // if (code == 1) {
    //   obtenerprimerIdCompany(context);
    //   final pref = Preferences();
    //   obtenerprimerIdSubsidiary(context, pref.idSeleccionNegocioInicio);
    //   Navigator.pushReplacementNamed(context, 'home');
    // } else if (code == 2) {
    //   print(code);
    //   showToast1('Ocurrio un error', 2, ToastGravity.CENTER);
    // } else if (code == 3) {
    //   print(code);
    //   showToast1('Datos incorrectos', 2, ToastGravity.CENTER);
    //}

    _cargando.value = false;
  }
}
