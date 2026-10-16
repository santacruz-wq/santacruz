import 'dart:convert';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../models/producto_model.dart';

class ProductoService {
  // OBTENER TODOS LOS PRODUCTOS
  static Future<List<ProductoModel>> getProductos() async {
    final response = await ApiClient.get(
      ApiConfig.productos,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<dynamic> lista =
          data is List ? data : (data['productos'] ?? []);

      return lista
          .map(
            (item) => ProductoModel.fromJson(item),
          )
          .where(
            (producto) => producto.disponible,
          )
          .toList();
    }

    throw Exception(
      'No se pudieron obtener los productos',
    );
  }
}