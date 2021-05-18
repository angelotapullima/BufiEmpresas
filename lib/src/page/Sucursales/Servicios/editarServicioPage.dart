import 'dart:io';

import 'package:bufi_empresas/src/bloc/categoria_bloc.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/bloc/servicios/servicios_bloc.dart';
import 'package:bufi_empresas/src/models/subsidiaryService.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:bufi_empresas/src/utils//utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditarServicioPage extends StatefulWidget {
  final SubsidiaryServiceModel serviceModel;
  EditarServicioPage({this.serviceModel});
  @override
  _EditarServicioPage createState() => _EditarServicioPage();
}

class _EditarServicioPage extends State<EditarServicioPage> {
  final keyForm = GlobalKey<FormState>();
  final _cargando = ValueNotifier<bool>(false);

  File foto;

  //DropdownMoneda
  String dropdownTipo = 'Moneda';
  String dropdownid = 'S/';
  List<String> spinnerItemsTipo = [
    'Moneda',
    'Soles',
    'Dólares',
  ];

  //TextEditingProducto
  TextEditingController _nombreServicioController = TextEditingController();
  TextEditingController _precioServicioController = TextEditingController();
  TextEditingController _descripcinServicioController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nombreServicioController.text =
          widget.serviceModel.subsidiaryServiceName;
      _precioServicioController.text =
          widget.serviceModel.subsidiaryServicePrice;
      _descripcinServicioController.text =
          widget.serviceModel.subsidiaryServiceDescription;
      if (widget.serviceModel.subsidiaryServiceCurrency == '${r"$"}') {
        dropdownTipo = 'Dólares';
        dropdownid = '${r"$"}';
      } else {
        dropdownTipo = 'Soles';
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final serviceBloc = ProviderBloc.servi(context);
    serviceBloc.changeCargando(false);
    serviceBloc.obtenerAllServices();
    final categoriasBloc = ProviderBloc.categoria(context);
    categoriasBloc.obtenerItemSubcategoria();

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
                  "Agregar nuevo Servicio",
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
                  stream: serviceBloc.cargandotream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          _form(
                              responsive, context, categoriasBloc, serviceBloc),
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
                          _form(
                              responsive, context, categoriasBloc, serviceBloc)
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _form(Responsive responsive, BuildContext context,
      CategoriaBloc categoriaBloc, ServiciosBloc serviceBloc) {
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
                    'Nombre Servicio',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _imputField(responsive, 'Nombre Servicio',
                      _nombreServicioController, 1),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Precio',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Row(
                    children: [
                      Container(
                        width: responsive.wp(45),
                        child: _precio(
                            responsive, 'Precio', _precioServicioController),
                      ),
                      Spacer(),
                      Container(
                        width: responsive.wp(45),
                        child: _currency(responsive, spinnerItemsTipo),
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
                    'Descripción',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _imputField(
                      responsive,
                      'Ingrese una breve descripción',
                      _descripcinServicioController,
                      2),
                ),
                SizedBox(height: responsive.hp(2)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt_rounded,
                      ),
                      SizedBox(width: responsive.wp(2)),
                      ElevatedButton(
                        onPressed: () {
                          _cargando.value = false;
                          _subirFoto(context);
                          //_cargando.value = true;
                        },
                        child: Text("Subir Foto"),
                      )
                    ],
                  ),
                ),
                SizedBox(height: responsive.hp(2)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _mostrarFoto(responsive),
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

//Widgets Para selecionar y Recortar la foto
  Future _subirFoto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Seleccione"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      Navigator.pop(context);
                      onSelect(ImageSource.gallery);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camara"),
                    onTap: () {
                      Navigator.pop(context);
                      onSelect(ImageSource.camera);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  static Future<File> pickImage({
    ImageSource source,
    Future<File> Function(File file) cropImage,
  }) async {
    final pickedFile =
        await ImagePicker().getImage(source: source, imageQuality: 80);
    if (pickedFile == null) return null;
    if (cropImage == null) {
      return File(pickedFile.path);
    } else {
      final file = File(pickedFile.path);

      return cropImage(file);
    }
  }

  Future onSelect(
    ImageSource source,
  ) async {
    final file = await pickImage(source: source, cropImage: cropRectangleImage);
    if (file == null) return;
    setState(() {
      foto = file;
      print('FOTO: ${foto.path}');
    });
  }

  Future<File> cropRectangleImage(File imageFile) async =>
      await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.ratio3x2,
              ]
            : [
                CropAspectRatioPreset.ratio3x2,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Recortar',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          title: 'Imagen',
        ),
      );

  Widget _mostrarFoto(Responsive responsive) {
    if (foto != null) {
      return Center(
        child: Container(
          // height: responsive.hp(20),
          // width: responsive.wp(30),
          child: ClipRRect(
            child: Image.file(foto),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
//--------------------------------------------------------------------------

//Input para Rellenar los campos
  Widget _imputField(Responsive responsive, String text,
      TextEditingController controller, int line) {
    return TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        maxLines: line,
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

  Widget _precio(
      Responsive responsive, String text, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        keyboardType: TextInputType.number,
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

  Widget _currency(Responsive responsive, List<String> list) {
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
            if (data == 'Soles') {
              dropdownid = 'S/';
            } else if (data == 'Dólares') {
              dropdownid = '${r"$"}';
            } else {
              dropdownid = 'S/';
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

  Widget _button(Responsive responsive) {
    final serviceBloc = ProviderBloc.servi(context);
    final servicioModel = SubsidiaryServiceModel();
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        onPressed: () async {
          if (keyForm.currentState.validate()) {
            Pattern pattern = '^(\[[0-9]\)';
            RegExp regExp = new RegExp(pattern);
            if (dropdownTipo == 'Moneda') {
              utils.showToast(
                  context, 'Por favor debe selecionar un tipo de moneda');
            } else if (!regExp.hasMatch(_precioServicioController.text)) {
              utils.showToast(
                  context, 'Por favor ingresar solo números en Precio');
              // } else if (foto == null) {
              //   utils.showToast(context, 'Por favor debe subir una foto');
            } else {
              servicioModel.idSubsidiaryservice =
                  widget.serviceModel.idSubsidiaryservice;
              servicioModel.idSubsidiary = widget.serviceModel.idSubsidiary;
              servicioModel.subsidiaryServiceName =
                  _nombreServicioController.text;
              servicioModel.subsidiaryServicePrice =
                  _precioServicioController.text;
              servicioModel.subsidiaryServiceCurrency = dropdownid;
              servicioModel.subsidiaryServiceDescription =
                  _descripcinServicioController.text;

              final int code =
                  await serviceBloc.editarServicio(foto, servicioModel);
              if (code == 1) {
                print(code);
                print("Producto agregado");
                //goodBloc.listarProductosPorSucursal(widget.idSucursal);
                utils.showToast(context, 'Producto agregado');
                Navigator.pop(context);
              } else {
                utils.showToast(context, 'Ocurrió un error');
              }
            }
          }
        },
        textColor: Colors.white,
        child: Text('AGREGAR', style: utils.subtitulotexto),
        color: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.red[900]),
        ),
      ),
    );
  }
}
