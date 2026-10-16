import 'package:flutter/material.dart';

String fechaCorta(DateTime fecha) {
  const nombresMeses = [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ];

  return '${fecha.day} ${nombresMeses[fecha.month - 1]} ${fecha.year}';
}

String horaCorta(DateTime? fecha) {
  if (fecha == null) {
    return '--:--';
  }

  final fechaLocal = fecha.toLocal();

  final hora = fechaLocal.hour.toString().padLeft(2, '0');

  final minuto = fechaLocal.minute.toString().padLeft(2, '0');

  return '$hora:$minuto';
}

Color colorEstadoHistorial(String estado) {
  switch (estado) {
    case 'pagado':
      return Colors.green;
    case 'cancelado':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String textoEstadoHistorial(String estado) {
  switch (estado) {
    case 'pagado':
      return 'Pagado';
    case 'cancelado':
      return 'Cancelado';
    default:
      return estado;
  }
}