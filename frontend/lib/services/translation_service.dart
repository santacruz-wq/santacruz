
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/config/app_strings.dart';

class TranslationService {
  // Caché en memoria para no volver a solicitar textos ya traducidos.
  static final Map<String, String> _cache = {};

  // Evita enviar demasiadas solicitudes simultáneamente.
  static const int _tamanoLote = 4;

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

    final Map<String, String> resultado = {};

    for (int i = 0; i < entradas.length; i++) {
      resultado[entradas[i].key] = traducciones[i];
    }

    return resultado;
  }

  static Future<String> _traducirUno(
    String texto,
    String idiomaDestino, {
    int intentos = 2,
  }) async {
    final original = texto.trim();

    if (original.isEmpty || idiomaDestino == 'es') {
      return texto;
    }

    final clave = '$idiomaDestino|$original';

    final guardado = _cache[clave];
    if (guardado != null) {
      return guardado;
    }

    for (int intento = 1; intento <= intentos; intento++) {
      try {
        final response = await ApiClient.post(
          ApiConfig.traducir,
          {
            'texto': original,
            'idiomaDestino': idiomaDestino,
            'idiomaOrigen': 'es',
          },
          auth: false,
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data is Map<String, dynamic>) {
            final valor = data['textoTraducido'];

            if (valor is String && valor.trim().isNotEmpty) {
              final traducido = _limpiarTexto(valor);

              if (traducido.isNotEmpty) {
                _cache[clave] = traducido;
                return traducido;
              }
            }
          }

          debugPrint(
            'La API no devolvió una traducción válida para: $original',
          );
        } else {
          debugPrint(
            'Error HTTP ${response.statusCode} traduciendo: $original',
          );
        }
      } catch (e) {
        debugPrint(
          'Error de traducción, intento $intento de $intentos: $e',
        );
      }
    }

    // Si falla la API, conserva el original sin interrumpir la aplicación.
    return texto;
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

    final List<String> resultado = List.filled(textos.length, '');

    // Conserva el orden original y evita solicitudes duplicadas.
    final posiciones = <String, List<int>>{};

    for (int i = 0; i < textos.length; i++) {
      final texto = textos[i];

      if (texto.trim().isEmpty) {
        resultado[i] = texto;
        continue;
      }

      posiciones.putIfAbsent(texto, () => []).add(i);
    }

    final textosUnicos = posiciones.keys.toList();

    for (int inicio = 0;
        inicio < textosUnicos.length;
        inicio += _tamanoLote) {
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
