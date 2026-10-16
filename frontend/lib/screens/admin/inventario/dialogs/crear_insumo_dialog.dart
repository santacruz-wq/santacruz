
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../services/inventario_service.dart';
import '../widgets/campo_cantidad.dart';

class CrearInsumoDialog extends StatefulWidget {
  const CrearInsumoDialog({super.key});

  @override
  State<CrearInsumoDialog> createState() => _CrearInsumoDialogState();
}

class _CrearInsumoDialogState extends State<CrearInsumoDialog> {
  final _form = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _disponible = TextEditingController(text: '0');
  final _minimo = TextEditingController(text: '0');
  final _maximo = TextEditingController(text: '100');

  String _unidad = 'kg';
  bool _guardando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _disponible.dispose();
    _minimo.dispose();
    _maximo.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;

    final disponible = CampoCantidad.leer(_disponible.text)!;
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
      await InventarioService.crearInsumo(
        nombreInsumo: _nombre.text.trim(),
        unidadMedida: _unidad,
        cantidadDisponible: disponible,
        cantidadMinima: minimo,
        cantidadMaxima: maximo,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo guardar: $e')),
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
      title: const Text('Agregar insumo'),
      content: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombre,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nombre del insumo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Escribe el nombre'
                    : v.trim().length > 100
                        ? 'Nombre demasiado largo'
                        : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _unidad,
                decoration: const InputDecoration(
                  labelText: 'Unidad de medida',
                  border: OutlineInputBorder(),
                ),
                items: const ['kg', 'g', 'litro', 'ml', 'unidad']
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: _guardando
                    ? null
                    : (v) => setState(() => _unidad = v ?? _unidad),
              ),
              const SizedBox(height: 12),
              CampoCantidad(
                controller: _disponible,
                etiqueta: 'Cantidad inicial',
              ),
              const SizedBox(height: 12),
              CampoCantidad(
                controller: _minimo,
                etiqueta: 'Stock mínimo',
              ),
              const SizedBox(height: 12),
              CampoCantidad(
                controller: _maximo,
                etiqueta: 'Stock máximo',
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
