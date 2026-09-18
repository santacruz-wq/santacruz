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
}