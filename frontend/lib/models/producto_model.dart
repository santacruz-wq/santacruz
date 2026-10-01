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
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    final categoria = json['categoria'];

    return ProductoModel(
      id: json['_id'] ?? '',
      productId: json['productId'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: (json['precio'] ?? 0).toDouble(),
      imagen: json['imagen'] ?? '',
      categoriaId: categoria is Map
          ? (categoria['_id'] ?? '')
          : (categoria ?? ''),
      categoriaNombre: categoria is Map
          ? (categoria['nombre'] ?? '')
          : '',
      disponible: json['disponible'] ?? true,
    );
  }
}