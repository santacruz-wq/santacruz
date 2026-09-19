import 'dart:convert';
import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../models/product_model.dart';

class FavoritoService {
  // OBTENEMOS LA LISTA DE FAVORITOS DEL USUARIO (CON EL PRODUCTO POBLADO)
  static Future<List<ProductModel>> getFavoritos() async {
    final response = await ApiClient.get(ApiConfig.favoritos);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> favoritos = data["favoritos"];
      // CADA FAVORITO TRAE EL PRODUCTO POBLADO EN EL CAMPO "producto"
      return favoritos.map((item) => ProductModel.fromJson(item["producto"])).toList();
    } else {
      throw Exception("Error al obtener favoritos");
    }
  }

  // VERIFICAMOS SI UN PRODUCTO ESPECIFICO YA ES FAVORITO
  static Future<bool> esFavorito(String productoId) async {
    final response = await ApiClient.get(
      "${ApiConfig.favoritosVerificar}/$productoId",
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["esFavorito"] ?? false;
    }
    return false;
  }

  // AGREGAMOS UN PRODUCTO A FAVORITOS
  static Future<bool> agregarFavorito(String productoId) async {
    final response = await ApiClient.post(
      ApiConfig.favoritos,
      {"producto": productoId},
    );
    return response.statusCode == 201;
  }

  // QUITAMOS UN PRODUCTO DE FAVORITOS
  static Future<bool> quitarFavorito(String productoId) async {
    final response = await ApiClient.delete(
      "${ApiConfig.favoritos}/$productoId",
    );
    return response.statusCode == 200;
  }
}