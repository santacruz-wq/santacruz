
class ProductoModel {
  final String id;
  final String productId;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final String categoriaId;
  final String categoriaNombre;
  final bool disponible;
  final bool visibleMenu;

  ProductoModel({
    required this.id,
    required this.productId,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.categoriaId,
    required this.categoriaNombre,
    required this.disponible,
    this.visibleMenu = true,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    final categoria = json['categoria'];

    return ProductoModel(
      id: (json['_id'] ?? '').toString(),
      productId: (json['productId'] ?? '').toString(),
      nombre: (json['nombre'] ?? '').toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      precio: json['precio'] is num
          ? (json['precio'] as num).toDouble()
          : 0.0,
      imagen: (json['imagen'] ?? '').toString(),
      categoriaId: categoria is Map
          ? (categoria['_id'] ?? '').toString()
          : (categoria ?? '').toString(),
      categoriaNombre: categoria is Map
          ? (categoria['nombre'] ?? '').toString()
          : '',
      disponible: json['disponible'] ?? true,
      visibleMenu: json['visibleMenu'] ?? true,
    );
  }
}
