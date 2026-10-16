import 'package:flutter/material.dart';

import '../helpers/detalle_colores.dart';

/// Mensaje centrado para los estados de error o vacío del diálogo.
class DialogMensaje extends StatelessWidget {
  final String texto;

  const DialogMensaje({
    super.key,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: DetalleColores.textoCafe,
        ),
      ),
    );
  }
}