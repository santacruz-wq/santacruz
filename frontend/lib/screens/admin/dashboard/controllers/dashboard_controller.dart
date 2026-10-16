import 'package:flutter/foundation.dart';

import '../../../../models/orden_model.dart';
import '../../../../models/inventario_model.dart';
import '../../../../models/producto_mas_vendido_model.dart';
import '../../../../services/orden_service.dart';
import '../../../../services/inventario_service.dart';

class DashboardController extends ChangeNotifier {
  List<OrdenModel> ordenes = [];
  List<InventarioModel> inventario = [];
  List<ProductoMasVendidoModel> productosMasVendidos = [];

  bool cargando = true;
  String? errorOrdenes;
  String? errorInventario;
  String? errorProductos;

  DateTime get hoy {
    final ahora = DateTime.now();
    return DateTime(ahora.year, ahora.month, ahora.day);
  }

  List<OrdenModel> get ordenesPagadas =>
      ordenes.where((o) => o.estaPagado).toList();

  List<OrdenModel> get ordenesHoy => ordenes.where((o) {
        final fecha = o.createdAt;
        return fecha != null &&
            !fecha.isBefore(hoy) &&
            fecha.isBefore(hoy.add(const Duration(days: 1)));
      }).toList();

  List<OrdenModel> get pagadasHoy =>
      ordenesHoy.where((o) => o.estaPagado).toList();

  List<OrdenModel> get pagadasSemana =>
      ordenesPagadas.where((o) {
        final fecha = o.createdAt;
        return fecha != null &&
            !fecha.isBefore(hoy.subtract(const Duration(days: 6))) &&
            fecha.isBefore(hoy.add(const Duration(days: 1)));
      }).toList();

  List<OrdenModel> get pagadasMes =>
      ordenesPagadas.where((o) {
        final fecha = o.createdAt;
        return fecha != null &&
            fecha.year == hoy.year &&
            fecha.month == hoy.month;
      }).toList();

  double totalVentas(List<OrdenModel> lista) =>
      lista.fold<double>(0, (total, orden) => total + orden.total);

  int cantidadEstado(String estado) =>
      ordenes.where((o) => o.estado == estado).length;

  List<InventarioModel> get stockBajo =>
      inventario.where((i) => i.stockBajo && !i.stockAgotado).toList();

  List<InventarioModel> get stockAgotado =>
      inventario.where((i) => i.stockAgotado).toList();

  List<InventarioModel> get alertasInventario => [
        ...stockAgotado,
        ...stockBajo,
      ];

  List<double> get ventasDiarias => List.generate(7, (index) {
        final dia = hoy.subtract(Duration(days: 6 - index));

        return totalVentas(ordenesPagadas.where((o) {
          final fecha = o.createdAt;
          return fecha != null &&
              fecha.year == dia.year &&
              fecha.month == dia.month &&
              fecha.day == dia.day;
        }).toList());
      });

  String pesos(num valor) {
    final numero = valor.round().toString();
    final resultado = numero.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '\$$resultado';
  }

  String diaCorto(int desplazamiento) {
    final dia = hoy.subtract(Duration(days: 6 - desplazamiento));

    const nombres = [
      'Lun',
      'Mar',
      'Mié',
      'Jue',
      'Vie',
      'Sáb',
      'Dom',
    ];

    return nombres[dia.weekday - 1];
  }

  Future<void> cargarDatos() async {
    cargando = true;
    errorOrdenes = null;
    errorInventario = null;
    errorProductos = null;
    notifyListeners();

    try {
      ordenes = await OrdenService.getOrdenes();
    } catch (_) {
      errorOrdenes = 'No se pudieron cargar los pedidos.';
    }

    try {
      inventario = await InventarioService.getInventario();
    } catch (_) {
      errorInventario = 'No se pudo cargar el inventario.';
    }

    try {
      productosMasVendidos =
          await OrdenService.getProductosMasVendidos();
    } catch (_) {
      errorProductos =
          'No se pudieron cargar los productos más vendidos.';
    }

    cargando = false;
    notifyListeners();
  }
}