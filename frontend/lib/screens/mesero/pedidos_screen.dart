import 'package:flutter/material.dart';

import '../../models/orden_model.dart';
import '../../models/orden_detalle_model.dart';
import '../../services/orden_service.dart';
import 'detalle_pedido_screen.dart';

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
    _pedidosFuture = _cargarPedidos();
  }

  Future<List<Map<String, dynamic>>> _cargarPedidos() async {
    final ordenes = await OrdenService.getOrdenes();

    final pedidosActivos = <Map<String, dynamic>>[];

    for (final orden in ordenes) {
      if (orden.estaPagado || orden.estaCancelado) {
        continue;
      }

      final data =
          await OrdenService.getOrdenPorId(orden.id);

      pedidosActivos.add({
        'orden': data['orden'] as OrdenModel,
        'detalles':
            data['detalles'] as List<OrdenDetalleModel>,
      });
    }

    return pedidosActivos;
  }

  Future<void> _recargar() async {
    setState(() {
      _pedidosFuture = _cargarPedidos();
    });

    await _pedidosFuture;
  }

  String _textoEstado(String estado) {
    switch (estado) {
      case 'pendiente':
        return 'Pendiente';
      case 'en_cocina':
        return 'En cocina';
      case 'listo':
        return 'Listo';
      case 'servido':
        return 'Entregado';
      default:
        return estado;
    }
  }

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'pendiente':
        return Colors.orange;
      case 'en_cocina':
        return Colors.deepOrange;
      case 'listo':
        return Colors.green;
      case 'servido':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _iconoEstado(String estado) {
    switch (estado) {
      case 'pendiente':
        return Icons.pending_actions;
      case 'en_cocina':
        return Icons.restaurant;
      case 'listo':
        return Icons.check_circle_outline;
      case 'servido':
        return Icons.room_service;
      default:
        return Icons.receipt_long;
    }
  }

  @override
  Widget build(BuildContext context) {
    const crema = Color(0xFFFAF0E6);
    const cremaClaro = Color(0xFFFFF8F0);
    const textoCafe = Color(0xFF3D2314);
    const cafeMedio = Color(0xFF6F4E37);
    const caramelo = Color(0xFFC87D32);

    return Scaffold(
      backgroundColor: crema,
      appBar: AppBar(
        backgroundColor: crema,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pedidos',
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _pedidosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No se pudieron cargar los pedidos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: textoCafe,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: cafeMedio,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _recargar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: caramelo,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final pedidos = snapshot.data ?? [];

          if (pedidos.isEmpty) {
            return RefreshIndicator(
              onRefresh: _recargar,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 150),
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 70,
                    color: cafeMedio,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'No hay pedidos activos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textoCafe,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Los nuevos pedidos aparecerán aquí.',
                      style: TextStyle(
                        color: cafeMedio,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _recargar,
            child: ListView.builder(
              padding:
                  const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final orden =
                    pedidos[index]['orden'] as OrdenModel;

                final detalles =
                    pedidos[index]['detalles']
                        as List<OrdenDetalleModel>;

                final colorEstado =
                    _colorEstado(orden.estado);

                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetallePedidoScreen(
                          ordenId: orden.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.only(bottom: 16),
                    color: cremaClaro,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  orden.mesaNombre.isNotEmpty
                                      ? orden.mesaNombre
                                      : 'Mesa',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: textoCafe,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      colorEstado.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _iconoEstado(
                                        orden.estado,
                                      ),
                                      size: 17,
                                      color: colorEstado,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      _textoEstado(
                                        orden.estado,
                                      ),
                                      style: TextStyle(
                                        color:
                                            colorEstado,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Mesero: ${orden.meseroNombre.isNotEmpty ? orden.meseroNombre : 'Sin asignar'}',
                            style: const TextStyle(
                              color: cafeMedio,
                            ),
                          ),
                          const Divider(height: 24),
                          ...detalles.map(
                            (detalle) => Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 8,
                              ),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    '${detalle.cantidad} × ',
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      color: textoCafe,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      detalle
                                          .productoNombre,
                                      style:
                                          const TextStyle(
                                        color: textoCafe,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${detalle.subtotal.toStringAsFixed(0)}',
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      color: textoCafe,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: textoCafe,
                                ),
                              ),
                              Text(
                                '\$${orden.total.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: caramelo,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}