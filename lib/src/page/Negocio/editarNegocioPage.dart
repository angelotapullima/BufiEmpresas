import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:bufi_empresas/src/utils//utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditarNegocioPage extends StatefulWidget {
  final CompanySubsidiaryModel companyModel;
  const EditarNegocioPage({Key key, this.companyModel}) : super(key: key);

  @override
  _EditarNegocioPage createState() => _EditarNegocioPage();
}

class _EditarNegocioPage extends State<EditarNegocioPage> {
  final keyForm = GlobalKey<FormState>();

  String dropdownTipo = 'Seleccionar';
  String dropdownid = '4';
  List<String> spinnerItemsTipo = [
    'Seleccionar',
    'Pequeña',
    'Mediana',
    'Grande',
  ];

  TextEditingController _nombreEmpresaController = TextEditingController();
  TextEditingController _rucEmpresaController = TextEditingController();

  TextEditingController _cellEmpresaController = TextEditingController();
  TextEditingController _cell2EmpresaController = TextEditingController();
  TextEditingController _direccionEmpresaController = TextEditingController();
  TextEditingController _emailEmpresaController = TextEditingController();
  TextEditingController _coordXEmpresaController = TextEditingController();
  TextEditingController _coordYEmpresaController = TextEditingController();
  TextEditingController _openingHoursEmpresaController =
      TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nombreEmpresaController.text = widget.companyModel.companyName;
      _rucEmpresaController.text = widget.companyModel.companyRuc;
      dropdownTipo = widget.companyModel.companyType;

      _cellEmpresaController.text = widget.companyModel.subsidiaryCellphone;
      _cell2EmpresaController.text = widget.companyModel.subsidiaryCellphone2;
      _direccionEmpresaController.text = widget.companyModel.subsidiaryAddress;
      _emailEmpresaController.text = widget.companyModel.subsidiaryEmail;
      _coordXEmpresaController.text = widget.companyModel.subsidiaryCoordX;
      _coordYEmpresaController.text = widget.companyModel.subsidiaryCoordY;
      _openingHoursEmpresaController.text =
          widget.companyModel.subsidiaryOpeningHours;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final editarNegocioBloc = ProviderBloc.editarNegocio(context);
    editarNegocioBloc.changeCargandoEditNegocio(false);

    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
          child: Container(
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
        child: Column(
          children: [
            SizedBox(
              height: responsive.hp(2),
            ),
            Row(
              children: [
                BackButton(),
                Expanded(
                    child: Text(
                  "EDITAR: ${widget.companyModel.companyName}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: responsive.ip(2.5),
                      fontWeight: FontWeight.w700),
                )),
                SizedBox(
                  width: responsive.wp(3),
                )
              ],
            ),
            Expanded(
                child: Form(
                    key: keyForm,
                    child: StreamBuilder(
                      stream: editarNegocioBloc.cargandoEditNegocioStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            children: [
                              _form(responsive, context),
                              (snapshot.data)
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container()
                            ],
                          );
                        } else {
                          return Stack(
                            children: [_form(responsive, context)],
                          );
                        }
                      },
                    ))),
          ],
        ),
      )),
    );
  }

  Widget _form(Responsive responsive, BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: responsive.hp(2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Nombre Negocio',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _imputField(
                      responsive, 'Nombre Negocio', _nombreEmpresaController),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'RUC',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _imputField(responsive, 'RUC', _rucEmpresaController),
                ),
                SizedBox(height: responsive.hp(2)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Dirección',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _imputField(
                      responsive, 'Dirección', _direccionEmpresaController),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Tipo Empresa',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _tipoEmpresa(responsive, spinnerItemsTipo),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Celular',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Row(
                    children: [
                      Container(
                        width: responsive.wp(45),
                        child: _celularEmpresa(
                            responsive, 'Celular', _cellEmpresaController),
                      ),
                      Spacer(),
                      Container(
                        width: responsive.wp(45),
                        child: _celularEmpresaNull(
                            responsive, 'Celular 2', _cell2EmpresaController),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Coordenadas X,Y',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Row(
                    children: [
                      Container(
                        width: responsive.wp(45),
                        child: _imputFieldNull(responsive, 'Coordenada X',
                            _coordXEmpresaController),
                      ),
                      Spacer(),
                      Container(
                        width: responsive.wp(45),
                        child: _imputFieldNull(responsive, 'Coordenada Y',
                            _coordYEmpresaController),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Horario Atención',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _imputFieldNull(responsive, 'Horario Atención',
                      _openingHoursEmpresaController),
                ),
                SizedBox(height: responsive.hp(2)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(3),
                    //vertical: responsive.hp(7),
                  ),
                  child: _button(responsive),
                ),
                SizedBox(height: responsive.hp(2)),
                SizedBox(height: responsive.hp(2)),
                SizedBox(height: responsive.hp(2)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _imputField(
      Responsive responsive, String text, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintStyle: form2,
          hintText: text,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[300]),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'El campo no debe estar vacio';
          } else {
            return null;
          }
        });
  }

  Widget _celularEmpresa(
      Responsive responsive, String text, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        maxLength: 9,
        decoration: InputDecoration(
          hintStyle: form2,
          hintText: text,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[300]),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
        ),
        validator: (value) {
          Pattern pattern = '^(\[[0-9]{9}\)';
          RegExp regExp = new RegExp(pattern);
          if (regExp.hasMatch(value)) {
            return null;
          } else {
            return 'Sólo 9 números';
          }
        });
  }

  Widget _celularEmpresaNull(
      Responsive responsive, String text, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      maxLength: 9,
      decoration: InputDecoration(
        hintStyle: form2,
        hintText: text,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[300]),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }

  Widget _imputFieldNull(
      Responsive responsive, String text, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintStyle: form2,
        hintText: text,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[300]),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }

  Widget _tipoEmpresa(Responsive responsive, List<String> list) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(4),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        value: dropdownTipo,
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        underline: Container(),
        style: TextStyle(color: Colors.black, fontSize: 18),
        onChanged: (String data) {
          setState(() {
            dropdownTipo = data;
            if (data == 'Pequeña') {
              dropdownid = '1';
            } else if (data == 'Mediana') {
              dropdownid = '2';
            } else if (data == 'Grande') {
              dropdownid = '3';
            } else {
              dropdownid = '4';
            }
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
    /*  return TextFormField(
        controller: _tipoController,
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,

        //style: GoogleFonts.baloo(fontSize: 8, color: Colors.black),
        decoration: InputDecoration(
          hintText: "Tipo(1:Correctivo, 2:Preventivo)",
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          //icon: Icon(Icons.person)
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'El campo no debe estar vacio';
          }
        }); */
  }

  Widget _button(Responsive responsive) {
    // final editarSubsidiaryBloc = ProviderBloc.editSubsidiary(context);
    // final subsidiaryModel = SubsidiaryModel();

    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        onPressed: () async {
          if (keyForm.currentState.validate()) {
            Pattern pattern = '^(\[[0-9]{9}\)';
            RegExp regExp = new RegExp(pattern);
            if (_cellEmpresaController.text.isEmpty) {
              utils.showToast(
                  context, 'Por favor debe ingresar un número de celular');
            } else if (!regExp.hasMatch(_cell2EmpresaController.text) &&
                _cell2EmpresaController.text != '') {
              utils.showToast(
                  context, 'Por favor ingresar solo 9 números en celular 2');
            } else {
              // subsidiaryModel.idSubsidiary =
              //     widget.subsidiaryModel.idSubsidiary;
              // subsidiaryModel.subsidiaryName = _nombreEmpresaController.text;
              // subsidiaryModel.subsidiaryCellphone = _cellEmpresaController.text;
              // subsidiaryModel.subsidiaryCellphone2 =
              //     _cell2EmpresaController.text;
              // subsidiaryModel.subsidiaryAddress =
              //     _direccionEmpresaController.text;
              // subsidiaryModel.subsidiaryEmail = _emailEmpresaController.text;
              // subsidiaryModel.subsidiaryCoordX = _coordXEmpresaController.text;
              // subsidiaryModel.subsidiaryCoordY = _coordYEmpresaController.text;
              // subsidiaryModel.subsidiaryOpeningHours =
              //     _openingHoursEmpresaController.text;
              // print(subsidiaryModel.subsidiaryCellphone);

              // final int code =
              //     await editarSubsidiaryBloc.editarSubsidiary(subsidiaryModel);
              // if (code == 1) {
              //   final sucursalBloc = ProviderBloc.sucursal(context);
              //   sucursalBloc
              //       .obtenerSucursalporId(widget.subsidiaryModel.idSubsidiary);
              //   print(code);
              //   print("Información Actualizada");
              //   utils.showToast(context, 'Información Actualizada');
              //   Navigator.pop(context);
              // } else {
              //   utils.showToast(context, 'Faltan registrar datos');
              // }
            }
          }
        },
        textColor: Colors.white,
        child: Text('ACTUALIZAR', style: utils.subtitulotexto),
        color: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.red[900]),
        ),
      ),
    );
  }
}
