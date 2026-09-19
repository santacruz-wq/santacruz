import 'dart:convert';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductService {
  static Future<List<ProductModel>> getProductos() async {
    final response = await ApiClient.get(
      ApiConfig.productos,
      auth: false,
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // Soporta tanto respuesta como array directo,
      // como respuesta envuelta en { productos: [...] }
      final List<dynamic> data =
          decoded is List ? decoded : (decoded['productos'] ?? []);

      return data
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception('No se pudieron cargar los productos');
    }
  }
}