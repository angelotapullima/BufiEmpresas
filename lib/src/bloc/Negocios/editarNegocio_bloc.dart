import 'package:bufi_empresas/src/api/Negocio/negocio_api.dart';
import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';
import 'package:rxdart/rxdart.dart';

class EditarNegocioBloc {
  final editaregocioApi = NegocioApi();
  final _cargandoEditNegocioController = new BehaviorSubject<bool>();
  Stream<bool> get cargandoEditNegocioStream =>
      _cargandoEditNegocioController.stream;

  Function(bool) get changeCargandoEditNegocio =>
      _cargandoEditNegocioController.sink.add;
  dispose() {
    _cargandoEditNegocioController?.close();
  }

  Future<int> updateNegocio(CompanySubsidiaryModel compSubModel) async {
    _cargandoEditNegocioController.sink.add(true);
    final resp = await editaregocioApi.updateNegocio(compSubModel);
    _cargandoEditNegocioController.sink.add(false);
    return resp;
  }
}
