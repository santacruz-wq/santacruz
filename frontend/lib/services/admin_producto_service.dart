
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

  /// Crea el archivo multipart con su tipo MIME correspondiente.
  /// Acepta JPG, JPEG, PNG y WEBP.
  static http.MultipartFile _crearArchivoImagen(
    XFile imagen,
    List<int> bytes,
  ) {
    if (bytes.isEmpty) {
      throw Exception('La imagen seleccionada está vacía.');
    }

    // Intenta obtener la extensión del nombre del archivo.
    var nombreArchivo = imagen.name.trim();
    var extension = '';

    final nombreParaAnalizar = nombreArchivo.isNotEmpty
        ? nombreArchivo
        : imagen.path;

    final ultimoPunto = nombreParaAnalizar.lastIndexOf('.');
    final ultimaBarra = nombreParaAnalizar.lastIndexOf('/');

    if (ultimoPunto > ultimaBarra &&
        ultimoPunto < nombreParaAnalizar.length - 1) {
      extension =
          nombreParaAnalizar.substring(ultimoPunto + 1).toLowerCase();
    }

    final tipos = <String, MediaType>{
      'jpg': MediaType('image', 'jpeg'),
      'jpeg': MediaType('image', 'jpeg'),
      'png': MediaType('image', 'png'),
      'webp': MediaType('image', 'webp'),
    };

    var tipo = tipos[extension];

    // Si el nombre no identifica el formato, comprueba los bytes reales.
    if (tipo == null) {
      if (bytes.length >= 3 &&
          bytes[0] == 0xFF &&
          bytes[1] == 0xD8 &&
          bytes[2] == 0xFF) {
        tipo = MediaType('image', 'jpeg');
        extension = 'jpg';
      } else if (bytes.length >= 8 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47 &&
          bytes[4] == 0x0D &&
          bytes[5] == 0x0A &&
          bytes[6] == 0x1A &&
          bytes[7] == 0x0A) {
        tipo = MediaType('image', 'png');
        extension = 'png';
      } else if (bytes.length >= 12 &&
          String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF' &&
          String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP') {
        tipo = MediaType('image', 'webp');
        extension = 'webp';
      }
    }

    if (tipo == null) {
      throw Exception(
        'No se reconoce el formato de la imagen. '
        'Selecciona una foto JPG, JPEG, PNG o WEBP.',
      );
    }

    // Garantiza que el archivo enviado tenga una extensión válida.
    if (nombreArchivo.isEmpty ||
        !nombreArchivo.toLowerCase().endsWith('.$extension')) {
      nombreArchivo = 'imagen.$extension';
    }

    return http.MultipartFile.fromBytes(
      'imagen',
      bytes,
      filename: nombreArchivo,
      contentType: tipo,
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
      throw Exception(
        'El servidor devolvió una lista de productos inválida.',
      );
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

    final bytes = await imagen.readAsBytes();

    request.files.add(
      _crearArchivoImagen(imagen, bytes),
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
      final bytes = await imagen.readAsBytes();

      request.files.add(
        _crearArchivoImagen(imagen, bytes),
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

  // NUEVO: cambiar entre disponible, agotado y oculto.
  static Future<void> cambiarEstadoMenu({
    required String id,
    required String estado,
  }) async {
    final token = await _obtenerToken();

    final response = await http.patch(
      Uri.parse('${ApiConfig.productos}/$id/estado-menu'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'estado': estado,
      }),
    );

    if (response.statusCode != 200) {
      throw _crearError(response);
    }
  }
}
