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

  //RESPONDE DESDE MEMORIA, SIN IR AL BACKEND
  bool esFavorito(String productoId) => _ids.contains(productoId);

  //SE LLAMA AL INICIAR SESION
  Future<void> cargarFavoritos() async {
    _cargando = true;
    notifyListeners();

    try {
      //AJUSTAR: debe devolver List<ProductModel>
      final lista = await FavoritoService.getFavoritos();
      _productos = lista;
      _ids
        ..clear()
        ..addAll(lista.map((p) => p.id));
    } catch (_) {
      //SI FALLA DEJAMOS LO QUE HABIA
    }

    _cargando = false;
    notifyListeners();
  }

  //MARCA O DESMARCA. DEVUELVE false SI FALLO EL BACKEND
  Future<bool> toggle(String productoId) async {
    final eraFavorito = _ids.contains(productoId);

    //ACTUALIZAMOS LA UI DE INMEDIATO (OPTIMISTA)
    if (eraFavorito) {
      _ids.remove(productoId);
      _productos = _productos.where((p) => p.id != productoId).toList();
    } else {
      _ids.add(productoId);
    }
    notifyListeners();

    final exito = eraFavorito
        ? await FavoritoService.quitarFavorito(productoId)
        : await FavoritoService.agregarFavorito(productoId);

    //SI FALLA REVERTIMOS RECARGANDO DESDE EL BACKEND
    if (!exito) {
      await cargarFavoritos();
      return false;
    }

    //AL AGREGAR RECARGAMOS PARA QUE LA LISTA TRAIGA EL PRODUCTO COMPLETO
    if (!eraFavorito) await cargarFavoritos();

    return true;
  }

  //SE LLAMA AL CERRAR SESION
  void limpiar() {
    _ids.clear();
    _productos = [];
    notifyListeners();
  }
}