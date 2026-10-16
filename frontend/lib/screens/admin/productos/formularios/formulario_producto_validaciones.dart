class FormularioProductoValidaciones {
  static String? nombre(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Escribe el nombre del producto';
    }
    return null;
  }

  static String? descripcion(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Escribe una descripción';
    }
    return null;
  }

  static String? precio(String? valor) {
    final numero = double.tryParse(
      (valor ?? '').trim().replaceAll(',', '.'),
    );

    if (numero == null || numero <= 0) {
      return 'Escribe un precio válido mayor que cero';
    }
    return null;
  }

  static String? categoria(String? valor) {
    if (valor == null) {
      return 'Selecciona una categoría';
    }
    return null;
  }
}