
import 'package:flutter/material.dart';

import '../../../../models/orden_model.dart';
import '../../../../services/orden_service.dart';
import '../utils/pedidos_formatters.dart';

class AdminPedidosController extends ChangeNotifier {
  final busquedaController = TextEditingController();

  List<OrdenModel> _ordenes = [];
  bool cargando = true;
  String? error;
  String filtroEstado = 'todos';
  String filtroFecha = 'todos';
  String busqueda = '';
  DateTime? fechaElegida;

  static const List<String> estados = [
    'todos',
    'pendiente',
    'en_cocina',
    'listo',
    'servido',
    'pagado',
    'cancelado',
  ];

  List<OrdenModel> get ordenes => _ordenes;

  List<OrdenModel> get ordenesFiltradas {
    final texto = busqueda.trim().toLowerCase();
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final ayer = hoy.subtract(const Duration(days: 1));

    return _ordenes.where((orden) {
      final coincideEstado =
          filtroEstado == 'todos' || orden.estado == filtroEstado;

      final idCorto =
          PedidosFormatters.idCorto(orden.id).toLowerCase();

      final coincideBusqueda = texto.isEmpty ||
          orden.mesaNombre.toLowerCase().contains(texto) ||
          orden.meseroNombre.toLowerCase().contains(texto) ||
          orden.id.toLowerCase().contains(texto) ||
          idCorto.contains(texto);

      var coincideFecha = true;
      final fecha = orden.createdAt;

      if (filtroFecha != 'todos') {
        if (fecha == null) {
          coincideFecha = false;
        } else {
          final local = fecha.toLocal();
          final dia = DateTime(local.year, local.month, local.day);

          switch (filtroFecha) {
            case 'hoy':
              coincideFecha = dia == hoy;
              break;
            case 'ayer':
              coincideFecha = dia == ayer;
              break;
            case 'elegida':
              if (fechaElegida != null) {
                final elegida = fechaElegida!.toLocal();
                coincideFecha = dia ==
                    DateTime(elegida.year, elegida.month, elegida.day);
              }
              break;
          }
        }
      }

      return coincideEstado && coincideBusqueda && coincideFecha;
    }).toList();
  }

  Future<void> cargarOrdenes() async {
    if (cargando && _ordenes.isNotEmpty) return;

    cargando = true;
    error = null;
    notifyListeners();

    try {
      _ordenes = await OrdenService.getOrdenes();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      cargando = false;
      notifyListeners();
    }
  }

  void cambiarBusqueda(String valor) {
    busqueda = valor;
    notifyListeners();
  }

  void limpiarBusqueda() {
    busquedaController.clear();
    busqueda = '';
    notifyListeners();
  }

  void cambiarEstado(String valor) {
    filtroEstado = valor;
    notifyListeners();
  }

  void cambiarFecha(String valor) {
    filtroFecha = valor;
    if (valor != 'elegida') fechaElegida = null;
    notifyListeners();
  }

  void elegirFecha(DateTime fecha) {
    fechaElegida = fecha;
    filtroFecha = 'elegida';
    notifyListeners();
  }

  @override
  void dispose() {
    busquedaController.dispose();
    super.dispose();
  }
}
