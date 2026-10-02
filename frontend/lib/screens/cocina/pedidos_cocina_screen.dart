import 'package:flutter/material.dart';

import '../../models/orden_model.dart';
import '../../models/orden_detalle_model.dart';
import '../../services/orden_service.dart';

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
    _pedidosFuture = _cargarPedidos();
  }

  Future<List<Map<String, dynamic>>> _cargarPedidos() async {
    final ordenes = await OrdenService.getOrdenes();

    final List<Map<String, dynamic>> pedidos = [];

    for (final orden in ordenes) {
      if (orden.estado != 'en_cocina') {
        continue;
      }

      final data = await OrdenService.getOrdenPorId(
        orden.id,
      );

      pedidos.add({
        'orden': data['orden'] as OrdenModel,
        'detalles':
            data['detalles'] as List<OrdenDetalleModel>,
      });
    }

    return pedidos;
  }

  Future<void> _recargar() async {
    setState(() {
      _pedidosFuture = _cargarPedidos();
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
        title: const Text('Pedidos en cocina'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _recargar,
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
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Text(
                    'No se pudieron cargar los pedidos',
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

          final pedidos = snapshot.data ?? [];

          if (pedidos.isEmpty) {
            return RefreshIndicator(
              onRefresh: _recargar,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No hay pedidos pendientes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Los nuevos pedidos aparecerán aquí.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _recargar,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final orden =
                    pedidos[index]['orden'] as OrdenModel;

                final detalles =
                    pedidos[index]['detalles']
                        as List<OrdenDetalleModel>;

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.table_restaurant,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                orden.mesaNombre,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue
                                    .withAlpha(30),
                                borderRadius:
                                    BorderRadius.circular(
                                  12,
                                ),
                              ),
                              child: const Text(
                                'En cocina',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Mesero: ${orden.meseroNombre}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                        const Divider(height: 24),

                        const Text(
                          'Productos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        ...detalles.map(
                          (detalle) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 12,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        alignment:
                                            Alignment.center,
                                        decoration:
                                            BoxDecoration(
                                          color: Colors
                                              .grey
                                              .withAlpha(30),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          '${detalle.cantidad}',
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          detalle
                                              .productoNombre,
                                          style:
                                              const TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                      ),
                                      if (detalle
                                          .esAdicion)
                                        Container(
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                            horizontal: 7,
                                            vertical: 4,
                                          ),
                                          decoration:
                                              BoxDecoration(
                                            color: Colors
                                                .orange
                                                .withAlpha(
                                              30,
                                            ),
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                              8,
                                            ),
                                          ),
                                          child:
                                              const Text(
                                            'Adición',
                                            style:
                                                TextStyle(
                                              color: Colors
                                                  .orange,
                                              fontSize: 10,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  if (detalle.notas !=
                                          null &&
                                      detalle.notas!
                                          .trim()
                                          .isNotEmpty)
                                    Padding(
                                      padding:
                                          const EdgeInsets
                                              .only(
                                        left: 42,
                                        top: 5,
                                      ),
                                      child: Text(
                                        '📝 ${detalle.notas}',
                                        style:
                                            const TextStyle(
                                          fontStyle:
                                              FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _marcarComoListo(
                              orden,
                            ),
                            icon: const Icon(
                              Icons.check_circle,
                            ),
                            label: const Text(
                              'Marcar como listo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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