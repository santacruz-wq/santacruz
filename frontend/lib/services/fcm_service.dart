
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../core/config/api_config.dart';
import '../core/network/api_client.dart';

class FCMService {
  static bool _listenerConfigurado = false;

  // Solicitar permiso y registrar el dispositivo.
  static Future<void> registrarToken() async {
    try {
      final messaging = FirebaseMessaging.instance;

      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await messaging.getToken();

      if (token == null || token.isEmpty) {
        debugPrint('FCM: No se obtuvo el token del dispositivo.');
        return;
      }

      await _enviarToken(token);

      // Escuchar cambios del token de Firebase.
      if (!_listenerConfigurado) {
        _listenerConfigurado = true;

        messaging.onTokenRefresh.listen((nuevoToken) {
          _enviarToken(nuevoToken);
        });
      }
    } catch (e) {
      debugPrint('Error al registrar FCM: $e');
    }
  }

  // Enviar token al backend.
  static Future<void> _enviarToken(String token) async {
    try {
      final response = await ApiClient.post(
        ApiConfig.fcmToken,
        {
          'token': token,
          'platform': 'android',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('FCM: Dispositivo registrado correctamente.');
      } else {
        debugPrint(
          'FCM: Error al registrar dispositivo: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('FCM: Error enviando token: $e');
    }
  }

  // Desvincular el dispositivo al cerrar sesión.
  static Future<void> eliminarToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();

      if (token == null || token.isEmpty) return;

      final response = await ApiClient.post(
        ApiConfig.fcmTokenEliminar,
        {'token': token},
      );

      if (response.statusCode == 200) {
        debugPrint('FCM: Dispositivo desvinculado.');
      }
    } catch (e) {
      debugPrint('FCM: Error al desvincular dispositivo: $e');
    }
  }
}
