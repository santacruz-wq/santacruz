import 'package:flutter/material.dart';

import '../../models/orden_model.dart';
import '../../models/orden_detalle_model.dart';
import '../../services/orden_service.dart';
import '../../widgets/mesero/agregar_producto_sheet.dart';
import 'helpers/orden_acciones.dart';
import 'helpers/orden_socket.dart';
import 'widgets/orden_contenido.dart';
import 'widgets/orden_error.dart';

class OrdenScreen extends StatefulWidget {
  final String ordenId;

  const OrdenScreen({
    super.key,
    required this.ordenId,
  });

  @override
  State<OrdenScreen> createState() => _OrdenScreenState();
}

class _OrdenScreenState extends State<OrdenScreen> {
  late Future<Map<String, dynamic>> _ordenFuture;

  @override
  void initState() {
    super.initState();

    _ordenFuture = OrdenService.getOrdenPorId(
      widget.ordenId,
    );

    // 🔔 ESCUCHAR CAMBIOS DE ORDEN
    escucharEventosOrden(_manejarCambioOrden);
  }

  @override
  void dispose() {
    dejarDeEscucharEventosOrden(_manejarCambioOrden);

    super.dispose();
  }

  // ============================
  // 🔔 CAMBIO RECIBIDO POR SOCKET
  // ============================

  void _manejarCambioOrden(dynamic data) {
    if (!mounted) return;

    if (data is Map) {
      final ordenId = data['ordenId']?.toString();

      // Solo actualizamos esta orden.
      if (ordenId != null &&
          ordenId != widget.ordenId) {
        return;
      }
    }

    setState(() {
      _ordenFuture = OrdenService.getOrdenPorId(
        widget.ordenId,
      );
    });
  }

  // ============================
  // 🔄 RECARGAR
  // ============================

  Future<void> _recargar() async {
    setState(() {
      _ordenFuture = OrdenService.getOrdenPorId(
        widget.ordenId,
      );
    });

    await _ordenFuture;
  }

  // ============================
  // ➕ MOSTRAR PRODUCTOS
  // ============================

  void _mostrarAgregarProductos() {
    final screenContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return SizedBox(
          height:
              MediaQuery.of(context).size.height * 0.85,
          child: AgregarProductoSheet(
            onAgregar: (productos) =>
                agregarProductosAOrden(
              screenContext,
              widget.ordenId,
              productos,
              _recargar,
            ),
          ),
        );
      },
    );
  }

  // ============================
  // 🖥️ BUILD
  // ============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orden'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _recargar,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _ordenFuture,
        builder: (context, snapshot) {
          // CARGANDO
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ERROR
          if (snapshot.hasError) {
            return OrdenError(
              onReintentar: _recargar,
            );
          }

          // SIN DATOS
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No hay información de la orden',
              ),
            );
          }

          final orden =
              snapshot.data!['orden'] as OrdenModel;

          final detalles = snapshot.data!['detalles']
              as List<OrdenDetalleModel>;

          return OrdenContenido(
            orden: orden,
            detalles: detalles,
            onRefresh: _recargar,
            onAgregarProductos: _mostrarAgregarProductos,
          );
        },
      ),
    );
  }
}