class ResenaFormatters {
  static String texto(dynamic valor) {
    if (valor == null || valor is Map || valor is List) {
      return '';
    }
    return valor.toString().trim();
  }

  static String nombreRelacionado(dynamic valor) {
    if (valor is Map) {
      final nombre = texto(valor['nombre']);
      return nombre.isNotEmpty ? nombre : 'Sin nombre';
    }
    return 'No disponible';
  }

  static String fecha(dynamic valor) {
    if (valor == null) return 'Fecha no disponible';

    final fecha = DateTime.tryParse(valor.toString());
    if (fecha == null) return 'Fecha no disponible';

    final local = fecha.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}';
  }

  static int calificacion(dynamic valor) {
    return int.tryParse(texto(valor)) ?? 0;
  }
}