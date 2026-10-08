import 'package:flutter/material.dart';

// ============================
// 🏷️ TEXTO DEL ESTADO
// ============================

String estadoTexto(String estado) {
  switch (estado) {
    case 'pendiente':
      return 'Pendiente';

    case 'en_cocina':
      return 'En cocina';

    case 'listo':
      return 'Listo';

    case 'servido':
      return 'Servido';

    case 'pagado':
      return 'Pagado';

    case 'cancelado':
      return 'Cancelado';

    default:
      return estado;
  }
}

// ============================
// 🎨 COLOR DEL ESTADO
// ============================

Color estadoColor(String estado) {
  switch (estado) {
    case 'pendiente':
      return Colors.orange;

    case 'en_cocina':
      return Colors.blue;

    case 'listo':
      return Colors.green;

    case 'servido':
      return Colors.teal;

    case 'pagado':
      return Colors.grey;

    case 'cancelado':
      return Colors.red;

    default:
      return Colors.grey;
  }
}

// ============================
// ✅ PUEDE AGREGAR PRODUCTOS
// ============================

bool puedeAgregarProductos(String estado) {
  return estado != 'pagado' && estado != 'cancelado';
}