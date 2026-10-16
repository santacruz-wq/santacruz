class OrdenDetalleModel {
  final String id;
  final String ordenId;
  final String productoId;
  final String productoNombre;
  final double precioUnitario;
  final int cantidad;
  final double subtotal;
  final bool esAdicion;
  final String? notas;

  OrdenDetalleModel({
    required this.id,
    required this.ordenId,
    required this.productoId,
    required this.productoNombre,
    required this.precioUnitario,
    required this.cantidad,
    required this.subtotal,
    required this.esAdicion,
    this.notas,
  });

  factory OrdenDetalleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final producto = json['producto'];

    return OrdenDetalleModel(
      id: json['_id'] ?? '',
      ordenId: json['orden'] ?? '',
      productoId:
          producto is Map
              ? (producto['_id'] ?? '')
              : (producto ?? ''),
      productoNombre:
          producto is Map
              ? (producto['nombre'] ?? '')
              : '',
      precioUnitario:
          (json['precioUnitario'] ?? 0).toDouble(),
      cantidad:
          (json['cantidad'] ?? 1).toInt(),
      subtotal:
          (json['subtotal'] ?? 0).toDouble(),
      esAdicion:
          json['esAdicion'] ?? false,
      notas: json['notas'],
    );
  }
}