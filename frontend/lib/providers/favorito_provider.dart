
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/favorito_service.dart';

class FavoritoProvider extends ChangeNotifier {
  final Set<String> _ids = {};
  List<ProductModel> _productos = [];
  bool _cargando = false;

  List<ProductModel> get productos => _productos;

  bool get cargando => _cargando;

  int get total => _ids.length;

  // Verifica si un producto es favorito.
  bool esFavorito(String productoId) {
    return _ids.contains(productoId);
  }

  // Carga los favoritos desde el backend.
  Future<void> cargarFavoritos() async {
    _cargando = true;
    notifyListeners();

    try {
      final lista = await FavoritoService.getFavoritos();

      _productos = lista;

      _ids
        ..clear()
        ..addAll(lista.map((producto) => producto.id));
    } catch (error) {
      debugPrint('Error cargando favoritos: $error');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // Agrega o elimina un favorito.
  Future<bool> toggle(String productoId) async {
    final eraFavorito = _ids.contains(productoId);

    // Actualización optimista de la interfaz.
    if (eraFavorito) {
      _ids.remove(productoId);

      _productos = _productos
          .where((producto) => producto.id != productoId)
          .toList();
    } else {
      _ids.add(productoId);
    }

    notifyListeners();

    try {
      final exito = eraFavorito
          ? await FavoritoService.quitarFavorito(productoId)
          : await FavoritoService.agregarFavorito(productoId);

      if (!exito) {
        await cargarFavoritos();
        return false;
      }

      // Recupera el producto completo después de agregarlo.
      if (!eraFavorito) {
        await cargarFavoritos();
      }

      return true;
    } catch (error) {
      debugPrint('Error actualizando favorito: $error');
      await cargarFavoritos();
      return false;
    }
  }

  // Limpia los favoritos al cerrar sesión.
  void limpiar() {
    _ids.clear();
    _productos = [];
    _cargando = false;
    notifyListeners();
  }
}
