import 'dart:convert';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../models/resena.dart';

class ResenaService {
  // OBTENER RESEÑAS DE UN PRODUCTO (con promedio y total)
  static Future<ResenasProducto> getPorProducto(
    String productoId,
  ) async {
    final response = await ApiClient.get(
      "${ApiConfig.resenas}/producto/$productoId",
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ResenasProducto.fromJson(data);
    } else {
      throw Exception("Error al obtener las reseñas");
    }
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
        "producto": productoId,
        "calificacion": calificacion,
        "comentario": comentario,
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
      "${ApiConfig.resenas}/$resenaId",
      {
        "calificacion": calificacion,
        "comentario": comentario,
      },
    );

    return response.statusCode == 200;
  }

  // ELIMINAR RESEÑA
  static Future<bool> eliminar(
    String resenaId,
  ) async {
    final response = await ApiClient.delete(
      "${ApiConfig.resenas}/$resenaId",
    );

    return response.statusCode == 200;
  }
}