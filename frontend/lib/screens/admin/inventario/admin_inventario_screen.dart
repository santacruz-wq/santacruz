
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

  // ==========================================
  // CREAR INSUMO
  // ==========================================

  Future<void> _crear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => const CrearInsumoDialog(),
    );

    if (ok == true && mounted) {
      await _recargar();
    }
  }

  // ==========================================
  // REGISTRAR MOVIMIENTO
  // ==========================================

  Future<void> _movimiento() async {
    try {
      final lista = await _future;

      if (!mounted) return;

      if (lista.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Primero agrega un insumo al inventario.',
            ),
          ),
        );
        return;
      }

      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => MovimientoDialog(inventario: lista),
      );

      if (ok == true && mounted) {
        await _recargar();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar inventario: $e'),
        ),
      );
    }
  }

  // ==========================================
  // VER HISTORIAL
  // ==========================================

  Future<void> _historial(InventarioModel item) async {
    await showDialog<void>(
      context: context,
      builder: (_) => HistorialMovimientosDialog(item: item),
    );
  }

  // ==========================================
  // EDITAR LÍMITES
  // ==========================================

  Future<void> _editar(InventarioModel item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => EditarLimitesDialog(item: item),
    );

    if (ok == true && mounted) {
      await _recargar();
    }
  }

  // ==========================================
  // EDITAR NOMBRE Y UNIDAD DE MEDIDA
  // ==========================================

  Future<void> _editarInsumo(InventarioModel item) async {
    final nombreController = TextEditingController(
      text: item.nombreInsumo,
    );

    final unidadController = TextEditingController(
      text: item.unidadMedida,
    );

    try {
      final ok = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          bool guardando = false;

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: AppColors.cremaClaro,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                title: const Text(
                  'Editar insumo',
                  style: TextStyle(
                    color: AppColors.textoCafe,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nombreController,
                        textCapitalization:
                            TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del insumo',
                          hintText: 'Ej. Harina',
                          prefixIcon: Icon(
                            Icons.kitchen_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: unidadController,
                        textCapitalization:
                            TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Unidad de medida',
                          hintText: 'Ej. kg, litros, unidades',
                          prefixIcon: Icon(
                            Icons.straighten,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Las cantidades disponibles, los límites '
                        'y el historial se conservarán.',
                        style: TextStyle(
                          color: AppColors.cafeMedio,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: guardando
                        ? null
                        : () => Navigator.of(dialogContext).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.caramelo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: guardando
                        ? null
                        : () async {
                            final nombre =
                                nombreController.text.trim();
                            final unidad =
                                unidadController.text.trim();

                            if (nombre.isEmpty || unidad.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Completa el nombre y la unidad '
                                    'de medida.',
                                  ),
                                ),
                              );
                              return;
                            }

                            setDialogState(() {
                              guardando = true;
                            });

                            try {
                              await InventarioService.actualizarInsumo(
                                inventarioId: item.id,
                                nombreInsumo: nombre,
                                unidadMedida: unidad,
                              );

                              if (dialogContext.mounted) {
                                Navigator.of(dialogContext).pop(true);
                              }
                            } catch (e) {
                              if (!dialogContext.mounted) return;

                              setDialogState(() {
                                guardando = false;
                              });

                              ScaffoldMessenger.of(dialogContext)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().replaceFirst(
                                          'Exception: ',
                                          '',
                                        ),
                                  ),
                                ),
                              );
                            }
                          },
                    child: guardando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Guardar'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (ok == true && mounted) {
        await _recargar();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Insumo actualizado correctamente.'),
          ),
        );
      }
    } finally {
      nombreController.dispose();
      unidadController.dispose();
    }
  }

  // ==========================================
  // ELIMINAR INSUMO
  // ==========================================

  Future<void> _eliminarInsumo(InventarioModel item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.cremaClaro,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Eliminar insumo',
            style: TextStyle(
              color: AppColors.textoCafe,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar '
            '"${item.nombreMostrar}"?\n\n'
            'Esta acción no se puede deshacer. '
            'Si tiene movimientos registrados, no se permitirá '
            'eliminarlo para conservar el historial.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) return;

    try {
      await InventarioService.eliminarInsumo(
        inventarioId: item.id,
      );

      if (!mounted) return;

      await _recargar();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insumo eliminado correctamente.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    }
  }

  // ==========================================
  // PANTALLA PRINCIPAL
  // ==========================================

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
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
            return ErrorInventario(
              onReintentar: _recargar,
            );
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
                  Center(
                    child: Text(
                      'No hay registros en el inventario',
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Pulsa + para agregar un insumo.',
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _recargar,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                100,
              ),
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
                  onEditarInsumo: item.esInsumo
                      ? () => _editarInsumo(item)
                      : null,
                  onEliminarInsumo: item.esInsumo
                      ? () => _eliminarInsumo(item)
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
