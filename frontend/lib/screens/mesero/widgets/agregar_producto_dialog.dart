import 'package:flutter/material.dart';

import '../../../models/product_model.dart';
import '../../../services/product_service.dart';
import '../helpers/detalle_colores.dart';
import '../helpers/detalle_guardar_producto.dart';
import 'agregar_producto_form.dart';
import 'dialog_mensaje.dart';

class AgregarProductoDialog extends StatefulWidget {
  final String ordenId;

  const AgregarProductoDialog({
    super.key,
    required this.ordenId,
  });

  @override
  State<AgregarProductoDialog> createState() =>
      _AgregarProductoDialogState();
}

class _AgregarProductoDialogState
    extends State<AgregarProductoDialog> {
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
      await guardarProductoEnOrden(
        ordenId: widget.ordenId,
        producto: producto,
        cantidad: _cantidad,
        notasTexto: _notasController.text,
      );

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
    const cremaClaro = DetalleColores.cremaClaro;
    const textoCafe = DetalleColores.textoCafe;
    const cafeMedio = DetalleColores.cafeMedio;
    const caramelo = DetalleColores.caramelo;

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
              return const DialogMensaje(
                texto: 'No se pudieron cargar los productos.',
              );
            }

            final productos = (snapshot.data ?? [])
                .where(
                  (producto) => producto.disponible,
                )
                .toList();

            if (productos.isEmpty) {
              return const DialogMensaje(
                texto: 'No hay productos disponibles.',
              );
            }

            return AgregarProductoForm(
              productos: productos,
              productoSeleccionado: _productoSeleccionado,
              cantidad: _cantidad,
              guardando: _guardando,
              notasController: _notasController,
              onSeleccionar: (producto) {
                setState(() {
                  _productoSeleccionado = producto;
                });
              },
              onAumentar: () => setState(() => _cantidad++),
              onDisminuir: () => setState(() => _cantidad--),
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