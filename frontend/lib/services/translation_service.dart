import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/config/app_strings.dart';

class TranslationService {
  static final Map<String, String> _cache = {};

  // Evita repetir solicitudes para el mismo texto e idioma.
  static final Map<String, Future<String>> _solicitudesActivas = {};

  // Lotes pequeños para no saturar el backend.
  static const int _tamanoLote = 4;

  // Tiempo máximo de espera por solicitud.
  static const Duration _tiempoLimite = Duration(seconds: 6);

  static Future<Map<String, String>> traducirInterfaz(
    String idiomaDestino,
  ) async {
    if (idiomaDestino == 'es') {
      return Map<String, String>.from(AppStrings.base);
    }

    final entradas = AppStrings.base.entries.toList();

    final traducciones = await traducirLista(
      entradas.map((entrada) => entrada.value).toList(),
      idiomaDestino,
    );

    final resultado = <String, String>{};

    for (int i = 0; i < entradas.length; i++) {
      resultado[entradas[i].key] = traducciones[i];
    }

    return resultado;
  }

  static Future<String> _traducirUno(
    String texto,
    String idiomaDestino,
  ) async {
    final original = texto.trim();

    if (original.isEmpty || idiomaDestino == 'es') {
      return texto;
    }

    final clave = '$idiomaDestino|$original';

    final guardado = _cache[clave];
    if (guardado != null) {
      return guardado;
    }

    // Si ya se está traduciendo el mismo texto, reutiliza la solicitud.
    final solicitudExistente = _solicitudesActivas[clave];
    if (solicitudExistente != null) {
      return solicitudExistente;
    }

    final solicitud = _solicitarTraduccion(
      original,
      idiomaDestino,
      clave,
    );

    _solicitudesActivas[clave] = solicitud;

    try {
      return await solicitud;
    } finally {
      _solicitudesActivas.remove(clave);
    }
  }

  static Future<String> _solicitarTraduccion(
    String original,
    String idiomaDestino,
    String clave,
  ) async {
    try {
      final response = await ApiClient.post(
        ApiConfig.traducir,
        {
          'texto': original,
          'idiomaDestino': idiomaDestino,
          'idiomaOrigen': 'es',
        },
        auth: false,
      ).timeout(_tiempoLimite);

      if (response.statusCode != 200) {
        debugPrint(
          'Traducción HTTP ${response.statusCode}: $original',
        );
        return original;
      }

      final data = jsonDecode(response.body);

      if (data is! Map<String, dynamic>) {
        return original;
      }

      final valor = data['textoTraducido'];

      if (valor is! String || valor.trim().isEmpty) {
        return original;
      }

      final traducido = _limpiarTexto(valor);

      if (traducido.isEmpty) {
        return original;
      }

      _cache[clave] = traducido;
      return traducido;
    } on TimeoutException {
      debugPrint('Tiempo agotado al traducir: $original');
      return original;
    } catch (e) {
      debugPrint('No se pudo traducir "$original": $e');
      return original;
    }
  }

  static String _limpiarTexto(String texto) {
    return texto
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .trim()
        .replaceFirst(RegExp(r'^\d+\.\s*'), '');
  }

  static Future<List<String>> traducirLista(
    List<String> textos,
    String idiomaDestino,
  ) async {
    if (idiomaDestino == 'es') {
      return List<String>.from(textos);
    }

    final resultado = List<String>.from(textos);
    final posiciones = <String, List<int>>{};

    for (int i = 0; i < textos.length; i++) {
      final texto = textos[i];

      if (texto.trim().isEmpty) {
        continue;
      }

      posiciones.putIfAbsent(texto, () => []).add(i);
    }

    final textosUnicos = posiciones.keys.toList();

    for (
      int inicio = 0;
      inicio < textosUnicos.length;
      inicio += _tamanoLote
    ) {
      final fin = (inicio + _tamanoLote < textosUnicos.length)
          ? inicio + _tamanoLote
          : textosUnicos.length;

      final lote = textosUnicos.sublist(inicio, fin);

      final traducciones = await Future.wait(
        lote.map((texto) => _traducirUno(texto, idiomaDestino)),
      );

      for (int i = 0; i < lote.length; i++) {
        final original = lote[i];

        for (final posicion in posiciones[original]!) {
          resultado[posicion] = traducciones[i];
        }
      }
    }

    return resultado;
  }

  static Future<String> traducirTexto(
    String texto,
    String idiomaDestino,
  ) {
    if (idiomaDestino == 'es') {
      return Future.value(texto);
    }

    return _traducirUno(texto, idiomaDestino);
  }
}