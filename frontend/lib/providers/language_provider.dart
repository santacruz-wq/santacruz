
import 'package:flutter/material.dart';

import '../core/storage/secure_storage.dart';
import '../core/config/app_strings.dart';
import '../services/translation_service.dart';

class LanguageProvider extends ChangeNotifier {
  String _idiomaCodigo = 'es';
  String _idiomaNombre = 'Español';
  bool _idiomaElegido = false;
  bool _cargandoTraduccion = false;

  Map<String, String> _textos = Map<String, String>.from(AppStrings.base);

  // Evita que una traducción de interfaz bloquee la carga durante demasiado
  // tiempo si el servidor externo no responde.
  static const Duration _tiempoMaximoTraduccion = Duration(seconds: 10);

  String get idiomaCodigo => _idiomaCodigo;
  String get idiomaNombre => _idiomaNombre;
  bool get idiomaYaElegido => _idiomaElegido;
  bool get cargandoTraduccion => _cargandoTraduccion;

  String t(String clave) => _textos[clave] ?? clave;

  Future<void> cargarIdiomaGuardado() async {
    try {
      final guardado = await SecureStorage.getIdioma();

      if (guardado == null) return;

      _idiomaCodigo = guardado['codigo'] ?? 'es';
      _idiomaNombre = guardado['nombre'] ?? 'Español';
      _idiomaElegido = true;

      await _actualizarTextos();
    } catch (e) {
      debugPrint('Error al cargar el idioma guardado: $e');
      _textos = Map<String, String>.from(AppStrings.base);
      _cargandoTraduccion = false;
      notifyListeners();
    }
  }

  Future<void> setIdioma(String codigo, String nombre) async {
    // Actualiza el idioma seleccionado sin dejar la interfaz bloqueada.
    _idiomaCodigo = codigo;
    _idiomaNombre = nombre;
    _idiomaElegido = true;

    // Muestra inmediatamente los textos originales mientras se traduce.
    _textos = Map<String, String>.from(AppStrings.base);
    notifyListeners();

    try {
      await SecureStorage.saveIdioma(codigo, nombre);
    } catch (e) {
      debugPrint('Error al guardar el idioma: $e');
    }

    await _actualizarTextos();
  }

  Future<void> _actualizarTextos() async {
    if (_idiomaCodigo == 'es') {
      _textos = Map<String, String>.from(AppStrings.base);
      _cargandoTraduccion = false;
      notifyListeners();
      return;
    }

    _cargandoTraduccion = true;
    notifyListeners();

    try {
      final traducciones = await TranslationService.traducirInterfaz(
        _idiomaCodigo,
      ).timeout(_tiempoMaximoTraduccion);

      // Solo aplica el resultado si corresponde al idioma aún seleccionado.
      if (traducciones.length == AppStrings.base.length) {
        _textos = traducciones;
      }
    } catch (e) {
      debugPrint('No se pudo traducir la interfaz: $e');

      // Si falla la traducción, conserva los textos originales.
      _textos = Map<String, String>.from(AppStrings.base);
    } finally {
      _cargandoTraduccion = false;
      notifyListeners();
    }
  }
}