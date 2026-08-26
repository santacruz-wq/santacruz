import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para manejar los favoritos del usuario de forma local.
/// Cuando el backend esté listo, solo hay que reemplazar la lógica interna
/// de estos métodos por llamadas HTTP, sin cambiar la firma pública.
class FavoritosService {
  static const String _key = 'favoritos_ids';

  /// Devuelve el set de IDs de productos marcados como favoritos.
  Future<Set<String>> obtenerFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(_key) ?? [];
    return lista.toSet();
  }

  /// Verifica si un producto específico es favorito.
  Future<bool> esFavorito(String productoId) async {
    final favoritos = await obtenerFavoritos();
    return favoritos.contains(productoId);
  }

  /// Alterna el estado de favorito de un producto (lo agrega o lo quita).
  /// Devuelve el nuevo estado (true = ahora es favorito).
  Future<bool> alternarFavorito(String productoId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = await obtenerFavoritos();

    bool esFavoritoAhora;
    if (favoritos.contains(productoId)) {
      favoritos.remove(productoId);
      esFavoritoAhora = false;
    } else {
      favoritos.add(productoId);
      esFavoritoAhora = true;
    }

    await prefs.setStringList(_key, favoritos.toList());
    return esFavoritoAhora;
  }

  /// Elimina todos los favoritos (útil para logout, por ejemplo).
  Future<void> limpiarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
