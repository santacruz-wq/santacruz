
import 'package:flutter/material.dart';

import '../core/storage/secure_storage.dart';
import '../core/config/app_strings.dart';
import '../core/config/app_translations.dart';

class LanguageProvider extends ChangeNotifier {
  String _idiomaCodigo = 'es';
  String _idiomaNombre = 'Español';
  bool _idiomaElegido = false;
  bool _cargandoTraduccion = false;

  Map<String, String> _textos =
      Map<String, String>.from(AppStrings.base);

  String get idiomaCodigo => _idiomaCodigo;
  String get idiomaNombre => _idiomaNombre;
  bool get idiomaYaElegido => _idiomaElegido;
  bool get cargandoTraduccion => _cargandoTraduccion;

  String t(String clave) => _textos[clave] ?? clave;

  String _normalizarCodigo(String codigo) {
    final normalizado = codigo.trim().toLowerCase();

    if (normalizado == 'pt-br' || normalizado == 'pt_br') {
      return 'pt';
    }

    if (normalizado == 'zh-cn' ||
        normalizado == 'zh_cn' ||
        normalizado == 'zh-hans') {
      return 'zh';
    }

    return normalizado;
  }

  Future<void> cargarIdiomaGuardado() async {
    try {
      final guardado = await SecureStorage.getIdioma();

      if (guardado == null) return;

      _idiomaCodigo = _normalizarCodigo(
        guardado['codigo'] ?? 'es',
      );

      _idiomaNombre = guardado['nombre'] ?? 'Español';
      _idiomaElegido = true;

      _actualizarTextos();
    } catch (e) {
      debugPrint('Error al cargar el idioma guardado: $e');

      _idiomaCodigo = 'es';
      _idiomaNombre = 'Español';
      _textos = Map<String, String>.from(AppStrings.base);
      _cargandoTraduccion = false;

      notifyListeners();
    }
  }

  Future<void> setIdioma(String codigo, String nombre) async {
    _idiomaCodigo = _normalizarCodigo(codigo);
    _idiomaNombre = nombre;
    _idiomaElegido = true;

    _actualizarTextos();

    try {
      await SecureStorage.saveIdioma(
        _idiomaCodigo,
        _idiomaNombre,
      );
    } catch (e) {
      debugPrint('Error al guardar el idioma: $e');
    }
  }

  void _actualizarTextos() {
    _cargandoTraduccion = false;

    _textos = Map<String, String>.from(
      AppTranslations.idiomas[_idiomaCodigo] ?? AppStrings.base,
    );

    notifyListeners();
  }
}
