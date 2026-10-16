
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/inventario_model.dart';
import '../../../../services/inventario_service.dart';
import '../widgets/campo_cantidad.dart';

class MovimientoDialog extends StatefulWidget {
  final List<InventarioModel> inventario;

  const MovimientoDialog({
    super.key,
    required this.inventario,
  });

  @override
  State<MovimientoDialog> createState() => _MovimientoDialogState();
}

class _MovimientoDialogState extends State<MovimientoDialog> {
  final _form = GlobalKey<FormState>();
  final _cantidad = TextEditingController();
  final _motivo = TextEditingController();

  late InventarioModel _item;
  String _tipo = 'entrada';
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _item = widget.inventario.first;
  }

  @override
  void dispose() {
    _cantidad.dispose();
    _motivo.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;

    final cantidad = CampoCantidad.leer(_cantidad.text)!;
    if (_tipo == 'salida' && cantidad > _item.cantidadDisponible) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La salida supera el stock disponible.'),
        ),
      );
      return;
    }

    setState(() => _guardando = true);
    try {
      await InventarioService.registrarMovimiento(
        inventarioId: _item.id,
        tipo: _tipo,
        cantidad: cantidad,
        motivo: _motivo.text.trim().isEmpty ? null : _motivo.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo registrar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cremaClaro,
      title: const Text('Movimiento de stock'),
      content: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<InventarioModel>(
                initialValue: _item,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Producto o insumo',
                  border: OutlineInputBorder(),
                ),
                items: widget.inventario.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      '${item.nombreMostrar} (${item.cantidadConUnidad})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: _guardando
                    ? null
                    : (v) => setState(() => _item = v ?? _item),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _tipo,
                decoration: const InputDecoration(
                  labelText: 'Tipo de movimiento',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'entrada',
                    child: Text('Entrada de stock'),
                  ),
                  DropdownMenuItem(
                    value: 'salida',
                    child: Text('Salida de stock'),
                  ),
                ],
                onChanged: _guardando
                    ? null
                    : (v) => setState(() => _tipo = v ?? _tipo),
              ),
              const SizedBox(height: 12),
              CampoCantidad(
                controller: _cantidad,
                etiqueta: 'Cantidad',
                unidad: _item.unidadMedida,
                permitirCero: false,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _motivo,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Motivo (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardando ? null : _guardar,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.caramelo,
            foregroundColor: Colors.white,
          ),
          child: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
