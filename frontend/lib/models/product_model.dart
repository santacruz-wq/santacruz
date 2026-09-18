class ProductModel {
  final String id;
  final String productId;
  final String nombre;
  final String? descripcion;
  final double precio;
  final String imagen;
  final String categoriaId;
  final bool disponible;

  ProductModel({
    required this.id,
    required this.productId,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.imagen,
    required this.categoriaId,
    required this.disponible,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    //LA CATEGORIA PUEDE VENIR POBLADA (OBJETO) O SOLO COMO ID (STRING)
    final categoriaRaw = json['categoria'];
    final categoriaId = categoriaRaw is Map
        ? categoriaRaw['_id'] ?? ''
        : (categoriaRaw ?? '').toString();

    return ProductModel(
      id: json['_id'] ?? '',
      productId: json['productId'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      precio: (json['precio'] is int)
          ? (json['precio'] as int).toDouble()
          : (json['precio'] ?? 0).toDouble(),
      imagen: json['imagen'] ?? '',
      categoriaId: categoriaId,
      disponible: json['disponible'] ?? true,
    );
  }
class Product {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final String categoria;
  final bool disponible;

  Product({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.categoria,
    required this.disponible,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: (json['precio'] ?? 0).toDouble(),
      imagen: json['imagen'] ?? '',
      categoria: json['categoria'] is Map
          ? (json['categoria']['_id'] ?? '')
          : (json['categoria'] ?? ''),
      disponible: json['disponible'] ?? true,
    );
  }

  // Construye la URL completa a partir del nombre/ruta que guarda el backend
  String get imagenUrl {
    if (imagen.startsWith('http')) return imagen;
    return 'http://10.0.2.2:3000/uploads/$imagen';
  }
}