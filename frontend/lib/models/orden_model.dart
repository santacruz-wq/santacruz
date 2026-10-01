class OrdenModel {
  final String id;
  final String mesaId;
  final String mesaNombre;
  final String meseroId;
  final String meseroNombre;
  final String estado;
  final double total;
  final DateTime? createdAt;

  OrdenModel({
    required this.id,
    required this.mesaId,
    required this.mesaNombre,
    required this.meseroId,
    required this.meseroNombre,
    required this.estado,
    required this.total,
    this.createdAt,
  });

  factory OrdenModel.fromJson(Map<String, dynamic> json) {
    final mesa = json['mesa'];
    final mesero = json['mesero'];

    return OrdenModel(
      id: json['_id'] ?? '',
      mesaId: mesa is Map ? (mesa['_id'] ?? '') : (mesa ?? ''),
      mesaNombre: mesa is Map ? (mesa['nombre'] ?? '') : '',
      meseroId: mesero is Map ? (mesero['_id'] ?? '') : (mesero ?? ''),
      meseroNombre: mesero is Map ? (mesero['nombre'] ?? '') : '',
      estado: json['estado'] ?? 'pendiente',
      total: (json['total'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  bool get estaPendiente => estado == 'pendiente';

  bool get estaEnCocina => estado == 'en_cocina';

  bool get estaListo => estado == 'listo';

  bool get estaServido => estado == 'servido';

  bool get estaPagado => estado == 'pagado';

  bool get estaCancelado => estado == 'cancelado';
}