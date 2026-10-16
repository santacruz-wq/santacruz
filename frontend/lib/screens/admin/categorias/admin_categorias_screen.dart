
import 'package:flutter/material.dart';

import '../../../models/categoria_model.dart';
import '../../../services/categoria_service.dart';
import 'widgets/tarjeta_contador.dart';
import 'widgets/lista_categorias.dart';
import 'widgets/formulario_categoria_dialog.dart';

class AdminCategoriasScreen extends StatefulWidget {
  const AdminCategoriasScreen({super.key});

  @override
  State<AdminCategoriasScreen> createState() =>
      _AdminCategoriasScreenState();
}

class _AdminCategoriasScreenState extends State<AdminCategoriasScreen> {
  List<Categoria> _categorias = [];
  bool _cargando = true;
  bool _mostrarInactivas = false;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    if (mounted) setState(() => _cargando = true);

    try {
      final categorias = await CategoriaService.getCategorias();
      if (!mounted) return;

      setState(() {
        _categorias = categorias;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargando = false);
      _mostrarMensaje('Error al cargar categorías: $e');
    }
  }

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _abrirFormulario({Categoria? categoria}) async {
    final resultado = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => FormularioCategoriaDialog(
        categoria: categoria,
      ),
    );

    if (resultado == true && mounted) {
      await _cargarCategorias();
      if (!mounted) return;

      _mostrarMensaje(
        categoria == null
            ? 'Categoría creada correctamente'
            : 'Categoría actualizada correctamente',
      );
    }
  }

  Future<void> _cambiarEstadoCategoria(
    Categoria categoria, {
    required bool activar,
  }) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          activar ? 'Reactivar categoría' : 'Desactivar categoría',
        ),
        content: Text(
          activar
              ? '¿Deseas volver a activar "${categoria.nombre}"?'
              : '¿Deseas desactivar "${categoria.nombre}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(activar ? 'Reactivar' : 'Desactivar'),
          ),
        ],
      ),
    );

    if (confirmado != true || !mounted) return;

    try {
      await CategoriaService.cambiarEstadoCategoria(
        categoria.id,
        activar,
      );

      if (!mounted) return;
      await _cargarCategorias();
      if (!mounted) return;

      _mostrarMensaje(
        activar
            ? 'Categoría reactivada correctamente'
            : 'Categoría desactivada correctamente',
      );
    } catch (e) {
      _mostrarMensaje('No se pudo cambiar el estado: $e');
    }
  }

  List<Categoria> get _categoriasFiltradas {
    return _categorias
        .where((categoria) => categoria.activo != _mostrarInactivas)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    const colorCafe = Color(0xFF3D2314);
    const colorCaramelo = Color(0xFFC87D32);
    const colorCrema = Color(0xFFFAF0E6);

    final activas = _categorias.where((c) => c.activo).length;
    final inactivas = _categorias.where((c) => !c.activo).length;

    return Scaffold(
      backgroundColor: colorCrema,
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: colorCafe,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _cargarCategorias,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        backgroundColor: colorCaramelo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Crear categoría'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TarjetaContador(
                    titulo: 'Activas',
                    cantidad: activas,
                    icono: Icons.check_circle_outline,
                    seleccionada: !_mostrarInactivas,
                    onTap: () {
                      setState(() => _mostrarInactivas = false);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TarjetaContador(
                    titulo: 'Inactivas',
                    cantidad: inactivas,
                    icono: Icons.pause_circle_outline,
                    seleccionada: _mostrarInactivas,
                    onTap: () {
                      setState(() => _mostrarInactivas = true);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListaCategorias(
              cargando: _cargando,
              categorias: _categoriasFiltradas,
              mostrarInactivas: _mostrarInactivas,
              onRefresh: _cargarCategorias,
              onEditar: (categoria) {
                _abrirFormulario(categoria: categoria);
              },
              onCambiarEstado: _cambiarEstadoCategoria,
            ),
          ),
        ],
      ),
    );
  }
}
