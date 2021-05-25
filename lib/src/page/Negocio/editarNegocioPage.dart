import 'package:bufi_empresas/src/bloc/categoria_bloc.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi_empresas/src/models/categoriaModel.dart';
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

  //DropdownTipoEmpresa
  String dropdownTipo = 'Seleccionar';
  String dropdownid = '4';
  List<String> spinnerItemsTipo = [
    'Seleccionar',
    'Pequeña',
    'Mediana',
    'Grande',
  ];

  //DropdownCategorias
  String dropdownCategorias = 'Seleccionar';
  int cantItems = 0;
  List<String> list;
  String idCategoria = 'false';

  //SwitchListTile
  bool _d = false;
  bool _e = false;
  bool _t = false;
  int cantItem = 0;

  //TextEditingNegocio
  TextEditingController _nombreEmpresaController = TextEditingController();
  TextEditingController _rucEmpresaController = TextEditingController();

  //TextEditingSucursalPrincipal
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

      if (widget.companyModel.idCategory != '') {
        dropdownid = widget.companyModel.idCategory;
      }

      if (widget.companyModel.companyEntrega == '1') {
        _e = true;
      }
      if (widget.companyModel.companyDelivery == '1') {
        _d = true;
      }
      if (widget.companyModel.companyTarjeta == '1') {
        _t = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final editarNegocioBloc = ProviderBloc.editarNegocio(context);
    editarNegocioBloc.changeCargandoEditNegocio(false);

    final categoriasBloc = ProviderBloc.categoria(context);
    categoriasBloc.obtenerCategorias();

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
                              _form(responsive, context, categoriasBloc),
                              (snapshot.data)
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container()
                            ],
                          );
                        } else {
                          return Stack(
                            children: [
                              _form(responsive, context, categoriasBloc)
                            ],
                          );
                        }
                      },
                    ))),
          ],
        ),
      )),
    );
  }

  Widget _form(Responsive responsive, BuildContext context,
      CategoriaBloc categoriaBloc) {
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
                SizedBox(height: responsive.hp(2)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Correo electrónico',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _imputFieldNull(responsive, 'Correo electrónico',
                      _emailEmpresaController),
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
                    'Categoria',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _categoria(categoriaBloc, responsive),
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
                  child: _delivery(),
                ),
                SizedBox(height: responsive.hp(2)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(3),
                    //vertical: responsive.hp(7),
                  ),
                  child: _entrega(),
                ),
                SizedBox(height: responsive.hp(2)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(3),
                    //vertical: responsive.hp(7),
                  ),
                  child: _tarjeta(),
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
              dropdownid = 'Pequeña';
            } else if (data == 'Mediana') {
              dropdownid = 'Mediana';
            } else if (data == 'Grande') {
              dropdownid = 'Grande';
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
  }

  Widget _categoria(CategoriaBloc categoriaBloc, Responsive responsive) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5)),
      child: StreamBuilder(
          stream: categoriaBloc.categoriaStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<CategoriaModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                if (cantItems == 0) {
                  list = [];

                  list.add('Seleccionar');
                  for (int i = 0; i < snapshot.data.length; i++) {
                    String nombreCategoria = snapshot.data[i].categoryName;
                    list.add(nombreCategoria);
                    if (widget.companyModel.idCategory ==
                        snapshot.data[i].idCategory) {
                      dropdownCategorias = snapshot.data[i].categoryName;
                      idCategoria = snapshot.data[i].idCategory;
                    }
                  }
                }

                return dropCategoria(responsive, list, snapshot.data);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            } else {
              return Center(
                child: Text("No hay ninguna información"),
              );
            }
          }),
    );
  }

  Widget dropCategoria(
      Responsive responsive, List<String> lista, List<CategoriaModel> sedes) {
    return DropdownButton(
      isExpanded: true,
      underline: Container(),
      value: dropdownCategorias,
      items: lista.map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: Colors.grey[800]),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (String value) {
        setState(() {
          dropdownCategorias = value;
          cantItems++;

          obtenerIdSedes(value, sedes);
        });
      },
    );
  }

  void obtenerIdSedes(String dato, List<CategoriaModel> list) {
    idCategoria = 'false';
    for (int i = 0; i < list.length; i++) {
      if (dato == list[i].categoryName) {
        idCategoria = list[i].idCategory;
      }
    }
    print('id $idCategoria');
  }

  Widget _delivery() {
    return SwitchListTile(
        value: _d,
        title: Text('¿Realiza Delivery?'),
        activeColor: Colors.redAccent,
        onChanged: (value) {
          setState(() {
            cantItem++;
            _d = value;
            //_d = value;s
          });
        });
  }

  Widget _entrega() {
    return SwitchListTile(
        value: _e,
        title: Text('¿Realiza Entregas?'),
        activeColor: Colors.redAccent,
        onChanged: (value) => setState(() {
              cantItem++;
              _e = value;
            }));
  }

  Widget _tarjeta() {
    return SwitchListTile(
        value: _t,
        title: Text('¿Acepta Tarjeta?'),
        activeColor: Colors.redAccent,
        onChanged: (value) => setState(() {
              cantItem++;
              _t = value;
            }));
  }

  Widget _button(Responsive responsive) {
    final editarNegocioBloc = ProviderBloc.editarNegocio(context);
    final companySubsidiaryModel = CompanySubsidiaryModel();

    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        onPressed: () async {
          if (keyForm.currentState.validate()) {
            Pattern pattern = '^(\[[0-9]{9}\)';
            RegExp regExp = new RegExp(pattern);
            if (dropdownTipo == 'Seleccionar') {
              utils.showToast(
                  context, 'Por favor debe selecionar un tipo de Empresa');
            } else if (idCategoria == 'false') {
              utils.showToast(
                  context, 'Por favor debe selecionar una categoria');
            } else if (_cellEmpresaController.text.isEmpty) {
              utils.showToast(
                  context, 'Por favor debe ingresar un número de celular');
            } else if (!regExp.hasMatch(_cell2EmpresaController.text) &&
                _cell2EmpresaController.text != '') {
              utils.showToast(
                  context, 'Por favor ingresar solo 9 números en celular 2');
            } else {
              companySubsidiaryModel.idCompany = widget.companyModel.idCompany;
              companySubsidiaryModel.companyName =
                  _nombreEmpresaController.text;
              companySubsidiaryModel.companyType = dropdownTipo;
              companySubsidiaryModel.subsidiaryEmail =
                  _emailEmpresaController.text;
              companySubsidiaryModel.idCategory = idCategoria;
              companySubsidiaryModel.subsidiaryCellphone =
                  _cellEmpresaController.text;
              companySubsidiaryModel.subsidiaryCellphone2 =
                  _cell2EmpresaController.text;
              companySubsidiaryModel.companyRuc = _rucEmpresaController.text;
              companySubsidiaryModel.subsidiaryAddress =
                  _direccionEmpresaController.text;
              companySubsidiaryModel.subsidiaryCoordX =
                  _coordXEmpresaController.text;
              companySubsidiaryModel.subsidiaryCoordY =
                  _coordYEmpresaController.text;
              companySubsidiaryModel.subsidiaryOpeningHours =
                  _openingHoursEmpresaController.text;
              companySubsidiaryModel.companyShortcode =
                  widget.companyModel.companyShortcode;
              if (_d) {
                companySubsidiaryModel.companyDelivery = 'on';
              }
              if (_e) {
                companySubsidiaryModel.companyEntrega = 'on';
              }
              if (_t) {
                companySubsidiaryModel.companyTarjeta = 'on';
              }

              final int code =
                  await editarNegocioBloc.updateNegocio(companySubsidiaryModel);
              if (code == 1) {
                final detallenegocio = ProviderBloc.negocios(context);
                detallenegocio
                    .obtenernegociosxID(widget.companyModel.idCompany);
                print(code);
                print("Información Actualizada");
                utils.showToast(context, 'Información Actualizada');
                Navigator.pop(context);
              } else {
                utils.showToast(context, 'Faltan registrar datos');
              }
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
