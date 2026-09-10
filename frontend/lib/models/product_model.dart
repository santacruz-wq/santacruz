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