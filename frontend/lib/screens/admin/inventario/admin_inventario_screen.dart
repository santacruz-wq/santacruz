
import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../../../models/inventario_model.dart';
import '../../../services/inventario_service.dart';
import 'dialogs/crear_insumo_dialog.dart';
import 'dialogs/editar_limites_dialog.dart';
import 'dialogs/historial_movimientos_dialog.dart';
import 'dialogs/movimiento_dialog.dart';
import 'widgets/error_inventario.dart';
import 'widgets/inventario_card.dart';

class AdminInventarioScreen extends StatefulWidget {
  const AdminInventarioScreen({super.key});

  @override
  State<AdminInventarioScreen> createState() =>
      _AdminInventarioScreenState();
}

class _AdminInventarioScreenState
    extends State<AdminInventarioScreen> {
  late Future<List<InventarioModel>> _future;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _future = InventarioService.getInventario();
  }

  Future<void> _recargar() async {
    setState(_cargar);
    try {
      await _future;
    } catch (_) {}
  }

  Color _color(InventarioModel item) {
    if (item.stockAgotado) return Colors.red;
    if (item.stockBajo) return AppColors.caramelo;
    return Colors.green;
  }

  String _estado(InventarioModel item) {
    if (item.stockAgotado) return 'Agotado';
    if (item.stockBajo) return 'Stock bajo';
    return 'Disponible';
  }

  IconData _icono(InventarioModel item) {
    if (item.stockAgotado) return Icons.error_outline;
    if (item.stockBajo) return Icons.warning_amber_rounded;
    return Icons.check_circle_outline;
  }

  Future<void> _crear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => const CrearInsumoDialog(),
    );
    if (ok == true && mounted) await _recargar();
  }

  Future<void> _movimiento() async {
    try {
      final lista = await _future;
      if (!mounted) return;

      if (lista.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Primero agrega un insumo al inventario.'),
          ),
        );
        return;
      }

      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => MovimientoDialog(inventario: lista),
      );
      if (ok == true && mounted) await _recargar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar inventario: $e')),
      );
    }
  }

  Future<void> _historial(InventarioModel item) async {
    await showDialog<void>(
      context: context,
      builder: (_) => HistorialMovimientosDialog(item: item),
    );
  }

  Future<void> _editar(InventarioModel item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => EditarLimitesDialog(item: item),
    );
    if (ok == true && mounted) await _recargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cremaClaro,
      appBar: AppBar(
        backgroundColor: AppColors.cremaClaro,
        foregroundColor: AppColors.textoCafe,
        elevation: 0,
        title: const Text(
          'Stock',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _crear,
            icon: const Icon(Icons.add_box_outlined),
            tooltip: 'Agregar insumo',
          ),
          IconButton(
            onPressed: _recargar,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _movimiento,
        backgroundColor: AppColors.caramelo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.swap_vert),
        label: const Text('Registrar movimiento'),
      ),
      body: FutureBuilder<List<InventarioModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.caramelo,
              ),
            );
          }

          if (snapshot.hasError) {
            return ErrorInventario(onReintentar: _recargar);
          }

          final lista = snapshot.data ?? [];
          if (lista.isEmpty) {
            return RefreshIndicator(
              onRefresh: _recargar,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 100),
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 65,
                    color: AppColors.cafeMedio,
                  ),
                  SizedBox(height: 16),
                  Center(child: Text('No hay registros en el inventario')),
                  SizedBox(height: 10),
                  Center(child: Text('Pulsa + para agregar un insumo.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _recargar,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: lista.length,
              itemBuilder: (_, index) {
                final item = lista[index];
                return InventarioCard(
                  item: item,
                  colorEstado: _color(item),
                  textoEstado: _estado(item),
                  iconoEstado: _icono(item),
                  onVerHistorial: () => _historial(item),
                  onEditarLimites: () => _editar(item),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
