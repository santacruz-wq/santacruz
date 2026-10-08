import 'package:flutter/material.dart';

import '../../models/mesa_model.dart';
import '../../models/producto_model.dart';
import '../../services/producto_service.dart';
import '../../services/orden_service.dart';
import 'helpers/orden_helpers.dart';
import 'widgets/crear_orden_boton.dart';
import 'widgets/nota_dialog.dart';
import 'widgets/productos_orden_body.dart';

class CrearOrdenScreen extends StatefulWidget {
  final MesaModel mesa;

  const CrearOrdenScreen({
    super.key,
    required this.mesa,
  });

  @override
  State<CrearOrdenScreen> createState() => _CrearOrdenScreenState();
}

class _CrearOrdenScreenState extends State<CrearOrdenScreen> {
  late Future<List<ProductoModel>> _productosFuture;

  // PRODUCTOS SELECCIONADOS
  final Map<String, int> _cantidades = {};

  // NOTAS DE LOS PRODUCTOS
  final Map<String, String> _notas = {};

  bool _creandoOrden = false;

  @override
  void initState() {
    super.initState();

    _productosFuture = ProductoService.getProductos();
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
    final cantidad = _cantidades[producto.id] ?? 0;

    if (cantidad <= 1) {
      setState(() {
        _cantidades.remove(producto.id);
        _notas.remove(producto.id);
      });
    } else {
      setState(() {
        _cantidades[producto.id] = cantidad - 1;
      });
    }
  }

  // AGREGAR O EDITAR NOTA
  Future<void> _editarNota(
    ProductoModel producto,
  ) async {
    final nota = await mostrarNotaDialog(
      context,
      producto,
      _notas[producto.id] ?? '',
    );

    if (!mounted || nota == null) {
      return;
    }

    setState(() {
      if (nota.trim().isEmpty) {
        _notas.remove(producto.id);
      } else {
        _notas[producto.id] = nota.trim();
      }
    });
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
      mostrarMensaje(context, 'Selecciona al menos un producto.');
      return;
    }

    setState(() {
      _creandoOrden = true;
    });

    try {
      final productosOrden = construirProductosOrden(
        productos,
        _cantidades,
        _notas,
      );

      final orden = await OrdenService.crearOrden(
        mesaId: widget.mesa.id,
        productos: productosOrden,
      );

      if (!mounted) return;

      mostrarMensaje(context, 'Orden creada correctamente.');

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      Navigator.pop(context, orden);
    } catch (e) {
      if (!mounted) return;

      mostrarMensaje(
        context,
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          _creandoOrden = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orden - ${widget.mesa.nombre}',
        ),
      ),
      body: ProductosOrdenBody(
        productosFuture: _productosFuture,
        mesa: widget.mesa,
        cantidades: _cantidades,
        notas: _notas,
        onAgregar: _agregarProducto,
        onQuitar: _quitarProducto,
        onEditarNota: _editarNota,
        onReintentar: () {
          setState(() {
            _productosFuture =
                ProductoService.getProductos();
          });
        },
      ),

      // BOTÓN CREAR ORDEN
      bottomNavigationBar: CrearOrdenBoton(
        creandoOrden: _creandoOrden,
        cantidadProductos: _cantidadProductos,
        onPressed: _creandoOrden
            ? null
            : () async {
                final productos = await _productosFuture;

                if (!mounted) return;

                await _crearOrden(
                  productos,
                );
              },
      ),
    );
  }
}