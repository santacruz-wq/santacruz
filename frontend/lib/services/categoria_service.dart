import 'dart:convert';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../models/categoria_model.dart';

class CategoriaService {
  // Obtener todas las categorías, activas e inactivas.
  static Future<List<Categoria>> getCategorias() async {
    return _obtenerCategorias(ApiConfig.categorias);
  }

  // Obtener únicamente las categorías activas.
  static Future<List<Categoria>> getCategoriasActivas() async {
    final categorias = await _obtenerCategorias(
      '${ApiConfig.categorias}?activo=true',
    );

    return categorias.where((categoria) => categoria.activo).toList();
  }

  // Consultar categorías y convertir la respuesta.
  static Future<List<Categoria>> _obtenerCategorias(String url) async {
    final response = await ApiClient.get(
      url,
      auth: false,
    );

    if (response.statusCode != 200) {
      throw Exception(
        _mensajeError(
          response.body,
          'No se pudieron cargar las categorías',
        ),
      );
    }

    final dynamic respuesta = jsonDecode(response.body);
    final List<dynamic> lista;

    if (respuesta is List) {
      lista = respuesta;
    } else if (respuesta is Map && respuesta['categorias'] is List) {
      lista = respuesta['categorias'] as List<dynamic>;
    } else {
      throw Exception('La respuesta de categorías no es válida');
    }

    return lista.map((item) {
      return Categoria.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  // Crear una categoría.
  static Future<Categoria> crearCategoria({
    required String nombre,
    String descripcion = '',
    String imagen = 'assets/img/categoria.avif',
  }) async {
    final response = await ApiClient.post(
      ApiConfig.categorias,
      {
        'nombre': nombre.trim(),
        'descripcion': descripcion.trim(),
        'imagen': imagen.trim().isEmpty
            ? 'assets/img/categoria.avif'
            : imagen.trim(),
      },
    );

    if (response.statusCode != 201) {
      throw Exception(
        _mensajeError(
          response.body,
          'No se pudo crear la categoría',
        ),
      );
    }

    final dynamic respuesta = jsonDecode(response.body);
    final dynamic categoria =
        respuesta is Map ? respuesta['categoria'] : null;

    if (categoria is! Map) {
      throw Exception(
        'La respuesta al crear la categoría no es válida',
      );
    }

    return Categoria.fromJson(
      Map<String, dynamic>.from(categoria),
    );
  }

  // Actualizar nombre, descripción o imagen.
  static Future<Categoria> actualizarCategoria({
    required String id,
    required String nombre,
    String descripcion = '',
    String? imagen,
  }) async {
    final Map<String, dynamic> datos = {
      'nombre': nombre.trim(),
      'descripcion': descripcion.trim(),
    };

    if (imagen != null && imagen.trim().isNotEmpty) {
      datos['imagen'] = imagen.trim();
    }

    final response = await ApiClient.put(
      '${ApiConfig.categorias}/$id',
      datos,
    );

    if (response.statusCode != 200) {
      throw Exception(
        _mensajeError(
          response.body,
          'No se pudo actualizar la categoría',
        ),
      );
    }

    final dynamic respuesta = jsonDecode(response.body);
    final dynamic categoria =
        respuesta is Map ? respuesta['categoria'] : null;

    if (categoria is! Map) {
      throw Exception(
        'La respuesta al actualizar la categoría no es válida',
      );
    }

    return Categoria.fromJson(
      Map<String, dynamic>.from(categoria),
    );
  }

  // Activar o desactivar una categoría.
  static Future<void> cambiarEstadoCategoria(
    String id,
    bool activo,
  ) async {
    final response = activo
        ? await ApiClient.patch(
            '${ApiConfig.categorias}/$id/estado',
            {'activo': true},
            auth: true,
          )
        : await ApiClient.delete(
            '${ApiConfig.categorias}/$id',
            auth: true,
          );

    if (response.statusCode != 200) {
      throw Exception(
        _mensajeError(
          response.body,
          activo
              ? 'No se pudo reactivar la categoría'
              : 'No se pudo desactivar la categoría',
        ),
      );
    }
  }

  // Obtener el mensaje de error del backend.
  static String _mensajeError(
    String body,
    String mensajePredeterminado,
  ) {
    try {
      final dynamic respuesta = jsonDecode(body);

      if (respuesta is Map && respuesta['message'] != null) {
        return respuesta['message'].toString();
      }
    } catch (_) {
      // La respuesta no era JSON.
    }

    return mensajePredeterminado;
  }
}