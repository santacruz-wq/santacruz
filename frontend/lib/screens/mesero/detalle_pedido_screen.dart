import 'package:flutter/material.dart';

import '../../models/orden_model.dart';
import '../../models/orden_detalle_model.dart';
import '../../models/product_model.dart';
import '../../services/orden_service.dart';
import '../../services/product_service.dart';

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
      case 'pagado':
        return 'Pagado';
      case 'cancelado':
        return 'Cancelado';
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
      case 'pagado':
        return Colors.grey;
      case 'cancelado':
        return Colors.red;
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
      case 'pagado':
        return Icons.payments_outlined;
      case 'cancelado':
        return Icons.cancel_outlined;
      default:
        return Icons.receipt_long;
    }
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
      builder: (_) => _AgregarProductoDialog(
        ordenId: widget.ordenId,
      ),
    );

    if (resultado == true) {
      await _recargar();
    }
  }

  Widget _botonAccion({
    required String texto,
    required IconData icono,
    required VoidCallback onPressed,
    bool principal = false,
  }) {
    const caramelo = Color(0xFFC87D32);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icono),
        label: Text(texto),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              principal ? caramelo : Colors.white,
          foregroundColor:
              principal ? Colors.white : caramelo,
          elevation: 0,
          side: principal
              ? null
              : const BorderSide(
                  color: caramelo,
                ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _acciones(OrdenModel orden) {
    if (orden.estaPagado || orden.estaCancelado) {
      return const SizedBox.shrink();
    }

    if (orden.estaPendiente) {
      return Column(
        children: [
          _botonAccion(
            texto: 'Enviar a cocina',
            icono: Icons.restaurant,
            principal: true,
            onPressed: () {
              _cambiarEstado('en_cocina');
            },
          ),
          const SizedBox(height: 10),
          _botonAccion(
            texto: 'Agregar producto',
            icono: Icons.add_shopping_cart,
            onPressed: _agregarProducto,
          ),
        ],
      );
    }

    if (orden.estaEnCocina) {
      return _botonAccion(
        texto: 'Agregar producto',
        icono: Icons.add_shopping_cart,
        onPressed: _agregarProducto,
      );
    }

    if (orden.estaListo) {
      return Column(
        children: [
          _botonAccion(
            texto: 'Marcar como entregado',
            icono: Icons.room_service,
            principal: true,
            onPressed: () {
              _cambiarEstado('servido');
            },
          ),
          const SizedBox(height: 10),
          _botonAccion(
            texto: 'Agregar producto',
            icono: Icons.add_shopping_cart,
            onPressed: _agregarProducto,
          ),
        ],
      );
    }

    if (orden.estaServido) {
      return Column(
        children: [
          _botonAccion(
            texto: 'Marcar como pagado',
            icono: Icons.payments,
            principal: true,
            onPressed: () {
              _cambiarEstado('pagado');
            },
          ),
          const SizedBox(height: 10),
          _botonAccion(
            texto: 'Agregar producto',
            icono: Icons.add_shopping_cart,
            onPressed: _agregarProducto,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    const cremaClaro = Color(0xFFFFF8F0);
    const textoCafe = Color(0xFF3D2314);
    const cafeMedio = Color(0xFF6F4E37);
    const caramelo = Color(0xFFC87D32);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF0E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF0E6),
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
                      'No se pudo cargar el pedido',
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

          final detalles =
              snapshot.data!['detalles']
                  as List<OrdenDetalleModel>;

          final colorEstado =
              _colorEstado(orden.estado);

          return RefreshIndicator(
            onRefresh: _recargar,
            child: ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: cremaClaro,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
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
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: textoCafe,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 11,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    colorEstado.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  Icon(
                                    _iconoEstado(
                                      orden.estado,
                                    ),
                                    size: 18,
                                    color: colorEstado,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _textoEstado(
                                      orden.estado,
                                    ),
                                    style: TextStyle(
                                      color: colorEstado,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Mesero: ${orden.meseroNombre.isNotEmpty ? orden.meseroNombre : 'Sin asignar'}',
                          style: const TextStyle(
                            color: cafeMedio,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: cremaClaro,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Productos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textoCafe,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...detalles.map(
                          (detalle) => Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 14,
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  alignment:
                                      Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        caramelo.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  child: Text(
                                    '${detalle.cantidad}',
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      color: caramelo,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        detalle
                                            .productoNombre,
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          color: textoCafe,
                                          fontSize: 16,
                                        ),
                                      ),
                                      if (detalle
                                              .notas !=
                                          null &&
                                          detalle
                                              .notas!
                                              .trim()
                                              .isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets
                                                  .only(
                                            top: 4,
                                          ),
                                          child: Text(
                                            'Nota: ${detalle.notas}',
                                            style:
                                                const TextStyle(
                                              color:
                                                  cafeMedio,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      Text(
                                        '\$${detalle.precioUnitario.toStringAsFixed(0)} c/u',
                                        style:
                                            const TextStyle(
                                          color: cafeMedio,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '\$${detalle.subtotal.toStringAsFixed(0)}',
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    color: textoCafe,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textoCafe,
                              ),
                            ),
                            Text(
                              '\$${orden.total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: caramelo,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _acciones(orden),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AgregarProductoDialog extends StatefulWidget {
  final String ordenId;

  const _AgregarProductoDialog({
    required this.ordenId,
  });

  @override
  State<_AgregarProductoDialog> createState() =>
      _AgregarProductoDialogState();
}

class _AgregarProductoDialogState
    extends State<_AgregarProductoDialog> {
  late Future<List<ProductModel>> _productosFuture;

  ProductModel? _productoSeleccionado;

  int _cantidad = 1;

  final _notasController = TextEditingController();

  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _productosFuture = ProductService.getProductos();
  }

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final producto = _productoSeleccionado;

    if (producto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecciona un producto',
          ),
        ),
      );
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      /*
       * Si el pedido todavía está pendiente,
       * usamos agregarProducto().
       *
       * Si ya fue enviado a cocina, usamos crearAdicion()
       * para que el nuevo producto llegue nuevamente a cocina.
       */

      final pedido =
          await OrdenService.getOrdenPorId(
        widget.ordenId,
      );

      final orden =
          pedido['orden'] as OrdenModel;

      final notas =
          _notasController.text.trim().isEmpty
              ? null
              : _notasController.text.trim();

      if (orden.estaPendiente) {
        await OrdenService.agregarProducto(
          ordenId: widget.ordenId,
          productoId: producto.id,
          cantidad: _cantidad,
          notas: notas,
        );
      } else if (orden.estaEnCocina ||
          orden.estaListo ||
          orden.estaServido) {
        await OrdenService.crearAdicion(
          ordenId: widget.ordenId,
          productos: [
            {
              'producto': producto.id,
              'cantidad': _cantidad,
              'notas': notas,
            },
          ],
        );
      } else {
        throw Exception(
          'El pedido ya no permite agregar productos.',
        );
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _guardando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo agregar el producto: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const cremaClaro = Color(0xFFFFF8F0);
    const textoCafe = Color(0xFF3D2314);
    const cafeMedio = Color(0xFF6F4E37);
    const caramelo = Color(0xFFC87D32);

    return AlertDialog(
      backgroundColor: cremaClaro,
      title: const Text(
        'Agregar producto',
        style: TextStyle(
          color: textoCafe,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder<List<ProductModel>>(
          future: _productosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Text(
                  'No se pudieron cargar los productos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textoCafe,
                  ),
                ),
              );
            }

            final productos = (snapshot.data ?? [])
                .where(
                  (producto) => producto.disponible,
                )
                .toList();

            if (productos.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Text(
                  'No hay productos disponibles.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textoCafe,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<ProductModel>(
                    initialValue: _productoSeleccionado,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Producto',
                      prefixIcon: Icon(
                        Icons.shopping_bag_outlined,
                      ),
                    ),
                    items: productos.map(
                      (producto) {
                        return DropdownMenuItem<
                            ProductModel>(
                          value: producto,
                          child: Text(
                            '${producto.nombre} - \$${producto.precio.toStringAsFixed(0)}',
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: _guardando
                        ? null
                        : (producto) {
                            setState(() {
                              _productoSeleccionado =
                                  producto;
                            });
                          },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'Cantidad',
                        style: TextStyle(
                          color: textoCafe,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed:
                            _guardando || _cantidad <= 1
                                ? null
                                : () {
                                    setState(() {
                                      _cantidad--;
                                    });
                                  },
                        icon: const Icon(
                          Icons.remove_circle_outline,
                        ),
                        color: cafeMedio,
                      ),
                      Text(
                        '$_cantidad',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textoCafe,
                        ),
                      ),
                      IconButton(
                        onPressed: _guardando
                            ? null
                            : () {
                                setState(() {
                                  _cantidad++;
                                });
                              },
                        icon: const Icon(
                          Icons.add_circle_outline,
                        ),
                        color: caramelo,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notasController,
                    maxLines: 2,
                    enabled: !_guardando,
                    decoration: const InputDecoration(
                      labelText: 'Notas',
                      hintText: 'Ej: sin crema',
                      prefixIcon: Icon(
                        Icons.note_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: const Text(
            'Cancelar',
            style: TextStyle(
              color: cafeMedio,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _guardando ? null : _guardar,
          style: ElevatedButton.styleFrom(
            backgroundColor: caramelo,
            foregroundColor: Colors.white,
          ),
          child: _guardando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Agregar'),
        ),
      ],
    );
  }
}