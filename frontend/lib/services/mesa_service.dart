import 'dart:convert';
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
}