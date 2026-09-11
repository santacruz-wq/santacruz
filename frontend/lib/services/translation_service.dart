import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/config/api_config.dart';
import '../core/network/api_client.dart';
import '../core/config/app_strings.dart';

class TranslationService {
  // Traduce todos los textos fijos de AppStrings.base al idioma dado.
  // Si el idioma es español, no llama al backend, devuelve los originales.
  static Future<Map<String, String>> traducirInterfaz(String idiomaDestino) async {
    if (idiomaDestino == 'es') {
      return Map.from(AppStrings.base);
    }

    final entradas = AppStrings.base.entries.toList();

    final resultados = await Future.wait(
      entradas.map((entrada) => _traducirUno(entrada.value, idiomaDestino)),
    );

    final Map<String, String> traducido = {};
    for (int i = 0; i < entradas.length; i++) {
      traducido[entradas[i].key] = resultados[i];
    }
    return traducido;
  }

  // Traduce un solo texto, con reintento si falla la primera vez
  // (MyMemory a veces falla o tarda de más, así que intentamos 2 veces
  // antes de rendirnos y devolver el texto original)
  static Future<String> _traducirUno(
    String texto,
    String idiomaDestino, {
    int intentos = 2,
  }) async {
    for (int i = 0; i < intentos; i++) {
      try {
        final response = await ApiClient.post(
          ApiConfig.traducir,
          {
            'texto': texto,
            'idiomaDestino': idiomaDestino,
            'idiomaOrigen': 'es',
          },
          auth: false,
        ).timeout(const Duration(seconds: 8));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final traducido = data['textoTraducido'] as String? ?? texto;
          return _limpiarTexto(traducido);
        }

        debugPrint('Traducción falló (${response.statusCode}) intento ${i + 1} para "$texto"');
      } catch (e) {
        debugPrint('Error traduciendo "$texto" intento ${i + 1}: $e');
      }
    }

    return texto; // si fallan todos los intentos, devuelve el original
  }

  // Limpia entidades HTML y prefijos numéricos sueltos que a veces
  // devuelve MyMemory en frases cortas de baja confianza
  static String _limpiarTexto(String texto) {
    var limpio = texto
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();

    limpio = limpio.replaceFirst(RegExp(r'^\d+\.\s*'), '');

    return limpio;
  }

  // Traduce una lista completa de textos en paralelo (para nombres de categorías, productos, etc.)
  static Future<List<String>> traducirLista(
    List<String> textos,
    String idiomaDestino,
  ) async {
    if (idiomaDestino == 'es') return textos;

    return Future.wait(
      textos.map((t) => _traducirUno(t, idiomaDestino)),
    );
  }

  // Público, para usarlo directo con contenido dinámico (un solo texto)
  static Future<String> traducirTexto(String texto, String idiomaDestino) {
    if (idiomaDestino == 'es') return Future.value(texto);
    return _traducirUno(texto, idiomaDestino);
  }
}