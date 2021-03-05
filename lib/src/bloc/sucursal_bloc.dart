import 'package:bufi_empresas/src/database/subsidiary_db.dart';
import 'package:bufi_empresas/src/models/subsidiaryModel.dart';
import 'package:rxdart/subjects.dart';

class SucursalBloc {
  final sucursalDatabase = SubsidiaryDatabase();

//obtener subsidiary por idCompany
  final _sucursalController = BehaviorSubject<List<SubsidiaryModel>>();
  final _listarsucursalesController = BehaviorSubject<List<SubsidiaryModel>>();

  //Controller de subsidiary por id
  final _subsidiaryController = BehaviorSubject<List<SubsidiaryModel>>();

//Stream de subsidiary por idCompany
  Stream<List<SubsidiaryModel>> get sucursalStream =>
      _sucursalController.stream;

//Stream de subsidiary por id
  Stream<List<SubsidiaryModel>> get subsidiaryStream =>
      _subsidiaryController.stream;

  void dispose() {
    _sucursalController?.close();
    _listarsucursalesController?.close();
    _subsidiaryController?.close();
  }

  void obtenerSucursalporIdCompany(String id) async {
    _sucursalController.sink
        .add(await sucursalDatabase.obtenerSubsidiaryPorIdCompany(id));
  }

  void obtenerSucursales() async {
    _sucursalController.sink.add(await sucursalDatabase.obtenerSubsidiary());
  }

  void obtenerSucursalporId(String id) async {
    _subsidiaryController.sink
        .add(await sucursalDatabase.obtenerSubsidiaryPorIdSubsidiary(id));
  }
}
