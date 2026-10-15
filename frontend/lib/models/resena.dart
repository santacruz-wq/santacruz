class Resena {
  final String id;
  final String usuarioId;
  final String usuarioNombre;
  final int calificacion;
  final String comentario;
  final DateTime fecha;

  Resena({
    required this.id,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.calificacion,
    required this.comentario,
    required this.fecha,
  });

  factory Resena.fromJson(Map<String, dynamic> json) {
    final usuario = json['usuario'];

    return Resena(
      id: (json['_id'] ?? '').toString(),
      usuarioId: usuario is Map
          ? (usuario['_id'] ?? '').toString()
          : (usuario ?? '').toString(),
      usuarioNombre: usuario is Map
          ? (usuario['nombre'] ?? 'Usuario').toString()
          : 'Usuario',
      calificacion: (json['calificacion'] ?? 0).toInt(),
      comentario: (json['comentario'] ?? '').toString(),
      fecha: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class ResenasProducto {
  final List<Resena> resenas;
  final double promedio;
  final int total;

  ResenasProducto({
    required this.resenas,
    required this.promedio,
    required this.total,
  });

  factory ResenasProducto.fromJson(Map<String, dynamic> json) {
    final lista = (json['resenas'] as List? ?? [])
        .map((e) => Resena.fromJson(e as Map<String, dynamic>))
        .toList();

    return ResenasProducto(
      resenas: lista,
      promedio: (json['promedio'] ?? 0).toDouble(),
      total: (json['total'] ?? lista.length).toInt(),
    );
  }
}