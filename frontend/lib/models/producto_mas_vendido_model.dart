
class ProductoMasVendidoModel {
  final String productoId;
  final String nombre;
  final int cantidadVendida;
  final double totalVendido;

  const ProductoMasVendidoModel({
    required this.productoId,
    required this.nombre,
    required this.cantidadVendida,
    required this.totalVendido,
  });

  factory ProductoMasVendidoModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductoMasVendidoModel(
      productoId: json['productoId']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? 'Producto',
      cantidadVendida:
          (json['cantidadVendida'] as num?)?.toInt() ?? 0,
      totalVendido:
          (json['totalVendido'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
