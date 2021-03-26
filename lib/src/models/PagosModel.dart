import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';

class PagosModel {
  String idTransferenciaUE;
  String idSubsidiary;
  String transferenciaUENroOperacion;
  String idUsuario;
  String idEmpresa;
  String idPago;
  String transferenciaUEMonto;
  String transferecniaUEConcepto;
  String transferenciaUEDate;
  String transferenciaUEEstado;
  List<CompanySubsidiaryModel> listCompanySubsidiary;
  PagosModel({
    this.idTransferenciaUE,
    this.idSubsidiary,
    this.transferenciaUENroOperacion,
    this.idUsuario,
    this.idEmpresa,
    this.idPago,
    this.transferenciaUEMonto,
    this.transferecniaUEConcepto,
    this.transferenciaUEDate,
    this.transferenciaUEEstado,
    this.listCompanySubsidiary,
  });
  factory PagosModel.fromJson(Map<String, dynamic> json) => PagosModel(
        idTransferenciaUE: json['id_transferencia_u_e'],
        idSubsidiary: json['id_subsidiary'],
        transferenciaUENroOperacion: json['transferencia_u_e_nro_operacion'],
        idUsuario: json['id_usuario'],
        idEmpresa: json['id_empresa'],
        idPago: json['id_pago'],
        transferenciaUEMonto: json['transferencia_u_e_monto'],
        transferecniaUEConcepto: json['transferencia_u_e_concepto'],
        transferenciaUEDate: json['transferencia_u_e_date'],
        transferenciaUEEstado: json['transferencia_u_e_estado'],
      );
}
