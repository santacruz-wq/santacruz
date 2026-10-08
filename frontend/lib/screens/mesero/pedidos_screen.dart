import 'package:flutter/material.dart';

import 'detalle_pedido_screen.dart';
import 'helpers/detalle_colores.dart';
import 'helpers/pedidos_loader.dart';
import 'widgets/pedidos_activos_error.dart';
import 'widgets/pedidos_activos_lista.dart';
import 'widgets/pedidos_activos_vacios.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  late Future<List<Map<String, dynamic>>> _pedidosFuture;

  @override
  void initState() {
    super.initState();
    _pedidosFuture = cargarPedidosActivos();
  }

  Future<void> _recargar() async {
    setState(() {
      _pedidosFuture = cargarPedidosActivos();
    });

    await _pedidosFuture;
  }

  void _abrirDetalle(String ordenId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetallePedidoScreen(
          ordenId: ordenId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DetalleColores.fondo,
      appBar: AppBar(
        backgroundColor: DetalleColores.fondo,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pedidos',
          style: TextStyle(
            color: DetalleColores.textoCafe,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _recargar,
            icon: const Icon(
              Icons.refresh,
              color: DetalleColores.cafeMedio,
            ),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _pedidosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return PedidosActivosError(
              error: snapshot.error,
              onReintentar: _recargar,
            );
          }

          final pedidos = snapshot.data ?? [];

          if (pedidos.isEmpty) {
            return PedidosActivosVacios(
              onRefresh: _recargar,
            );
          }

          return PedidosActivosLista(
            pedidos: pedidos,
            onRefresh: _recargar,
            onAbrirDetalle: _abrirDetalle,
          );
        },
      ),
    );
  }
}