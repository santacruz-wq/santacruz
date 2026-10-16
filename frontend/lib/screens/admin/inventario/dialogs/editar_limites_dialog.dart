
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/inventario_model.dart';
import '../../../../services/inventario_service.dart';
import '../widgets/campo_cantidad.dart';

class EditarLimitesDialog extends StatefulWidget {
  final InventarioModel item;

  const EditarLimitesDialog({
    super.key,
    required this.item,
  });

  @override
  State<EditarLimitesDialog> createState() =>
      _EditarLimitesDialogState();
}

class _EditarLimitesDialogState extends State<EditarLimitesDialog> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _minimo;
  late final TextEditingController _maximo;
  bool _guardando = false;

  String _numero(double n) =>
      n == n.roundToDouble() ? n.toInt().toString() : n.toString();

  @override
  void initState() {
    super.initState();
    _minimo = TextEditingController(
      text: _numero(widget.item.cantidadMinima),
    );
    _maximo = TextEditingController(
      text: _numero(widget.item.cantidadMaxima),
    );
  }

  @override
  void dispose() {
    _minimo.dispose();
    _maximo.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    final minimo = CampoCantidad.leer(_minimo.text)!;
    final maximo = CampoCantidad.leer(_maximo.text)!;

    if (maximo < minimo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El máximo no puede ser menor que el mínimo.'),
        ),
      );
      return;
    }

    setState(() => _guardando = true);
    try {
      await InventarioService.actualizarLimitesInventario(
        inventarioId: widget.item.id,
        cantidadMinima: minimo,
        cantidadMaxima: maximo,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudieron actualizar: $e')),
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
      title: const Text('Editar límites de stock'),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.item.nombreMostrar),
            ),
            const SizedBox(height: 12),
            CampoCantidad(
              controller: _minimo,
              etiqueta: 'Stock mínimo',
              unidad: widget.item.unidadMedida,
              habilitado: !_guardando,
            ),
            const SizedBox(height: 12),
            CampoCantidad(
              controller: _maximo,
              etiqueta: 'Stock máximo',
              unidad: widget.item.unidadMedida,
              habilitado: !_guardando,
            ),
          ],
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
