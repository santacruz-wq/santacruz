import 'package:flutter/material.dart';

import '../../models/orden_model.dart';
import '../../models/orden_detalle_model.dart';
import '../../services/orden_service.dart';
import 'helpers/detalle_colores.dart';
import 'widgets/agregar_producto_dialog.dart';
import 'widgets/detalle_acciones.dart';
import 'widgets/detalle_pedido_error.dart';
import 'widgets/detalle_pedido_header.dart';
import 'widgets/detalle_pedido_productos.dart';

class DetallePedidoScreen extends StatefulWidget {
  final String ordenId;

  const DetallePedidoScreen({
    super.key,
    required this.ordenId,
  });

  @override
  State<DetallePedidoScreen> createState() =>
      _DetallePedidoScreenState();
}

class _DetallePedidoScreenState extends State<DetallePedidoScreen> {
  late Future<Map<String, dynamic>> _pedidoFuture;

  @override
  void initState() {
    super.initState();
    _pedidoFuture = OrdenService.getOrdenPorId(widget.ordenId);
  }

  Future<void> _recargar() async {
    setState(() {
      _pedidoFuture = OrdenService.getOrdenPorId(widget.ordenId);
    });

    await _pedidoFuture;
  }

  Future<void> _cambiarEstado(String estado) async {
    try {
      await OrdenService.cambiarEstado(
        widget.ordenId,
        estado,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Estado actualizado correctamente'),
        ),
      );

      await _recargar();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo actualizar: $e'),
        ),
      );
    }
  }

  Future<void> _agregarProducto() async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (_) => AgregarProductoDialog(
        ordenId: widget.ordenId,
      ),
    );

    if (resultado == true) {
      await _recargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    const textoCafe = DetalleColores.textoCafe;
    const cafeMedio = DetalleColores.cafeMedio;

    return Scaffold(
      backgroundColor: DetalleColores.fondo,
      appBar: AppBar(
        backgroundColor: DetalleColores.fondo,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detalle del pedido',
          style: TextStyle(
            color: textoCafe,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _recargar,
            icon: const Icon(
              Icons.refresh,
              color: cafeMedio,
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _pedidoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return DetallePedidoError(
              error: snapshot.error,
              onReintentar: _recargar,
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No se encontró el pedido',
                style: TextStyle(
                  color: textoCafe,
                  fontSize: 17,
                ),
              ),
            );
          }

          final orden =
              snapshot.data!['orden'] as OrdenModel;

          final detalles = snapshot.data!['detalles']
              as List<OrdenDetalleModel>;

          return RefreshIndicator(
            onRefresh: _recargar,
            child: ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                DetallePedidoHeader(orden: orden),
                const SizedBox(height: 16),
                DetallePedidoProductos(
                  orden: orden,
                  detalles: detalles,
                ),
                const SizedBox(height: 16),
                DetalleAcciones(
                  orden: orden,
                  onCambiarEstado: _cambiarEstado,
                  onAgregarProducto: _agregarProducto,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}