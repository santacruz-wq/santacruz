
import 'package:flutter/material.dart';

import '../../models/mesa_model.dart';
import '../../models/orden_model.dart';
import '../../services/mesa_service.dart';
import '../../services/orden_service.dart';
import '../../widgets/mesero/mesa_card.dart';
import 'crear_orden_screen.dart';
import 'orden_screen.dart';

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
  }

  // RECARGAMOS LAS MESAS
  Future<void> _recargar() async {
    setState(() {
      _mesasFuture = MesaService.getMesas();
    });

    await _mesasFuture;
  }

  // ACCION AL TOCAR UNA MESA
  Future<void> _onMesaTap(MesaModel mesa) async {
    // MESA LIBRE
    if (mesa.estaLibre) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CrearOrdenScreen(
            mesa: mesa,
          ),
        ),
      );

      return;
    }

    // MESA OCUPADA
    if (mesa.estaOcupada) {
      try {
        final ordenes = await OrdenService.getOrdenes();

        if (!mounted) return;

        final ordenesMesa = ordenes.where(
          (orden) =>
              orden.mesaId == mesa.id &&
              orden.estado != 'pagado' &&
              orden.estado != 'cancelado',
        ).toList();

        if (ordenesMesa.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No se encontró una orden activa para esta mesa.',
              ),
            ),
          );

          return;
        }

        final OrdenModel orden = ordenesMesa.first;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrdenScreen(
              ordenId: orden.id,
            ),
          ),
        );
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

      return;
    }

    // MESA RESERVADA U OTRO ESTADO
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${mesa.nombre} está ${mesa.estado}.',
        ),
      ),
    );
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No se pudieron cargar las mesas',
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _recargar,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
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

          // CUADRICULA DE MESAS
          return RefreshIndicator(
            onRefresh: _recargar,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              physics:
                  const AlwaysScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              itemCount: mesas.length,
              itemBuilder: (context, index) {
                final mesa = mesas[index];

                return MesaCard(
                  mesa: mesa,
                  onTap: () => _onMesaTap(mesa),
                );
              },
            ),
          );
        },
      ),
    );
  }
}