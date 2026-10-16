class InventarioModel {
  final String id;
  final String productoId;
  final String productoNombre;

  // Datos para insumos independientes
  final String nombreInsumo;
  final String tipoInventario;
  final String unidadMedida;

  // Cantidades que pueden ser decimales
  final double cantidadDisponible;
  final double cantidadMinima;
  final double cantidadMaxima;

  InventarioModel({
    required this.id,
    required this.productoId,
    required this.productoNombre,
    required this.nombreInsumo,
    required this.tipoInventario,
    required this.unidadMedida,
    required this.cantidadDisponible,
    required this.cantidadMinima,
    required this.cantidadMaxima,
  });

  factory InventarioModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final producto = json['producto'];

    return InventarioModel(
      id: (json['_id'] ?? '').toString(),

      productoId: producto is Map
          ? (producto['_id'] ?? '').toString()
          : (producto ?? '').toString(),

      productoNombre: producto is Map
          ? (producto['nombre'] ?? '').toString()
          : '',

      nombreInsumo: (json['nombreInsumo'] ?? '').toString(),

      tipoInventario: (json['tipoInventario'] ??
              (producto != null ? 'producto' : 'insumo'))
          .toString(),

      unidadMedida: (json['unidadMedida'] ?? 'unidad').toString(),

      cantidadDisponible: _convertirDouble(
        json['cantidadDisponible'],
      ),

      cantidadMinima: _convertirDouble(
        json['cantidadMinima'],
        defecto: 5,
      ),

      cantidadMaxima: _convertirDouble(
        json['cantidadMaxima'],
        defecto: 100,
      ),
    );
  }

  static double _convertirDouble(
    dynamic valor, {
    double defecto = 0,
  }) {
    if (valor == null) return defecto;
    if (valor is num) return valor.toDouble();

    return double.tryParse(valor.toString()) ?? defecto;
  }

  // Identificar el tipo de registro
  bool get esInsumo => tipoInventario == 'insumo';

  bool get esProducto => tipoInventario == 'producto';

  // Nombre que debe mostrar la pantalla
  String get nombreMostrar {
    if (esInsumo && nombreInsumo.isNotEmpty) {
      return nombreInsumo;
    }

    if (productoNombre.isNotEmpty) {
      return productoNombre;
    }

    return nombreInsumo.isNotEmpty
        ? nombreInsumo
        : 'Producto sin nombre';
  }

  // Estado del inventario
  bool get stockBajo =>
      cantidadDisponible <= cantidadMinima;

  bool get stockAgotado =>
      cantidadDisponible <= 0;

  // Cantidad con su unidad de medida
  String get cantidadConUnidad {
    final cantidad =
        cantidadDisponible == cantidadDisponible.roundToDouble()
            ? cantidadDisponible.toInt().toString()
            : cantidadDisponible.toString();

    return '$cantidad $unidadMedida';
  }
}