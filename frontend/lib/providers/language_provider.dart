import 'package:flutter/material.dart';
import '../core/storage/secure_storage.dart';
import '../core/config/app_strings.dart';
import '../services/translation_service.dart';

class LanguageProvider extends ChangeNotifier {
  String _idiomaCodigo = 'es';
  String _idiomaNombre = 'Español';
  bool _idiomaElegido = false;
  bool _cargandoTraduccion = false;

  Map<String, String> _textos = Map.from(AppStrings.base);

  String get idiomaCodigo => _idiomaCodigo;
  String get idiomaNombre => _idiomaNombre;
  bool get idiomaYaElegido => _idiomaElegido;
  bool get cargandoTraduccion => _cargandoTraduccion;

  String t(String clave) => _textos[clave] ?? clave;

  Future<void> cargarIdiomaGuardado() async {
    final guardado = await SecureStorage.getIdioma();
    if (guardado != null) {
      _idiomaCodigo = guardado["codigo"]!;
      _idiomaNombre = guardado["nombre"]!;
      _idiomaElegido = true;
      await _actualizarTextos();
      notifyListeners();
    }
  }

  Future<void> setIdioma(String codigo, String nombre) async {
    _idiomaCodigo = codigo;
    _idiomaNombre = nombre;
    _idiomaElegido = true;
    await SecureStorage.saveIdioma(codigo, nombre);
    await _actualizarTextos();
    notifyListeners();
  }

  Future<void> _actualizarTextos() async {
    _cargandoTraduccion = true;
    notifyListeners();

    _textos = await TranslationService.traducirInterfaz(_idiomaCodigo);

    _cargandoTraduccion = false;
    notifyListeners();
  }
}