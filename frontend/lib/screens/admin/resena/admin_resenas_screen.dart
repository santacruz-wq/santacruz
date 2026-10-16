
import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../../../services/resena_service.dart';
import 'utils/resena_formatters.dart';
import 'widgets/resenas_contenido.dart';

class AdminResenasScreen extends StatefulWidget {
  const AdminResenasScreen({super.key});

  @override
  State<AdminResenasScreen> createState() =>
      _AdminResenasScreenState();
}

class _AdminResenasScreenState extends State<AdminResenasScreen> {
  List<Map<String, dynamic>> _resenas = [];
  bool _cargando = true;
  String? _error;
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    _cargarResenas();
  }

  Future<void> _cargarResenas() async {
    if (!mounted) return;

    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final resenas = await ResenaService.listarResenas();

      if (!mounted) return;

      setState(() {
        _resenas = resenas;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _cargando = false;
      });
    }
  }

  Future<void> _confirmarEliminar(
    Map<String, dynamic> resena,
  ) async {
    final id = resena['_id']?.toString();

    if (id == null || id.isEmpty) {
      _mostrarMensaje(
        'No se encontró el identificador de la reseña.',
      );
      return;
    }

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cremaClaro,
        title: const Text(
          'Eliminar reseña',
          style: TextStyle(color: AppColors.textoCafe),
        ),
        content: const Text(
          '¿Seguro que deseas eliminar esta reseña? '
          'Esta acción no se puede deshacer.',
          style: TextStyle(color: AppColors.textoCafe),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmado != true || !mounted) return;

    try {
      await ResenaService.eliminarResena(id);

      if (!mounted) return;

      setState(() {
        _resenas.removeWhere(
          (r) => r['_id']?.toString() == id,
        );
      });

      _mostrarMensaje('Reseña eliminada correctamente.');
    } catch (e) {
      if (!mounted) return;

      _mostrarMensaje(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
  }

  List<Map<String, dynamic>> get _resenasFiltradas {
    final busqueda = _filtro.toLowerCase();

    return _resenas.where((resena) {
      final usuario = ResenaFormatters.nombreRelacionado(
        resena['usuario'],
      );

      final producto = ResenaFormatters.nombreRelacionado(
        resena['producto'],
      );

      final comentario = ResenaFormatters.texto(
        resena['comentario'],
      );

      return usuario.toLowerCase().contains(busqueda) ||
          producto.toLowerCase().contains(busqueda) ||
          comentario.toLowerCase().contains(busqueda);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        title: const Text('Reseñas'),
        backgroundColor: AppColors.cremaClaro,
        foregroundColor: AppColors.textoCafe,
        actions: [
          IconButton(
            tooltip: 'Actualizar reseñas',
            onPressed: _cargando ? null : _cargarResenas,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (valor) {
                setState(() {
                  _filtro = valor.trim();
                });
              },
              decoration: InputDecoration(
                hintText:
                    'Buscar por producto, usuario o comentario',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.cremaClaro,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ResenasContenido(
              cargando: _cargando,
              error: _error,
              filtro: _filtro,
              resenas: _resenasFiltradas,
              onActualizar: _cargarResenas,
              onEliminar: _confirmarEliminar,
            ),
          ),
        ],
      ),
    );
  }
}
