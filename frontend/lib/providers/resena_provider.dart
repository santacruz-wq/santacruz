import 'package:flutter/material.dart';

import '../models/resena.dart';
import '../services/resena_service.dart';

class ResenaProvider extends ChangeNotifier {
  List<Resena> _resenas = [];
  double _promedio = 0;
  int _total = 0;
  bool _cargando = false;
  String? _productoId;

  List<Resena> get resenas => _resenas;
  double get promedio => _promedio;
  int get total => _total;
  bool get cargando => _cargando;

  /// Reseña del usuario actual en el producto cargado (null si no ha reseñado).
  Resena? miResena(String? usuarioId) {
    if (usuarioId == null) return null;
    for (final resena in _resenas) {
      if (resena.usuarioId == usuarioId) return resena;
    }
    return null;
  }

  Future<void> cargar(String productoId) async {
    if (_productoId != productoId) {
      _resenas = [];
      _promedio = 0;
      _total = 0;
    }
    _productoId = productoId;

    _cargando = true;
    notifyListeners();

    try {
      final data = await ResenaService.getPorProducto(productoId);
      _resenas = data.resenas;
      _promedio = data.promedio;
      _total = data.total;
    } catch (error) {
      debugPrint('Error cargando reseñas: $error');
    }

    _cargando = false;
    notifyListeners();
  }

  /// Crea la reseña, o la actualiza si el usuario ya tenía una.
  Future<bool> enviar({
    required String productoId,
    required int calificacion,
    required String comentario,
    required String? usuarioId,
  }) async {
    final existente = miResena(usuarioId);

    final exito = existente == null
        ? await ResenaService.crear(productoId, calificacion, comentario)
        : await ResenaService.actualizar(existente.id, calificacion, comentario);

    if (exito) await cargar(productoId);
    return exito;
  }

  Future<bool> eliminar(String resenaId) async {
    final exito = await ResenaService.eliminar(resenaId);
    if (exito && _productoId != null) await cargar(_productoId!);
    return exito;
  }
}