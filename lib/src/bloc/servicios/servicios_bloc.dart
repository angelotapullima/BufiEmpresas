import 'dart:io';

import 'package:bufi_empresas/src/api/servicios/services_api.dart';
import 'package:bufi_empresas/src/database/service_db.dart';
import 'package:bufi_empresas/src/database/subsidiaryService_db.dart';
import 'package:bufi_empresas/src/models/serviceModel.dart';
import 'package:bufi_empresas/src/models/subsidiaryService.dart';
import 'package:rxdart/subjects.dart';

class ServiciosBloc {
  final subservicesDatabase = SubsidiaryServiceDatabase();
  final subservicesModel = SubsidiaryServiceModel();
  final serviciosApi = ServiceApi();
  final servicesDatabase = ServiceDatabase();

  final _servicioController = BehaviorSubject<List<SubsidiaryServiceModel>>();
  final _serviAllController = BehaviorSubject<List<ServiciosModel>>();
  final _cargandoController = BehaviorSubject<bool>();

  final _detailServicioController =
      BehaviorSubject<List<SubsidiaryServiceModel>>();

  Stream<List<SubsidiaryServiceModel>> get serviciostream =>
      _servicioController.stream;

  Stream<List<ServiciosModel>> get allServicesStream =>
      _serviAllController.stream;

  Stream<List<SubsidiaryServiceModel>> get detailServiciostream =>
      _detailServicioController.stream;

  Stream<bool> get cargandotream => _cargandoController.stream;

  Function(bool) get changeCargando => _cargandoController.sink.add;

  void dispose() {
    _servicioController?.close();
    _detailServicioController?.close();
    _serviAllController?.close();
    _cargandoController?.close();
  }

  void obtenerAllServices() async {
    _serviAllController.sink.add(await servicesDatabase.obtenerService());
    await serviciosApi.obtenerServicesAll();
    _serviAllController.sink.add(await servicesDatabase.obtenerService());
  }

  void listarServiciosPorSucursal(String id) async {
    _servicioController.sink
        .add(await subservicesDatabase.obtenerServiciosPorIdSucursal(id));
    await serviciosApi.listarServiciosPorSucursal(id);
    _servicioController.sink
        .add(await subservicesDatabase.obtenerServiciosPorIdSucursal(id));
  }

  void detalleServicioPorIdSubsidiaryService(String id) async {
    _detailServicioController.sink.add(
        await subservicesDatabase.obtenerServiciosPorIdSucursalService(id));
    await serviciosApi.detalleSerivicioPorIdSubsidiaryService(id);
    _detailServicioController.sink.add(
        await subservicesDatabase.obtenerServiciosPorIdSucursalService(id));
  }

  Future<int> habilitarDesService(String id, String status) async {
    final resp = await serviciosApi.deshabilitarSubsidiaryService(id, status);
    return resp;
  }

  Future<int> guardarServicio(
      File imagen, SubsidiaryServiceModel servicio) async {
    _cargandoController.sink.add(true);
    final resp = await serviciosApi.guardarServicio(imagen, servicio);
    _cargandoController.sink.add(false);
    return resp;
  }

  Future<int> editarServicio(
      File imagen, SubsidiaryServiceModel servicio) async {
    _cargandoController.sink.add(true);
    final resp = await serviciosApi.editarServicio(imagen, servicio);
    _cargandoController.sink.add(false);
    return resp;
  }
}
