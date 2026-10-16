import 'package:flutter/material.dart';

import '../../models/producto_model.dart';
import '../../services/producto_service.dart';
import 'agregar_producto/productos_sheet_lista.dart';
import 'agregar_producto/seleccion_helper.dart';
import 'agregar_producto/sheet_header.dart';

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

    _productosFuture = ProductoService.getProductos();
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
    final cantidad = _cantidades[producto.id] ?? 0;

    if (cantidad <= 1) {
      setState(() {
        _cantidades.remove(producto.id);

        _notas[producto.id]?.clear();
      });
    } else {
      setState(() {
        _cantidades[producto.id] = cantidad - 1;
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

    widget.onAgregar(
      construirSeleccion(
        productos,
        _cantidades,
        _notas,
      ),
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
            const SheetHeader(),

            Expanded(
              child: ProductosSheetLista(
                productosFuture: _productosFuture,
                cantidades: _cantidades,
                notas: _notas,
                onAumentar: _aumentar,
                onDisminuir: _disminuir,
                onReintentar: () {
                  setState(() {
                    _productosFuture =
                        ProductoService.getProductos();
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final productos = await _productosFuture;

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