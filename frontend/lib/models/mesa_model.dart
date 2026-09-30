class MesaModel {
  final String id;
  final String nombre;
  final int capacidad;
  final String estado; // libre, ocupada, reservada
  final bool activo;

  MesaModel({
    required this.id,
    required this.nombre,
    required this.capacidad,
    required this.estado,
    required this.activo,
  });

  //CONVERTIMOS EL JSON DEL BACKEND EN UN OBJETO MESA
  factory MesaModel.fromJson(Map<String, dynamic> json) {
    return MesaModel(
      id: json['_id'] ?? '',
      nombre: json['nombre'] ?? '',
      capacidad: (json['capacidad'] ?? 0).toInt(),
      estado: json['estado'] ?? 'libre',
      activo: json['activo'] ?? true,
    );
  }

  //ATAJOS PARA SABER EL ESTADO SIN COMPARAR STRINGS EN LAS PANTALLAS
  bool get estaLibre => estado == 'libre';
  bool get estaOcupada => estado == 'ocupada';
  bool get estaReservada => estado == 'reservada';
}