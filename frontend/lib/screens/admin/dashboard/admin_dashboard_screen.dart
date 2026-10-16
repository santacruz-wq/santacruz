import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import 'controllers/dashboard_controller.dart';
import 'widgets/dashboard_encabezado.dart';
import 'widgets/dashboard_ventas.dart';
import 'widgets/dashboard_pedidos.dart';
import 'widgets/dashboard_productos.dart';
import 'widgets/dashboard_inventario.dart';
import 'widgets/dashboard_mensajes.dart';

class AdminDashboardScreen extends StatefulWidget {
  final ValueChanged<int> onNavigate;

  const AdminDashboardScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late final DashboardController _controller;

  @override
  void initState() {
    super.initState();

    _controller = DashboardController();
    _controller.addListener(_actualizarPantalla);
    _cargarDatos();
  }

  void _actualizarPantalla() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _cargarDatos() async {
    await _controller.cargarDatos();
  }

  @override
  void dispose() {
    _controller.removeListener(_actualizarPantalla);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.caramelo,
          onRefresh: _cargarDatos,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              DashboardEncabezado(
                cargando: _controller.cargando,
                onActualizar: _cargarDatos,
              ),
              const SizedBox(height: 22),
              if (_controller.cargando)
                const LinearProgressIndicator(
                  color: AppColors.caramelo,
                ),
              if (_controller.errorOrdenes != null)
                DashboardMensajeError(
                  mensaje: _controller.errorOrdenes!,
                  onRetry: _cargarDatos,
                ),
              const SizedBox(height: 12),
              DashboardVentas(
                hoy: _controller.pesos(
                  _controller.totalVentas(_controller.pagadasHoy),
                ),
                semana: _controller.pesos(
                  _controller.totalVentas(_controller.pagadasSemana),
                ),
                mes: _controller.pesos(
                  _controller.totalVentas(_controller.pagadasMes),
                ),
                pedidosPagados: _controller.ordenesPagadas.length,
                ventasDiarias: _controller.ventasDiarias,
                etiquetas: List.generate(7, _controller.diaCorto),
                formatearPesos: _controller.pesos,
              ),
              const SizedBox(height: 26),
              DashboardPedidos(
                pendientes: _controller.cantidadEstado('pendiente'),
                cocina: _controller.cantidadEstado('en_cocina'),
                listos: _controller.cantidadEstado('listo'),
                servidos: _controller.cantidadEstado('servido'),
                pagados: _controller.cantidadEstado('pagado'),
                cancelados: _controller.cantidadEstado('cancelado'),
              ),
              const SizedBox(height: 26),
              DashboardProductos(
                productos: _controller.productosMasVendidos,
                cargando: _controller.cargando,
                error: _controller.errorProductos,
                formatearPesos: _controller.pesos,
                onRetry: _cargarDatos,
              ),
              const SizedBox(height: 26),
              DashboardInventario(
                error: _controller.errorInventario,
                agotados: _controller.stockAgotado,
                stockBajo: _controller.stockBajo,
                alertas: _controller.alertasInventario,
                onRetry: _cargarDatos,
                onVerStock: () => widget.onNavigate(1),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
