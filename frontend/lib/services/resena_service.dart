
import 'dart:convert';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../models/resena.dart';

class ResenaService {
  // OBTENER RESEÑAS DE UN PRODUCTO
  static Future<ResenasProducto> getPorProducto(
    String productoId,
  ) async {
    final response = await ApiClient.get(
      '${ApiConfig.resenas}/producto/$productoId',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ResenasProducto.fromJson(data);
    }

    throw Exception('Error al obtener las reseñas');
  }

  // CREAR RESEÑA
  static Future<bool> crear(
    String productoId,
    int calificacion,
    String comentario,
  ) async {
    final response = await ApiClient.post(
      ApiConfig.resenas,
      {
        'producto': productoId,
        'calificacion': calificacion,
        'comentario': comentario,
      },
    );

    return response.statusCode == 201;
  }

  // ACTUALIZAR RESEÑA
  static Future<bool> actualizar(
    String resenaId,
    int calificacion,
    String comentario,
  ) async {
    final response = await ApiClient.put(
      '${ApiConfig.resenas}/$resenaId',
      {
        'calificacion': calificacion,
        'comentario': comentario,
      },
    );

    return response.statusCode == 200;
  }

  // ELIMINAR RESEÑA
  static Future<bool> eliminar(
    String resenaId,
  ) async {
    final response = await ApiClient.delete(
      '${ApiConfig.resenas}/$resenaId',
    );

    return response.statusCode == 200;
  }

  // LISTAR TODAS LAS RESEÑAS PARA ADMINISTRACIÓN
  static Future<List<Map<String, dynamic>>> listarResenas() async {
    final response = await ApiClient.get(ApiConfig.resenas);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);

      // Admite una lista directa o una respuesta con la propiedad resenas.
      final dynamic lista = data is List
          ? data
          : data is Map<String, dynamic>
              ? data['resenas']
              : null;

      if (lista is List) {
        return lista
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }

      throw Exception('Formato de respuesta de reseñas no válido');
    }

    throw Exception('Error al listar las reseñas');
  }

  // ELIMINAR RESEÑA DESDE ADMINISTRACIÓN
  static Future<void> eliminarResena(String resenaId) async {
    final eliminada = await eliminar(resenaId);

    if (!eliminada) {
      throw Exception('No se pudo eliminar la reseña');
    }
  }
}
