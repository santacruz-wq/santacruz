import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LanguageProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();
  static const _storageKey = 'idioma_seleccionado';

  String _idiomaCodigo = 'es'; // valor por defecto mientras carga
  String _idiomaNombre = 'Español';
  bool _idiomaElegido = false;

  String get idiomaCodigo => _idiomaCodigo;
  String get idiomaNombre => _idiomaNombre;
  bool get idiomaYaElegido => _idiomaElegido;

  // Se llama al iniciar la app para recuperar el idioma guardado
  Future<void> cargarIdiomaGuardado() async {
    final guardado = await _storage.read(key: _storageKey);
    if (guardado != null) {
      _idiomaCodigo = guardado;
      _idiomaElegido = true;
      notifyListeners();
    }
  }

  // Se llama desde LanguageSelectionScreen al elegir un país
  Future<void> setIdioma(String codigo, String nombre) async {
    _idiomaCodigo = codigo;
    _idiomaNombre = nombre;
    _idiomaElegido = true;
    await _storage.write(key: _storageKey, value: codigo);
    notifyListeners();
  }
}