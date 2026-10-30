import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../models/mesa_model.dart';

class MesaService {
  // OBTENEMOS LA LISTA DE MESAS ACTIVAS
  static Future<List<MesaModel>> getMesas() async {
    final response = await ApiClient.get(ApiConfig.mesas);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ACEPTAMOS LISTA DIRECTA O ENVUELTA EN { mesas: [...] }
      final List<dynamic> lista = data is List ? data : (data["mesas"] ?? []);

      // IGNORAMOS LAS MESAS ELIMINADAS (SOFT DELETE: activo == false)
      return lista
          .map((item) => MesaModel.fromJson(item))
          .where((mesa) => mesa.activo)
          .toList();
    } else {
      throw Exception("Error al obtener las mesas");
    }
  }

  // CAMBIAMOS EL ESTADO DE UNA MESA (libre, ocupada, reservada)
  static Future<bool> cambiarEstadoMesa(String mesaId, String estado) async {
    final response = await ApiClient.patch(
      "${ApiConfig.mesas}/$mesaId/estado",
      {"estado": estado},
    );
    return response.statusCode == 200;
  }

  // CREAMOS UNA MESA NUEVA (SOLO ADMIN)
  static Future<void> crearMesa(String nombre, int capacidad) async {
    final response = await ApiClient.post(
      ApiConfig.mesas,
      {"nombre": nombre, "capacidad": capacidad},
    );

    if (response.statusCode != 201) {
      throw Exception(_mensajeError(response, "No se pudo crear la mesa"));
    }
  }

  // EDITAMOS NOMBRE Y CAPACIDAD DE UNA MESA (SOLO ADMIN)
  static Future<void> actualizarMesa(
    String mesaId,
    String nombre,
    int capacidad,
  ) async {
    final response = await ApiClient.put(
      "${ApiConfig.mesas}/$mesaId",
      {"nombre": nombre, "capacidad": capacidad},
    );

    if (response.statusCode != 200) {
      throw Exception(_mensajeError(response, "No se pudo actualizar la mesa"));
    }
  }

  // ELIMINAMOS UNA MESA (SOFT DELETE, SOLO ADMIN)
  static Future<void> eliminarMesa(String mesaId) async {
    final response = await ApiClient.delete("${ApiConfig.mesas}/$mesaId");

    if (response.statusCode != 200) {
      throw Exception(_mensajeError(response, "No se pudo eliminar la mesa"));
    }
  }

  // SACAMOS EL MENSAJE DEL BACKEND PARA MOSTRARLO EN PANTALLA
  static String _mensajeError(http.Response response, String porDefecto) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map) {
        // EL NOMBRE ES UNICO: MONGO RESPONDE E11000 CUANDO SE REPITE
        if (data["error"].toString().contains("E11000")) {
          return "Ya existe una mesa con ese nombre";
        }
        if (data["message"] != null) return data["message"].toString();
      }
    } catch (_) {}
    return porDefecto;
  }
}