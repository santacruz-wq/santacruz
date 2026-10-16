class Categoria {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final bool activo;

  const Categoria({
    required this.id,
    required this.nombre,
    this.descripcion = '',
    this.imagen = 'assets/img/categoria.avif',
    this.activo = true,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      nombre: (json['nombre'] ?? '').toString(),
      descripcion: (json['descripcion'] ?? '').toString(),
      imagen: (json['imagen'] ?? 'assets/img/categoria.avif').toString(),
      activo: json['activo'] is bool ? json['activo'] as bool : true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen': imagen,
      'activo': activo,
    };
  }

  Categoria copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? imagen,
    bool? activo,
  }) {
    return Categoria(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      imagen: imagen ?? this.imagen,
      activo: activo ?? this.activo,
    );
  }
}
