
class ProductModel {
  final String id;
  final String productId;
  final String nombre;
  final String? descripcion;
  final double precio;
  final String imagen;
  final String categoriaId;
  final bool disponible;
  final bool visibleMenu;

  ProductModel({
    required this.id,
    required this.productId,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.imagen,
    required this.categoriaId,
    required this.disponible,
    this.visibleMenu = true,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final categoriaRaw = json['categoria'];

    final categoriaId = categoriaRaw is Map
        ? (categoriaRaw['_id'] ?? '').toString()
        : (categoriaRaw ?? '').toString();

    return ProductModel(
      id: (json['_id'] ?? '').toString(),
      productId: (json['productId'] ?? '').toString(),
      nombre: (json['nombre'] ?? '').toString(),
      descripcion: json['descripcion']?.toString(),
      precio: json['precio'] is num
          ? (json['precio'] as num).toDouble()
          : 0.0,
      imagen: (json['imagen'] ?? '').toString(),
      categoriaId: categoriaId,
      disponible: json['disponible'] ?? true,
      visibleMenu: json['visibleMenu'] ?? true,
    );
  }

  String get imagenUrl {
    if (imagen.isEmpty) {
      return '';
    }

    if (imagen.startsWith('http')) {
      return imagen;
    }

    return 'http://10.0.2.2:3000/uploads/$imagen';
  }
}
