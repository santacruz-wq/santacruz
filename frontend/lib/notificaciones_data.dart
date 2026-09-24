import 'package:flutter/material.dart';

class Notificacion {
  final String pedido;
  final String mensaje;
  final String estado;
  final int minutos;
  final DateTime fecha;
  bool leida;

  Notificacion({
    required this.pedido,
    required this.mensaje,
    required this.estado,
    required this.minutos,
    required this.fecha,
    this.leida = false,
  });
}

class NotificacionesData {
  static final ValueNotifier<List<Notificacion>> notificaciones =
      ValueNotifier<List<Notificacion>>([]);

  static int _numeroPedido = 0;

  // ================================================================
  // AGREGAR NOTIFICACIÓN
  // ================================================================

  static void agregarNotificacion({
    String? pedido,
    required String mensaje,
    required String estado,
    required int minutos,
  }) {
    final String numeroPedido;

    if (pedido != null && pedido.isNotEmpty) {
      numeroPedido = pedido;
    } else {
      _numeroPedido++;

      numeroPedido =
          '#${_numeroPedido.toString().padLeft(3, '0')}';
    }

    final nuevaNotificacion = Notificacion(
      pedido: numeroPedido,
      mensaje: mensaje,
      estado: estado,
      minutos: minutos,
      fecha: DateTime.now(),
    );

    notificaciones.value = [
      nuevaNotificacion,
      ...notificaciones.value,
    ];
  }

  // ================================================================
  // MARCAR COMO LEÍDA
  // ================================================================

  static void marcarComoLeida(int index) {
    final lista = [...notificaciones.value];

    if (index >= 0 && index < lista.length) {
      lista[index].leida = true;
      notificaciones.value = lista;
    }
  }

  // ================================================================
  // MARCAR TODAS COMO LEÍDAS
  // ================================================================

  static void marcarTodasComoLeidas() {
    final lista = [...notificaciones.value];

    for (final notificacion in lista) {
      notificacion.leida = true;
    }

    notificaciones.value = lista;
  }

  // ================================================================
  // ELIMINAR NOTIFICACIÓN
  // ================================================================

  static void eliminarNotificacion(int index) {
    final lista = [...notificaciones.value];

    if (index >= 0 && index < lista.length) {
      lista.removeAt(index);
      notificaciones.value = lista;
    }
  }

  // ================================================================
  // ELIMINAR TODAS
  // ================================================================

  static void eliminarTodas() {
    notificaciones.value = [];
  }

  // ================================================================
  // CONTADOR DE NO LEÍDAS
  // ================================================================

  static int get cantidadNoLeidas {
    return notificaciones.value
        .where((notificacion) => !notificacion.leida)
        .length;
  }
}