class UserModel {
  final String? id;
  final String nombre;
  final String email;
  final String rol; // "admin", "user", "mesero", "cocina"
  final bool activo;
  final bool isVerified;
  final String? avatar;
  final DateTime? createdAt;

  UserModel({
    this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    required this.activo,
    this.isVerified = true,
    this.avatar,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      nombre: json['nombre'],
      email: json['email'],
      rol: json['rol'],
      activo: json['activo'] ?? true,
      isVerified: json['isVerified'] ?? true,
      avatar: json['avatar'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'rol': rol,
      'activo': activo,
      'isVerified': isVerified,
      'avatar': avatar,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}