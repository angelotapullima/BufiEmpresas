class TipoEstadoPedidoModel {
  String idTipoEstado;
  String tipoEstadoNombre;
  String tipoEstadoSelect;
  TipoEstadoPedidoModel(
      {this.idTipoEstado, this.tipoEstadoNombre, this.tipoEstadoSelect});
  factory TipoEstadoPedidoModel.fromJson(Map<String, dynamic> json) =>
      TipoEstadoPedidoModel(
        idTipoEstado: json['id_tipo_estado'],
        tipoEstadoNombre: json['tipo_estado_nombre'],
        tipoEstadoSelect: json['tipo_estado_select'],
      );
}
