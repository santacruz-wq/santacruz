import 'package:flutter/material.dart';

import '../../models/orden_model.dart';
import '../../models/orden_detalle_model.dart';
import '../../services/orden_service.dart';
import '../../widgets/mesero/agregar_producto_sheet.dart';
import '../../widgets/mesero/estado_orden_button.dart';

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
  }

  Future<void> _recargar() async {
    setState(() {
      _ordenFuture = OrdenService.getOrdenPorId(
        widget.ordenId,
      );
    });

    await _ordenFuture;
  }

  String _estadoTexto(String estado) {
    switch (estado) {
      case 'pendiente':
        return 'Pendiente';

      case 'en_cocina':
        return 'En cocina';

      case 'listo':
        return 'Listo';

      case 'servido':
        return 'Servido';

      case 'pagado':
        return 'Pagado';

      case 'cancelado':
        return 'Cancelado';

      default:
        return estado;
    }
  }

  Color _estadoColor(String estado) {
    switch (estado) {
      case 'pendiente':
        return Colors.orange;

      case 'en_cocina':
        return Colors.blue;

      case 'listo':
        return Colors.green;

      case 'servido':
        return Colors.teal;

      case 'pagado':
        return Colors.grey;

      case 'cancelado':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  Future<void> _agregarProductos(
    List<Map<String, dynamic>> productos,
  ) async {
    try {
      final ordenData =
          await OrdenService.getOrdenPorId(
        widget.ordenId,
      );

      final orden =
          ordenData['orden'] as OrdenModel;

      // SI TODAVÍA ESTÁ PENDIENTE,
      // LOS PRODUCTOS PERTENECEN AL PEDIDO ORIGINAL.

      if (orden.estaPendiente) {
        for (final item in productos) {
          await OrdenService.agregarProducto(
            ordenId: widget.ordenId,
            productoId: item['producto'],
            cantidad: item['cantidad'],
            notas: item['notas'],
          );
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Productos agregados correctamente.',
            ),
          ),
        );
      } else {
        // SI YA FUE ENVIADA A COCINA,
        // CREAMOS UNA NUEVA ADICIÓN.

        await OrdenService.crearAdicion(
          ordenId: widget.ordenId,
          productos: productos,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Nueva adición creada correctamente.',
            ),
          ),
        );
      }

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

  void _mostrarAgregarProductos() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return SizedBox(
          height:
              MediaQuery.of(context).size.height * 0.85,
          child: AgregarProductoSheet(
            onAgregar: _agregarProductos,
          ),
        );
      },
    );
  }

  bool _puedeAgregarProductos(String estado) {
    return estado != 'pagado' &&
        estado != 'cancelado';
  }

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
                    'No se pudo cargar la orden',
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

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No hay información de la orden',
              ),
            );
          }

          final orden =
              snapshot.data!['orden'] as OrdenModel;

          final detalles =
              snapshot.data!['detalles']
                  as List<OrdenDetalleModel>;

          final puedeAgregar =
              _puedeAgregarProductos(
            orden.estado,
          );

          return RefreshIndicator(
            onRefresh: _recargar,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // INFORMACIÓN DE LA ORDEN

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mesa: ${orden.mesaNombre}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Estado: ',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: _estadoColor(
                                  orden.estado,
                                ).withAlpha(30),
                                borderRadius:
                                    BorderRadius.circular(
                                  12,
                                ),
                              ),
                              child: Text(
                                _estadoTexto(
                                  orden.estado,
                                ),
                                style: TextStyle(
                                  color: _estadoColor(
                                    orden.estado,
                                  ),
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // AGREGAR PRODUCTOS / ADICIÓN

                if (puedeAgregar)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed:
                          _mostrarAgregarProductos,
                      icon: const Icon(Icons.add),
                      label: Text(
                        orden.estaPendiente
                            ? 'Agregar productos'
                            : 'Agregar nueva adición',
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // ENVIAR ORDEN A COCINA

                EstadoOrdenButton(
                  orden: orden,
                  onActualizado: _recargar,
                ),

                const SizedBox(height: 20),

                // PRODUCTOS

                const Text(
                  'Productos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                if (detalles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'No hay productos en esta orden',
                      ),
                    ),
                  )
                else
                  ...detalles.map(
                    (detalle) => Card(
                      margin:
                          const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: ListTile(
                        leading: detalle.esAdicion
                            ? const Icon(
                                Icons.add_circle,
                                color: Colors.orange,
                              )
                            : const Icon(
                                Icons.restaurant,
                              ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                detalle.productoNombre,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                            if (detalle.esAdicion)
                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color: Colors.orange
                                      .withAlpha(30),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    10,
                                  ),
                                ),
                                child: const Text(
                                  'Adición',
                                  style: TextStyle(
                                    color:
                                        Colors.orange,
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              '${detalle.cantidad} x \$${detalle.precioUnitario.toStringAsFixed(0)}',
                            ),

                            if (detalle.notas != null &&
                                detalle.notas!
                                    .trim()
                                    .isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets
                                        .only(
                                  top: 6,
                                ),
                                child: Text(
                                  '📝 ${detalle.notas}',
                                  style:
                                      const TextStyle(
                                    fontStyle:
                                        FontStyle.italic,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        trailing: Text(
                          '\$${detalle.subtotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // TOTAL

                Card(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${orden.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}