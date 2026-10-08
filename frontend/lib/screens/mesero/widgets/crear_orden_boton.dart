import 'package:flutter/material.dart';

/// Botón inferior "Crear orden (n)".
class CrearOrdenBoton extends StatelessWidget {
  final bool creandoOrden;
  final int cantidadProductos;
  final VoidCallback? onPressed;

  const CrearOrdenBoton({
    super.key,
    required this.creandoOrden,
    required this.cantidadProductos,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: onPressed,
            child: creandoOrden
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Crear orden ($cantidadProductos)',
                  ),
          ),
        ),
      ),
    );
  }
}