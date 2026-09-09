import 'package:flutter/material.dart';
import '../core/storage/secure_storage.dart';

class LanguageProvider extends ChangeNotifier {
  String _idiomaCodigo = 'es'; // valor por defecto mientras carga
  String _idiomaNombre = 'Español';
  bool _idiomaElegido = false;

  String get idiomaCodigo => _idiomaCodigo;
  String get idiomaNombre => _idiomaNombre;
  bool get idiomaYaElegido => _idiomaElegido;

  // Se llama al iniciar la app para recuperar el idioma guardado
  Future<void> cargarIdiomaGuardado() async {
    final guardado = await SecureStorage.getIdioma();
    if (guardado != null) {
      _idiomaCodigo = guardado["codigo"]!;
      _idiomaNombre = guardado["nombre"]!;
      _idiomaElegido = true;
      notifyListeners();
    }
  }

  // Se llama desde LanguageSelectionScreen al elegir un país
  Future<void> setIdioma(String codigo, String nombre) async {
    _idiomaCodigo = codigo;
    _idiomaNombre = nombre;
    _idiomaElegido = true;
    await SecureStorage.saveIdioma(codigo, nombre);
    notifyListeners();
  }
}