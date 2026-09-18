import 'dart:convert';
import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../models/categoria_model.dart';

class CategoriaService {
  static Future<List<Categoria>> getCategorias() async {
    final response = await ApiClient.get(ApiConfig.categorias, auth: false);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List<dynamic> data =
          decoded is List ? decoded : (decoded['categorias'] ?? []);

      return data.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('No se pudieron cargar las categorías');
    }
  }
}