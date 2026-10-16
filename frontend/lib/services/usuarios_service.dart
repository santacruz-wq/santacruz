import 'dart:convert';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';

class UsuariosService {
  static Future<Map<String, dynamic>> listarUsuarios() async {
    final response = await ApiClient.get(
      '${ApiConfig.baseUrl}/admin/usuarios',
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'usuarios': List<Map<String, dynamic>>.from(
          data['usuarios'] ?? [],
        ),
        'total': data['total'] ?? 0,
      };
    }

    return {
      'success': false,
      'usuarios': <Map<String, dynamic>>[],
      'total': 0,
      'message': data['message'] ??
          'No fue posible cargar los usuarios',
    };
  }

  static Future<Map<String, dynamic>> cambiarRol({
    required String id,
    required String rol,
  }) async {
    final response = await ApiClient.patch(
      '${ApiConfig.baseUrl}/admin/usuarios/$id/rol',
      {'rol': rol},
    );

    final data = jsonDecode(response.body);

    return {
      'success': response.statusCode == 200 &&
          data['success'] == true,
      'message': data['message'] ??
          'No fue posible cambiar el rol',
      'usuario': data['usuario'],
    };
  }

  static Future<Map<String, dynamic>> cambiarEstado({
    required String id,
    required bool activo,
  }) async {
    final response = await ApiClient.patch(
      '${ApiConfig.baseUrl}/admin/usuarios/$id/estado',
      {'activo': activo},
    );

    final data = jsonDecode(response.body);

    return {
      'success': response.statusCode == 200 &&
          data['success'] == true,
      'message': data['message'] ??
          'No fue posible cambiar el estado',
      'usuario': data['usuario'],
    };
  }
}