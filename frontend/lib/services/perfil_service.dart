
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/config/api_config.dart';
import '../core/storage/secure_storage.dart';

class PerfilService {
  static String get _url => '${ApiConfig.baseUrl}/perfil/yo';

  // Consultar los datos del administrador.
  static Future<Map<String, dynamic>> obtenerPerfil() async {
    final response = await http.get(
      Uri.parse(_url),
      headers: await _headers(),
    );

    return _procesarRespuesta(response);
  }

  // Actualizar nombre y correo.
  static Future<Map<String, dynamic>> actualizarPerfil({
    required String nombre,
    required String email,
  }) async {
    final response = await http.put(
      Uri.parse(_url),
      headers: await _headers(),
      body: jsonEncode({
        'nombre': nombre.trim(),
        'email': email.trim(),
      }),
    );

    return _procesarRespuesta(response);
  }

  // Cambiar contraseña.
  static Future<Map<String, dynamic>> cambiarPassword({
    required String passwordActual,
    required String nuevaPassword,
    required String confirmarPassword,
  }) async {
    final response = await http.patch(
      Uri.parse('$_url/password'),
      headers: await _headers(),
      body: jsonEncode({
        'passwordActual': passwordActual,
        'nuevaPassword': nuevaPassword,
        'confirmarPassword': confirmarPassword,
      }),
    );

    return _procesarRespuesta(response);
  }

  // Subir o cambiar la foto de perfil.
  static Future<Map<String, dynamic>> actualizarAvatar(
    File imagen,
  ) async {
    final token = await SecureStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('La sesión ha expirado. Inicia sesión nuevamente.');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_url/avatar'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath('avatar', imagen.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _procesarRespuesta(response);
  }

  // Obtener las cabeceras para solicitudes autenticadas.
  static Future<Map<String, String>> _headers() async {
    final token = await SecureStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('La sesión ha expirado. Inicia sesión nuevamente.');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Procesar respuestas del backend.
  static Map<String, dynamic> _procesarRespuesta(
    http.Response response,
  ) {
    Map<String, dynamic> data;

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        data = decoded;
      } else {
        throw const FormatException('Respuesta inesperada del servidor');
      }
    } on FormatException {
      throw Exception(
        'El servidor devolvió una respuesta inválida '
        '(HTTP ${response.statusCode}).',
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw Exception(
      data['message']?.toString() ??
          'Error del servidor (HTTP ${response.statusCode}).',
    );
  }
}
