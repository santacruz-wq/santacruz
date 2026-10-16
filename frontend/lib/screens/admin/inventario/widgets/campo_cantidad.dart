
import 'package:flutter/material.dart';

class CampoCantidad extends StatelessWidget {
  final TextEditingController controller;
  final String etiqueta;
  final String? unidad;
  final bool permitirCero;
  final bool habilitado;

  const CampoCantidad({
    super.key,
    required this.controller,
    required this.etiqueta,
    this.unidad,
    this.permitirCero = true,
    this.habilitado = true,
  });

  static double? leer(String? texto) {
    if (texto == null || texto.trim().isEmpty) return null;
    return double.tryParse(texto.trim().replaceAll(',', '.'));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: habilitado,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: InputDecoration(
        labelText: etiqueta,
        suffixText: unidad,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        final numero = leer(value);
        if (numero == null || !numero.isFinite) {
          return 'Ingresa un número válido';
        }
        if (permitirCero ? numero < 0 : numero <= 0) {
          return permitirCero
              ? 'No puede ser negativo'
              : 'Debe ser mayor que cero';
        }
        return null;
      },
    );
  }
}
