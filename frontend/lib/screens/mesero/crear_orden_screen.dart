import 'package:flutter/material.dart';

import '../../models/mesa_model.dart';
import '../../models/producto_model.dart';
import '../../services/producto_service.dart';
import '../../services/orden_service.dart';
import '../../widgets/mesero/producto_card.dart';

class CrearOrdenScreen extends StatefulWidget {
  final MesaModel mesa;

  const CrearOrdenScreen({
    super.key,
    required this.mesa,
  });

  @override
  State<CrearOrdenScreen> createState() =>
      _CrearOrdenScreenState();
}

class _CrearOrdenScreenState
    extends State<CrearOrdenScreen> {
  late Future<List<ProductoModel>> _productosFuture;

  // PRODUCTOS SELECCIONADOS
  final Map<String, int> _cantidades = {};

  bool _creandoOrden = false;

  @override
  void initState() {
    super.initState();

    _productosFuture =
        ProductoService.getProductos();
  }

  // AGREGAR PRODUCTO
  void _agregarProducto(ProductoModel producto) {
    setState(() {
      _cantidades[producto.id] =
          (_cantidades[producto.id] ?? 0) + 1;
    });
  }

  // QUITAR PRODUCTO
  void _quitarProducto(ProductoModel producto) {
    final cantidad =
        _cantidades[producto.id] ?? 0;

    if (cantidad <= 1) {
      setState(() {
        _cantidades.remove(producto.id);
      });
    } else {
      setState(() {
        _cantidades[producto.id] =
            cantidad - 1;
      });
    }
  }

  // CANTIDAD TOTAL DE PRODUCTOS
  int get _cantidadProductos {
    return _cantidades.values.fold(
      0,
      (total, cantidad) => total + cantidad,
    );
  }

  // ENVIAR ORDEN
  Future<void> _crearOrden(
    List<ProductoModel> productos,
  ) async {
    if (_creandoOrden) return;

    if (_cantidades.isEmpty) {
      _mostrarMensaje(
        'Selecciona al menos un producto.',
      );
      return;
    }

    setState(() {
      _creandoOrden = true;
    });

    try {
      final productosOrden = <Map<String, dynamic>>[];

      for (final producto in productos) {
        final cantidad =
            _cantidades[producto.id] ?? 0;

        if (cantidad > 0) {
          productosOrden.add({
            "producto": producto.id,
            "cantidad": cantidad,
          });
        }
      }

      final orden =
          await OrdenService.crearOrden(
        mesaId: widget.mesa.id,
        productos: productosOrden,
      );

      if (!mounted) return;

      _mostrarMensaje(
        'Orden creada correctamente.',
      );

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      Navigator.pop(context, orden);
    } catch (e) {
      if (!mounted) return;

      _mostrarMensaje(
        e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _creandoOrden = false;
        });
      }
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orden - ${widget.mesa.nombre}',
        ),
      ),

      body: FutureBuilder<List<ProductoModel>>(
        future: _productosFuture,
        builder: (
          context,
          snapshot,
        ) {
          // CARGANDO
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          // ERROR
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Text(
                    'No se pudieron cargar los productos',
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _productosFuture =
                            ProductoService
                                .getProductos();
                      });
                    },
                    child: const Text(
                      'Reintentar',
                    ),
                  ),
                ],
              ),
            );
          }

          final productos =
              snapshot.data ?? [];

          // SIN PRODUCTOS
          if (productos.isEmpty) {
            return const Center(
              child: Text(
                'No hay productos disponibles',
              ),
            );
          }

          return Column(
            children: [
              // INFORMACIÓN DE LA MESA
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(16),
                child: Text(
                  'Mesa: ${widget.mesa.nombre}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              // LISTA DE PRODUCTOS
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount:
                      productos.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    final producto =
                        productos[index];

                    final cantidad =
                        _cantidades[
                                producto.id] ??
                            0;

                    return Column(
                      children: [
                        ProductoCard(
                          producto:
                              producto,
                          onAgregar: () =>
                              _agregarProducto(
                            producto,
                          ),
                        ),

                        if (cantidad > 0)
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .end,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    _quitarProducto(
                                  producto,
                                ),
                                icon: const Icon(
                                  Icons
                                      .remove_circle_outline,
                                ),
                              ),
                              Text(
                                '$cantidad',
                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _agregarProducto(
                                  producto,
                                ),
                                icon: const Icon(
                                  Icons
                                      .add_circle_outline,
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      // BOTÓN CREAR ORDEN
      bottomNavigationBar:
          SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _creandoOrden
                  ? null
                  : () async {
                      final productos =
                          await _productosFuture;

                      if (!mounted) return;

                      await _crearOrden(
                        productos,
                      );
                    },
              child: _creandoOrden
                  ? const CircularProgressIndicator()
                  : Text(
                      'Crear orden ($_cantidadProductos)',
                    ),
            ),
          ),
        ),
      ),
    );
  }
}