import 'dart:io';

import 'package:bufi_empresas/src/bloc/categoria_bloc.dart';
import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/bloc/servicios/servicios_bloc.dart';
import 'package:bufi_empresas/src/models/itemSubcategoryModel.dart';
import 'package:bufi_empresas/src/models/serviceModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryService.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:bufi_empresas/src/utils//utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AgregarServicioPage extends StatefulWidget {
  final String idSucursal;
  AgregarServicioPage({this.idSucursal});
  @override
  _AgregarServicioPage createState() => _AgregarServicioPage();
}

class _AgregarServicioPage extends State<AgregarServicioPage> {
  final keyForm = GlobalKey<FormState>();
  final _cargando = ValueNotifier<bool>(false);

  File foto;

  //DropdownMoneda
  String dropdownTipo = 'Moneda';
  String dropdownid = '2';
  List<String> spinnerItemsTipo = [
    'Moneda',
    'Soles',
    'Dólares',
  ];

  //DropdownCategorias
  String dropdownCategorias = 'Seleccionar';
  int cantItemsCategoria;
  List<String> listCategoria;
  String idCategoria = 'false';

  //DropdownGood
  String dropdownGood = 'Seleccionar';
  int cantItemsGood;
  List<String> listGood;
  String idGood = 'false';

  //TextEditingProducto
  TextEditingController _nombreServicioController = TextEditingController();
  TextEditingController _precioServicioController = TextEditingController();
  TextEditingController _descripcinServicioController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cantItemsCategoria = 0;
      cantItemsGood = 0;
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
                  height: responsive.hp(2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Tipo Servicio',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _service(serviceBloc, responsive),
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

  Widget _categoria(CategoriaBloc categoriaBloc, Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5)),
      child: StreamBuilder(
          stream: categoriaBloc.itemSubcategoriaStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<ItemSubCategoriaModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                if (cantItemsCategoria == 0) {
                  listCategoria = [];
                  listCategoria.add('Seleccionar');
                  for (int i = 0; i < snapshot.data.length; i++) {
                    String nombreCategoria =
                        snapshot.data[i].itemsubcategoryName;
                    listCategoria.add(nombreCategoria);
                    // if (widget.productoModel.idItemsubcategory ==
                    //     snapshot.data[i].idCategory) {
                    //   dropdownCategorias = snapshot.data[i].categoryName;
                    //   idCategoria = snapshot.data[i].idCategory;
                    // }
                  }
                }

                return dropCategoria(responsive, listCategoria, snapshot.data);
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

  Widget dropCategoria(Responsive responsive, List<String> lista1,
      List<ItemSubCategoriaModel> sedes) {
    return DropdownButton(
      isExpanded: true,
      underline: Container(),
      value: dropdownCategorias,
      items: lista1.map((value) {
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
          cantItemsCategoria++;

          obtenerIdSedes(value, sedes);
        });
      },
    );
  }

  void obtenerIdSedes(String dato, List<ItemSubCategoriaModel> list) {
    idCategoria = 'false';
    for (int i = 0; i < list.length; i++) {
      if (dato == list[i].itemsubcategoryName) {
        idCategoria = list[i].idItemsubcategory;
      }
    }
    print('id $idCategoria');
  }

  Widget _service(ServiciosBloc serviceBloc, Responsive responsive) {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(4)),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5)),
      child: StreamBuilder(
          stream: serviceBloc.allServicesStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<ServiciosModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                if (cantItemsGood == 0) {
                  listGood = [];

                  listGood.add('Seleccionar');
                  for (int i = 0; i < snapshot.data.length; i++) {
                    String serviceName = snapshot.data[i].serviceName;
                    listGood.add(serviceName);
                    // if (widget.productoModel.idItemsubcategory ==
                    //     snapshot.data[i].idCategory) {
                    //   dropdownCategorias = snapshot.data[i].categoryName;
                    //   idCategoria = snapshot.data[i].idCategory;
                    // }
                  }
                }

                return dropGood(responsive, listGood, snapshot.data);
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

  Widget dropGood(Responsive responsive, List<String> listaBienes,
      List<ServiciosModel> bienes) {
    return DropdownButton(
      isExpanded: true,
      underline: Container(),
      value: dropdownGood,
      items: listaBienes.map((value) {
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
          dropdownGood = value;
          cantItemsGood++;

          obtenerIdGood(value, bienes);
        });
      },
    );
  }

  void obtenerIdGood(String dato, List<ServiciosModel> listBienes) {
    idGood = 'false';
    for (int i = 0; i < listBienes.length; i++) {
      if (dato == listBienes[i].serviceName) {
        idGood = listBienes[i].idService;
      }
    }
    print('id Good: $idGood');
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
            } else if (idGood == 'false') {
              utils.showToast(
                  context, 'Por favor debe selecionar el tipo de producto');
            } else if (idCategoria == 'false') {
              utils.showToast(
                  context, 'Por favor debe selecionar una categoria');
            } else if (!regExp.hasMatch(_precioServicioController.text)) {
              utils.showToast(
                  context, 'Por favor ingresar solo números en Precio');
            } else if (foto == null) {
              utils.showToast(context, 'Por favor debe subir una foto');
            } else {
              servicioModel.idService = idGood;
              servicioModel.idSubsidiary = widget.idSucursal;
              servicioModel.idItemsubcategory = idCategoria;
              servicioModel.subsidiaryServiceName =
                  _nombreServicioController.text;
              servicioModel.subsidiaryServicePrice =
                  _precioServicioController.text;
              servicioModel.subsidiaryServiceCurrency = dropdownid;
              servicioModel.subsidiaryServiceDescription =
                  _descripcinServicioController.text;

              final int code =
                  await serviceBloc.guardarServicio(foto, servicioModel);
              if (code == 1) {
                print(code);
                print("Servicio agregado");
                //goodBloc.listarProductosPorSucursal(widget.idSucursal);
                utils.showToast(context, 'Servicio agregado');
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
