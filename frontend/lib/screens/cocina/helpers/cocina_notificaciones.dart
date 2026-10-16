import 'package:flutter/material.dart';

/// Saca el nombre de la mesa de lo que llega por el socket.
dynamic extraerNombreMesa(dynamic data) {
  final mesa = data is Map ? data['mesa'] : null;

  return mesa is Map ? mesa['nombre'] : mesa;
}

/// Muestra el SnackBar flotante de aviso en cocina.
void mostrarNotificacionCocina(
  BuildContext context,
  String mensaje, {
  bool conAccionVer = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mensaje,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      action: conAccionVer
          ? SnackBarAction(
              label: 'VER',
              onPressed: () {},
            )
          : null,
    ),
  );
}