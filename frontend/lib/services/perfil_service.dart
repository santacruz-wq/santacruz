
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../core/config/api_config.dart';
import '../core/storage/secure_storage.dart';

class PerfilService {
  static String get _url => '${ApiConfig.baseUrl}/perfil/yo';

  static Future<Map<String, dynamic>> obtenerPerfil() async {
    final response = await http.get(
      Uri.parse(_url),
      headers: await _headers(),
    );
    return _procesarRespuesta(response);
  }

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

  static Future<Map<String, dynamic>> actualizarAvatar(
    File imagen,
  ) async {
    final token = await SecureStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'La sesión ha expirado. Inicia sesión nuevamente.',
      );
    }

    if (!await imagen.exists()) {
      throw Exception('No se encontró la imagen seleccionada.');
    }

    final bytes = await imagen.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception('La imagen seleccionada está vacía.');
    }

    late String extension;
    late MediaType tipo;

    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      extension = 'jpg';
      tipo = MediaType('image', 'jpeg');
    } else if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A) {
      extension = 'png';
      tipo = MediaType('image', 'png');
    } else if (bytes.length >= 12 &&
        String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF' &&
        String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP') {
      extension = 'webp';
      tipo = MediaType('image', 'webp');
    } else {
      throw Exception(
        'Formato de imagen no compatible. Usa JPG, PNG o WEBP.',
      );
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_url/avatar'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      http.MultipartFile.fromBytes(
        'avatar',
        bytes,
        filename: 'avatar.$extension',
        contentType: tipo,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _procesarRespuesta(response);
  }

  static Future<Map<String, String>> _headers() async {
    final token = await SecureStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'La sesión ha expirado. Inicia sesión nuevamente.',
      );
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Map<String, dynamic> _procesarRespuesta(
    http.Response response,
  ) {
    Map<String, dynamic> data;

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        data = decoded;
      } else {
        throw const FormatException(
          'Respuesta inesperada del servidor.',
        );
      }
    } on FormatException {
      throw Exception(
        'El servidor devolvió una respuesta inválida '
        '(HTTP ${response.statusCode}).',
      );
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return data;
    }

    throw Exception(
      data['message']?.toString() ??
          'Error del servidor (HTTP ${response.statusCode}).',
    );
  }
}
