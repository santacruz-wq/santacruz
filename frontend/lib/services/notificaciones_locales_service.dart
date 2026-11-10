
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificacionesLocalesService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _canal =
      AndroidNotificationChannel(
    'pedidos',
    'Notificaciones de pedidos',
    description: 'Avisos de nuevos pedidos y cambios de estado',
    importance: Importance.max,
    playSound: true,
  );

  static Future<void> inicializar() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
  settings: settings,
);

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await android?.createNotificationChannel(_canal);
    await android?.requestNotificationsPermission();

    debugPrint('Notificaciones locales inicializadas.');
  }

  static Future<void> mostrar({
    required String titulo,
    required String mensaje,
  }) async {
    const AndroidNotificationDetails detalles =
        AndroidNotificationDetails(
      'pedidos',
      'Notificaciones de pedidos',
      channelDescription: 'Avisos de nuevos pedidos y cambios de estado',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails configuracion =
        NotificationDetails(android: detalles);

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: titulo,
      body: mensaje,
      notificationDetails: configuracion,
    );
  }
}
