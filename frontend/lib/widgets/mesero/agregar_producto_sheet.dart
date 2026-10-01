import 'package:flutter/material.dart';

import '../../models/producto_model.dart';
import '../../services/producto_service.dart';

class AgregarProductoSheet extends StatefulWidget {
  final Function(
    List<Map<String, dynamic>> productos,
  ) onAgregar;

  const AgregarProductoSheet({
    super.key,
    required this.onAgregar,
  });

  @override
  State<AgregarProductoSheet> createState() =>
      _AgregarProductoSheetState();
}

class _AgregarProductoSheetState
    extends State<AgregarProductoSheet> {
  late Future<List<ProductoModel>> _productosFuture;

  final Map<String, int> _cantidades = {};

  final Map<String, TextEditingController> _notas = {};

  @override
  void initState() {
    super.initState();

    _productosFuture =
        ProductoService.getProductos();
  }

  @override
  void dispose() {
    for (final controller in _notas.values) {
      controller.dispose();
    }

    super.dispose();
  }

  void _aumentar(ProductoModel producto) {
    setState(() {
      _cantidades[producto.id] =
          (_cantidades[producto.id] ?? 0) + 1;

      _notas.putIfAbsent(
        producto.id,
        () => TextEditingController(),
      );
    });
  }

  void _disminuir(ProductoModel producto) {
    final cantidad =
        _cantidades[producto.id] ?? 0;

    if (cantidad <= 1) {
      setState(() {
        _cantidades.remove(producto.id);

        _notas[producto.id]?.clear();
      });
    } else {
      setState(() {
        _cantidades[producto.id] =
            cantidad - 1;
      });
    }
  }

  int get _cantidadTotal {
    return _cantidades.values.fold(
      0,
      (total, cantidad) => total + cantidad,
    );
  }

  void _confirmar(
    List<ProductoModel> productos,
  ) {
    if (_cantidades.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecciona al menos un producto.',
          ),
        ),
      );

      return;
    }

    final productosSeleccionados =
        <Map<String, dynamic>>[];

    for (final producto in productos) {
      final cantidad =
          _cantidades[producto.id] ?? 0;

      if (cantidad > 0) {
        final nota =
            _notas[producto.id]?.text.trim();

        final item = <String, dynamic>{
          "producto": producto.id,
          "cantidad": cantidad,
        };

        if (nota != null && nota.isNotEmpty) {
          item["notas"] = nota;
        }

        productosSeleccionados.add(item);
      }
    }

    widget.onAgregar(
      productosSeleccionados,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Agregar productos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const Divider(),

            Expanded(
              child:
                  FutureBuilder<List<ProductoModel>>(
                future: _productosFuture,
                builder: (
                  context,
                  snapshot,
                ) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

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

                  if (productos.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay productos disponibles',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: productos.length,
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

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                            10,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      10,
                                    ),
                                    child: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: producto
                                              .imagen
                                              .isNotEmpty
                                          ? Image.network(
                                              producto.imagen,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return const Icon(
                                                  Icons
                                                      .image_not_supported_outlined,
                                                );
                                              },
                                            )
                                          : const Icon(
                                              Icons
                                                  .image_outlined,
                                            ),
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 12,
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          producto
                                              .nombre,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow
                                                  .ellipsis,
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '\$${producto.precio.toStringAsFixed(0)}',
                                        ),
                                      ],
                                    ),
                                  ),

                                  IconButton(
                                    onPressed:
                                        cantidad > 0
                                            ? () =>
                                                _disminuir(
                                                  producto,
                                                )
                                            : null,
                                    icon:
                                        const Icon(
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
                                    onPressed:
                                        () =>
                                            _aumentar(
                                          producto,
                                        ),
                                    icon:
                                        const Icon(
                                      Icons
                                          .add_circle_outline,
                                    ),
                                  ),
                                ],
                              ),

                              if (cantidad > 0) ...[
                                const SizedBox(
                                  height: 10,
                                ),

                                TextField(
                                  controller:
                                      _notas[producto.id],
                                  maxLines: 2,
                                  decoration:
                                      InputDecoration(
                                    labelText:
                                        'Nota para cocina (opcional)',
                                    hintText:
                                        'Ej: Agregar una porción de coco',
                                    prefixIcon:
                                        const Icon(
                                      Icons
                                          .note_alt_outlined,
                                    ),
                                    border:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final productos =
                      await _productosFuture;

                  if (!mounted) return;

                  _confirmar(productos);
                },
                child: Text(
                  'Agregar ($_cantidadTotal)',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}