import 'package:flutter/material.dart';

import '../../models/orden_model.dart';
import '../../services/orden_service.dart';
import '../../services/socket_service.dart';
import 'helpers/cocina_notificaciones.dart';
import 'helpers/cocina_pedidos_loader.dart';
import 'widgets/pedidos_error.dart';
import 'widgets/pedidos_lista.dart';
import 'widgets/pedidos_vacios.dart';

class PedidosCocinaScreen extends StatefulWidget {
  const PedidosCocinaScreen({
    super.key,
  });

  @override
  State<PedidosCocinaScreen> createState() =>
      _PedidosCocinaScreenState();
}

class _PedidosCocinaScreenState
    extends State<PedidosCocinaScreen> {
  late Future<List<Map<String, dynamic>>> _pedidosFuture;

  @override
  void initState() {
    super.initState();

    _pedidosFuture = cargarPedidosEnCocina();

    // ESCUCHAR NUEVAS ADICIONES
    SocketService.escucharNuevaAdicion(
      _manejarNuevaAdicion,
    );

    // ESCUCHAR NUEVOS PEDIDOS EN COCINA
    SocketService.escucharPedidoEnCocina(
      _manejarPedidoEnCocina,
    );
  }

  @override
  void dispose() {
    SocketService.dejarDeEscucharNuevaAdicion(
      _manejarNuevaAdicion,
    );

    SocketService.dejarDeEscucharPedidoEnCocina(
      _manejarPedidoEnCocina,
    );

    super.dispose();
  }

  // CUANDO LLEGA UNA NUEVA ADICIÓN
  void _manejarNuevaAdicion(dynamic data) {
    print('🔥🔥🔥 NUEVA ADICIÓN RECIBIDA: $data');
    if (!mounted) return;

    setState(() {
      _pedidosFuture = cargarPedidosEnCocina();
    });

    final nombreMesa = extraerNombreMesa(data);

    final mensaje = nombreMesa != null
        ? '🔔 Nueva adición en $nombreMesa'
        : '🔔 Nueva adición para preparar';

    mostrarNotificacionCocina(
      context,
      mensaje,
      conAccionVer: true,
    );
  }

  // CUANDO LLEGA UN NUEVO PEDIDO A COCINA
  void _manejarPedidoEnCocina(dynamic data) {
    if (!mounted) return;

    setState(() {
      _pedidosFuture = cargarPedidosEnCocina();
    });

    final nombreMesa = extraerNombreMesa(data);

    final mensaje = nombreMesa != null
        ? '🔔 Nuevo pedido en $nombreMesa'
        : '🔔 Nuevo pedido para preparar';

    mostrarNotificacionCocina(context, mensaje);
  }

  Future<void> _recargar() async {
    setState(() {
      _pedidosFuture = cargarPedidosEnCocina();
    });

    await _pedidosFuture;
  }

  Future<void> _marcarComoListo(
    OrdenModel orden,
  ) async {
    try {
      await OrdenService.cambiarEstado(
        orden.id,
        'listo',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${orden.mesaNombre} marcada como lista.',
          ),
        ),
      );

      await _recargar();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pedidos en cocina',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: _recargar,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _pedidosFuture,
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return PedidosError(
              onReintentar: _recargar,
            );
          }

          final pedidos = snapshot.data ?? [];

          if (pedidos.isEmpty) {
            return PedidosVacios(
              onRefresh: _recargar,
            );
          }

          return PedidosLista(
            pedidos: pedidos,
            onRefresh: _recargar,
            onMarcarListo: _marcarComoListo,
          );
        },
      ),
    );
  }
}