import 'package:bufi_empresas/src/api/Pagos/pagos_api.dart';
import 'package:bufi_empresas/src/database/pagos_db.dart';
import 'package:bufi_empresas/src/models/PagosModel.dart';
import 'package:rxdart/rxdart.dart';

class PagosBloc {
  final pagosDatabase = PagosDataBase();
  final pagosApi = PagosApi();
  final _pagosController = BehaviorSubject<List<PagosModel>>();
  Stream<List<PagosModel>> get pagosStream => _pagosController.stream;
  void dispose() {
    _pagosController?.close();
  }

  void obtenerPagosXFecha(
      String idSubsidiary, String fechaI, String fechaF) async {
    _pagosController.sink.add(await pagosDatabase
        .obtenerPagosXIdSubsidiaryAndFecha(idSubsidiary, fechaI, fechaF));
    pagosApi.obtenerPagosXIdSubsidiary(idSubsidiary, fechaI, fechaF);
    _pagosController.sink.add(await pagosDatabase
        .obtenerPagosXIdSubsidiaryAndFecha(idSubsidiary, fechaI, fechaF));

    //_pagosController.sink.add(await pagosApi.obtenerPagosXIdSubsidiary(idSubsidiary, fechaIni, fechaFin));
  }
}
