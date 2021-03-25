import 'package:bufi_empresas/src/api/Pagos/pagos_api.dart';
import 'package:bufi_empresas/src/database/pagos_db.dart';
import 'package:bufi_empresas/src/models/PagosModel.dart';
import 'package:rxdart/rxdart.dart';

class PagosBloc {
  final pagosDatabase = PagosDataBase();
  final pagosApi = PagosApi();
  final _pagosController = BehaviorSubject<List<PagosModel>>();
  final _cargandoItems = BehaviorSubject<bool>();
  Stream<List<PagosModel>> get pagosStream => _pagosController.stream;
  Stream<bool> get cargandoItemsStream => _cargandoItems.stream;
  void dispose() {
    _pagosController?.close();
    _cargandoItems?.close();
  }

  void obtenerPagosXFecha(
      String idSubsidiary, String fechaI, String fechaF) async {
    _cargandoItems.sink.add(true);
    _pagosController.sink.add(await pagosDatabase
        .obtenerPagosXIdSubsidiaryAndFecha(idSubsidiary, fechaI, fechaF));

    pagosApi.obtenerPagosXIdSubsidiary(idSubsidiary, fechaI, fechaF);
    _pagosController.sink.add(await pagosDatabase
        .obtenerPagosXIdSubsidiaryAndFecha(idSubsidiary, fechaI, fechaF));
    _cargandoItems.sink.add(false);

    //_pagosController.sink.add(await pagosApi.obtenerPagosXIdSubsidiary(idSubsidiary, fechaIni, fechaFin));
  }
}
