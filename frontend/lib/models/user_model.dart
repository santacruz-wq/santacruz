class UserModel {
  final String? id;
  final String nombre;
  final String email;
  final String rol; // "admin", "mesero", "cocina", "usuario"
  final bool activo;

  UserModel({
    this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    required this.activo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      nombre: json['nombre'],
      email: json['email'],
      rol: json['rol'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'activo': activo,
    };
  }
}