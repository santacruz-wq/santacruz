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

  // VERIFICA DESDE MEMORIA SI ES FAVORITO
  bool esFavorito(String productoId) {
    return _ids.contains(productoId);
  }

  // CARGA LOS FAVORITOS DESDE EL BACKEND
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
    }

    _cargando = false;
    notifyListeners();
  }

  // AGREGA O ELIMINA UN FAVORITO
  Future<bool> toggle(String productoId) async {
    final eraFavorito = _ids.contains(productoId);

    // ACTUALIZAMOS TEMPORALMENTE LA INTERFAZ
    if (eraFavorito) {
      _ids.remove(productoId);

      _productos = _productos
          .where((producto) => producto.id != productoId)
          .toList();
    } else {
      _ids.add(productoId);
    }

    notifyListeners();

    bool exito;

    if (eraFavorito) {
      exito = await FavoritoService.quitarFavorito(productoId);
    } else {
      exito = await FavoritoService.agregarFavorito(productoId);
    }

    // SI EL BACKEND FALLA, RECARGAMOS EL ESTADO REAL
    if (!exito) {
      await cargarFavoritos();
      return false;
    }

    // DESPUÉS DE AGREGAR:
    // RECARGAMOS PARA OBTENER EL PRODUCTO COMPLETO
    if (!eraFavorito) {
      await cargarFavoritos();
    }

    return true;
  }

  // LIMPIAR AL CERRAR SESIÓN
  void limpiar() {
    _ids.clear();
    _productos = [];
    notifyListeners();
  }
}