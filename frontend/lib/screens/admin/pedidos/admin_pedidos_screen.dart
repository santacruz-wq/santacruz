
import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../../../models/orden_model.dart';
import '../../../models/orden_detalle_model.dart';
import '../../../services/orden_service.dart';
import 'controllers/admin_pedidos_controller.dart';
import 'widgets/pedido_detalle_sheet.dart';
import 'widgets/pedidos_contenido.dart';
import 'widgets/pedidos_filtros.dart';

class AdminPedidosScreen extends StatefulWidget {
  const AdminPedidosScreen({super.key});

  @override
  State<AdminPedidosScreen> createState() => _AdminPedidosScreenState();
}

class _AdminPedidosScreenState extends State<AdminPedidosScreen> {
  late final AdminPedidosController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AdminPedidosController();
    _controller.cargarOrdenes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final ahora = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: _controller.fechaElegida ?? ahora,
      firstDate: DateTime(2020),
      lastDate: DateTime(ahora.year, ahora.month, ahora.day),
      helpText: 'Seleccionar fecha de pedidos',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (!mounted || fecha == null) return;
    _controller.elegirFecha(fecha);
  }

  Future<void> _mostrarDetalle(OrdenModel orden) async {
    var dialogoAbierto = true;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.caramelo),
      ),
    );

    try {
      final resultado = await OrdenService.getOrdenPorId(orden.id);
      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();
      dialogoAbierto = false;

      final detalles =
          resultado['detalles'] as List<OrdenDetalleModel>;

      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.cremaClaro,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => PedidoDetalleSheet(
          orden: orden,
          detalles: detalles,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      if (dialogoAbierto) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo cargar el detalle: '
            '${e.toString().replaceFirst('Exception: ', '')}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final ordenes = _controller.ordenesFiltradas;

        return Scaffold(
          backgroundColor: AppColors.crema,
          appBar: AppBar(
            backgroundColor: AppColors.crema,
            foregroundColor: AppColors.textoCafe,
            elevation: 0,
            title: const Text(
              'Pedidos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                tooltip: 'Actualizar pedidos',
                onPressed: _controller.cargando
                    ? null
                    : _controller.cargarOrdenes,
                icon: const Icon(Icons.refresh),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                PedidosFiltros(
                  busquedaController: _controller.busquedaController,
                  busqueda: _controller.busqueda,
                  filtroFecha: _controller.filtroFecha,
                  filtroEstado: _controller.filtroEstado,
                  fechaElegida: _controller.fechaElegida,
                  estados: AdminPedidosController.estados,
                  onBusqueda: _controller.cambiarBusqueda,
                  onLimpiarBusqueda: _controller.limpiarBusqueda,
                  onCambiarFecha: _controller.cambiarFecha,
                  onCambiarEstado: _controller.cambiarEstado,
                  onElegirFecha: _elegirFecha,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.receipt_long_outlined,
                        color: AppColors.cafeMedio,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _controller.cargando
                              ? 'Cargando pedidos...'
                              : '${ordenes.length} '
                                  '${ordenes.length == 1 ? 'pedido encontrado' : 'pedidos encontrados'}',
                          style: const TextStyle(
                            color: AppColors.textoCafe,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (_controller.filtroFecha != 'todos')
                        Text(
                          _textoFecha(),
                          style: const TextStyle(
                            color: AppColors.cafeMedio,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: PedidosContenido(
                    cargando: _controller.cargando,
                    error: _controller.error,
                    ordenes: ordenes,
                    onActualizar: _controller.cargarOrdenes,
                    onVerDetalle: _mostrarDetalle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _textoFecha() {
    final fecha = _controller.fechaElegida;

    if (_controller.filtroFecha == 'elegida' && fecha != null) {
      return '${fecha.day.toString().padLeft(2, '0')}/'
          '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    }

    return _controller.filtroFecha == 'hoy' ? 'Hoy' : 'Ayer';
  }
}
