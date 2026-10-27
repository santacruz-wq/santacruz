
import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../../../models/product_model.dart';
import '../../../services/admin_producto_service.dart';
import 'formularios/formulario_producto_screen.dart';
import 'widgets/productos_contenido.dart';

class AdminProductosScreen extends StatefulWidget {
  const AdminProductosScreen({super.key});

  @override
  State<AdminProductosScreen> createState() =>
      _AdminProductosScreenState();
}

class _AdminProductosScreenState extends State<AdminProductosScreen> {
  List<ProductModel> _productos = [];
  bool _cargando = true;
  String? _error;
  String _busqueda = '';

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    if (mounted) {
      setState(() {
        _cargando = true;
        _error = null;
      });
    }
    try {
      final productos = await AdminProductoService.obtenerProductos();
      if (!mounted) return;
      setState(() => _productos = productos);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _abrirFormulario([ProductModel? producto]) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormularioProductoScreen(producto: producto),
      ),
    );
    if (resultado == true && mounted) await _cargarProductos();
  }

  Future<void> _cambiarEstadoMenu(ProductModel producto) async {
    final estadoActual = !producto.visibleMenu
        ? 'oculto'
        : producto.disponible
            ? 'disponible'
            : 'agotado';

    final estadoSeleccionado = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text('Estado de ${producto.nombre}'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'disponible'),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 10),
                const Text('Disponible'),
                if (estadoActual == 'disponible') ...[
                  const Spacer(),
                  const Icon(Icons.check, size: 18),
                ],
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'agotado'),
            child: Row(
              children: [
                const Icon(Icons.remove_circle, color: Colors.orange),
                const SizedBox(width: 10),
                const Text('Agotado'),
                if (estadoActual == 'agotado') ...[
                  const Spacer(),
                  const Icon(Icons.check, size: 18),
                ],
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'oculto'),
            child: Row(
              children: [
                const Icon(Icons.visibility_off, color: Colors.grey),
                const SizedBox(width: 10),
                const Text('Oculto'),
                if (estadoActual == 'oculto') ...[
                  const Spacer(),
                  const Icon(Icons.check, size: 18),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (estadoSeleccionado == null ||
        estadoSeleccionado == estadoActual ||
        !mounted) {
      return;
    }

    try {
      await AdminProductoService.cambiarEstadoMenu(
        id: producto.id,
        estado: estadoSeleccionado,
      );

      if (!mounted) return;

      final nombreEstado = switch (estadoSeleccionado) {
        'disponible' => 'Disponible',
        'agotado' => 'Agotado',
        'oculto' => 'Oculto',
        _ => estadoSeleccionado,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Producto actualizado: $nombreEstado'),
        ),
      );

      await _cargarProductos();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final consulta = _busqueda.trim().toLowerCase();
    final filtrados = _productos.where((p) {
      return p.nombre.toLowerCase().contains(consulta) ||
          p.productId.toLowerCase().contains(consulta);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: AppColors.cremaClaro,
        foregroundColor: AppColors.textoCafe,
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _cargando ? null : _cargarProductos,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        backgroundColor: AppColors.caramelo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo producto'),
      ),
      body: RefreshIndicator(
        color: AppColors.caramelo,
        onRefresh: _cargarProductos,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            TextField(
              onChanged: (valor) => setState(() => _busqueda = valor),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o código',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.cremaClaro,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ProductosContenido(
              cargando: _cargando,
              error: _error,
              productos: filtrados,
              onActualizar: _cargarProductos,
              onEditar: _abrirFormulario,
              onCambiarDisponibilidad: _cambiarEstadoMenu,
            ),
          ],
        ),
      ),
    );
  }
}
