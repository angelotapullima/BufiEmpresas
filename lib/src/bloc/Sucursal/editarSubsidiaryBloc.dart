import 'dart:async';

import 'package:bufi_empresas/src/api/Subsidiary/editarSubsidiary_api.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:rxdart/rxdart.dart';

class EditarSubsidiaryBloc {
  final editarSubsidiaryApi = EditarSubsidaryApi();
  final _cargandoController = new BehaviorSubject<bool>();

  Stream<bool> get cargandoStream => _cargandoController.stream;

  Function(bool) get changeCargando => _cargandoController.sink.add;
  dispose() {
    _cargandoController?.close();
  }

  Future<int> editarSubsidiary(SubsidiaryModel subModel) async {
    _cargandoController.sink.add(true);
    final resp = await editarSubsidiaryApi.editarSubsidiary(subModel);
    _cargandoController.sink.add(false);
    return resp;
  }
}
