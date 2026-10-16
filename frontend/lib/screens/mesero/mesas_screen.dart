import 'package:flutter/material.dart';

import '../../models/mesa_model.dart';
import '../../services/mesa_service.dart';
import 'helpers/mesas_acciones.dart';
import 'helpers/mesas_socket.dart';
import 'widgets/mesas_error.dart';
import 'widgets/mesas_grid.dart';

class MesasScreen extends StatefulWidget {
  const MesasScreen({super.key});

  @override
  State<MesasScreen> createState() => _MesasScreenState();
}

class _MesasScreenState extends State<MesasScreen> {
  late Future<List<MesaModel>> _mesasFuture;

  @override
  void initState() {
    super.initState();

    _mesasFuture = MesaService.getMesas();

    // 🔔 EVENTOS DE SOCKET.IO
    escucharEventosMesas(_manejarCambioOrden);
  }

  @override
  void dispose() {
    dejarDeEscucharEventosMesas(_manejarCambioOrden);

    super.dispose();
  }

  // ============================
  // 🔔 CAMBIO EN UNA ORDEN
  // ============================

  void _manejarCambioOrden(dynamic data) {
    if (!mounted) return;

    setState(() {
      _mesasFuture = MesaService.getMesas();
    });
  }

  // ============================
  // 🔄 RECARGAR MESAS
  // ============================

  Future<void> _recargar() async {
    setState(() {
      _mesasFuture = MesaService.getMesas();
    });

    await _mesasFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _recargar,
          ),
        ],
      ),
      body: FutureBuilder<List<MesaModel>>(
        future: _mesasFuture,
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
            return MesasError(
              onReintentar: _recargar,
            );
          }

          final mesas = snapshot.data ?? [];

          // SIN MESAS
          if (mesas.isEmpty) {
            return const Center(
              child: Text(
                'No hay mesas registradas',
              ),
            );
          }

          // CUADRÍCULA DE MESAS
          return MesasGrid(
            mesas: mesas,
            onRefresh: _recargar,
            onMesaTap: (mesa) => onMesaTap(context, mesa),
          );
        },
      ),
    );
  }
}