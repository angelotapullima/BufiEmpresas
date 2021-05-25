import 'dart:io';

import 'package:bufi_empresas/src/bloc/provider_bloc.dart';
import 'package:bufi_empresas/src/models/productoModel.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:bufi_empresas/src/utils/utils.dart';
import 'package:bufi_empresas/src/utils//utils.dart' as utils;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditarProductoPage extends StatefulWidget {
  final ProductoModel productoModel;
  const EditarProductoPage({Key key, this.productoModel}) : super(key: key);

  @override
  _EditarProductoPage createState() => _EditarProductoPage();
}

class _EditarProductoPage extends State<EditarProductoPage> {
  final keyForm = GlobalKey<FormState>();
  final _cargando = ValueNotifier<bool>(false);

  File foto;

  //DropdownMoneda
  String dropdownTipo = 'Seleccionar';
  String dropdownid = 'S/';
  List<String> spinnerItemsTipo = [
    'Seleccionar',
    'Soles',
    'Dólares',
  ];

  //TextEditingProducto
  TextEditingController _nombreProductoController = TextEditingController();
  TextEditingController _precioProductoController = TextEditingController();
  TextEditingController _measureProductoController = TextEditingController();
  TextEditingController _marcaProductoController = TextEditingController();
  TextEditingController _modeloProductoController = TextEditingController();
  TextEditingController _sizeProductoController = TextEditingController();
  TextEditingController _stockProductoController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nombreProductoController.text = widget.productoModel.productoName;
      _precioProductoController.text = widget.productoModel.productoPrice;
      _measureProductoController.text = widget.productoModel.productoMeasure;
      _marcaProductoController.text = widget.productoModel.productoBrand;
      _modeloProductoController.text = widget.productoModel.productoModel;
      _sizeProductoController.text = widget.productoModel.productoSize;
      _stockProductoController.text = widget.productoModel.productoStock;
      if (widget.productoModel.productoCurrency == '${r"$"}') {
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
    final goodBloc = ProviderBloc.productos(context);
    goodBloc.changeCargando(false);

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
                  "EDITAR: ${widget.productoModel.productoName}",
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
                      stream: goodBloc.cargandotream,
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
                    'Nombre Producto',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _imputField(
                      responsive, 'Nombre Producto', _nombreProductoController),
                ),
                SizedBox(
                  height: responsive.hp(2),
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
                        child: _imputFieldNull(
                            responsive, 'Precio', _precioProductoController),
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
                    'Marca',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _imputField(
                      responsive, 'Marca', _marcaProductoController),
                ),
                SizedBox(height: responsive.hp(2)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Modelo',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _imputField(
                      responsive, 'Modelo', _modeloProductoController),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Tamaño',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: _imputField(
                      responsive, 'Tamaño', _sizeProductoController),
                ),
                SizedBox(
                  height: responsive.hp(2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Text(
                    'Stock',
                    style: formtexto,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
                  child: Row(
                    children: [
                      Container(
                        width: responsive.wp(45),
                        child: _imputField(
                            responsive, 'Stock', _stockProductoController),
                      ),
                      Spacer(),
                      Container(
                        width: responsive.wp(45),
                        child: _imputField(
                            responsive, 'Unidad', _measureProductoController),
                      ),
                    ],
                  ),
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
      return Container(
        child: ClipRRect(
          child: CachedNetworkImage(
            placeholder: (context, url) => Image(
                image: AssetImage('assets/jar-loading.gif'), fit: BoxFit.cover),
            errorWidget: (context, url, error) => Image(
                image: AssetImage('assets/carga_fallida.jpg'),
                fit: BoxFit.cover),
            imageUrl: '$apiBaseURL/${widget.productoModel.productoImage}',
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
//--------------------------------------------------------------------------

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
    final goodBloc = ProviderBloc.productos(context);
    final productoModel = ProductoModel();

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
            } else if (!regExp.hasMatch(_precioProductoController.text)) {
              utils.showToast(
                  context, 'Por favor ingresar solo números en Precio');
            } else if (!regExp.hasMatch(_stockProductoController.text)) {
              utils.showToast(
                  context, 'Por favor ingresar solo números en Stock');
            } else {
              productoModel.idProducto = widget.productoModel.idProducto;
              productoModel.productoName = _nombreProductoController.text;
              productoModel.productoPrice = _precioProductoController.text;
              productoModel.productoCurrency = dropdownid;
              productoModel.productoBrand = _marcaProductoController.text;
              productoModel.productoModel = _modeloProductoController.text;
              productoModel.productoSize = _sizeProductoController.text;
              productoModel.productoStock = _stockProductoController.text;
              productoModel.productoMeasure = _measureProductoController.text;

              final int code =
                  await goodBloc.editarProducto(foto, productoModel);
              if (code == 1) {
                goodBloc.listarProductosPorSucursal(
                    widget.productoModel.idSubsidiary);
                utils.showToast(context, 'Información Actualizada');
                Navigator.pop(context);
              } else {
                utils.showToast(context, 'Faltan registrar datos');
                final datosProdBloc = ProviderBloc.datosProductos(context);
                datosProdBloc
                    .listarDatosProducto(widget.productoModel.idProducto);
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
