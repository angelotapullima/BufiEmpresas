import 'package:bufi_empresas/src/models/CompanySubsidiaryModel.dart';
import 'package:bufi_empresas/src/models/DetallePedidoModel.dart';

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

  String idDelivery;
  String pagoTipo;
  String pagoMonto;
  String pagoComision;
  String pagoTotal;
  String pagoDate;
  String pagoEstado;
  String pagoMicrotime;

  List<CompanySubsidiaryModel> listCompanySubsidiary;
  List<DetallePedidoModel> detallePedido;
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
    this.detallePedido,
    this.idDelivery,
    this.pagoTipo,
    this.pagoMonto,
    this.pagoComision,
    this.pagoTotal,
    this.pagoDate,
    this.pagoEstado,
    this.pagoMicrotime,
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
        idDelivery: json['id_delivery'],
        pagoTipo: json['pago_tipo'],
        pagoMonto: json['pago_monto'],
        pagoComision: json['pago_comision'],
        pagoTotal: json['pago_total'],
        pagoDate: json['pago_date'],
        pagoEstado: json['pago_estado'],
        pagoMicrotime: json['pago_microtime'],
      );
}
