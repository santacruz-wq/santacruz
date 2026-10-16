import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../core/config/api_config.dart';
import '../core/storage/secure_storage.dart';
import '../models/product_model.dart';

class AdminProductoService {
  static Future<String> _obtenerToken() async {
    final token = await SecureStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'No hay una sesión activa. Inicia sesión nuevamente.',
      );
    }

    return token;
  }

  static Exception _crearError(http.Response response) {
    try {
      final dynamic datos = jsonDecode(response.body);

      if (datos is Map && datos['message'] != null) {
        return Exception(datos['message'].toString());
      }
    } catch (_) {
      // Si la respuesta no es JSON, mostramos el estado HTTP.
    }

    return Exception(
      'Error del servidor. Código: ${response.statusCode}',
    );
  }

  static Future<List<ProductModel>> obtenerProductos() async {
    final token = await _obtenerToken();

    final response = await http.get(
      Uri.parse(ApiConfig.productos),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw _crearError(response);
    }

    final dynamic respuesta = jsonDecode(response.body);

    final List<dynamic> lista;

    if (respuesta is List) {
      lista = respuesta;
    } else if (respuesta is Map && respuesta['productos'] is List) {
      lista = respuesta['productos'] as List<dynamic>;
    } else {
      throw Exception('El servidor devolvió una lista de productos inválida.');
    }

    return lista.map((item) {
      return ProductModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  static Future<void> crearProducto({
    required String productId,
    required String nombre,
    required String descripcion,
    required String precio,
    required String categoriaId,
    required XFile imagen,
  }) async {
    final token = await _obtenerToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConfig.productos),
    );

    request.headers['Authorization'] = 'Bearer $token';

    if (productId.trim().isNotEmpty) {
      request.fields['productId'] = productId.trim();
    }

    request.fields['nombre'] = nombre.trim();
    request.fields['descripcion'] = descripcion.trim();
    request.fields['precio'] = precio.trim().replaceAll(',', '.');
    request.fields['categoria'] = categoriaId;

    request.files.add(
      http.MultipartFile.fromBytes(
        'imagen',
        await imagen.readAsBytes(),
        filename: imagen.name,
      ),
    );

    final respuesta = await request.send();
    final response = await http.Response.fromStream(respuesta);

    if (response.statusCode != 201) {
      throw _crearError(response);
    }
  }

  static Future<void> actualizarProducto({
    required String id,
    required String nombre,
    required String descripcion,
    required String precio,
    required String categoriaId,
    XFile? imagen,
  }) async {
    final token = await _obtenerToken();

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiConfig.productos}/$id'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['nombre'] = nombre.trim();
    request.fields['descripcion'] = descripcion.trim();
    request.fields['precio'] = precio.trim().replaceAll(',', '.');
    request.fields['categoria'] = categoriaId;

    if (imagen != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'imagen',
          await imagen.readAsBytes(),
          filename: imagen.name,
        ),
      );
    }

    final respuesta = await request.send();
    final response = await http.Response.fromStream(respuesta);

    if (response.statusCode != 200) {
      throw _crearError(response);
    }
  }

  static Future<void> cambiarDisponibilidad({
    required String id,
    required bool disponible,
  }) async {
    final token = await _obtenerToken();

    final response = await http.patch(
      Uri.parse('${ApiConfig.productos}/$id/disponibilidad'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'disponible': disponible,
      }),
    );

    if (response.statusCode != 200) {
      throw _crearError(response);
    }
  }
}