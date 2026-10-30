import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/mesa_model.dart';
import '../../../../services/mesa_service.dart';

class FormularioMesaDialog extends StatefulWidget {
  final MesaModel? mesa;

  const FormularioMesaDialog({super.key, this.mesa});

  @override
  State<FormularioMesaDialog> createState() => _FormularioMesaDialogState();
}

class _FormularioMesaDialogState extends State<FormularioMesaDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _capacidadController;

  bool _guardando = false;
  String? _error;

  bool get _esEdicion => widget.mesa != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.mesa?.nombre ?? '');
    _capacidadController = TextEditingController(
      text: widget.mesa != null ? widget.mesa!.capacidad.toString() : '',
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _capacidadController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _guardando = true;
      _error = null;
    });

    final nombre = _nombreController.text.trim();
    final capacidad = int.parse(_capacidadController.text.trim());

    try {
      if (_esEdicion) {
        await MesaService.actualizarMesa(widget.mesa!.id, nombre, capacidad);
      } else {
        await MesaService.crearMesa(nombre, capacidad);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _guardando = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cremaClaro,
      title: Text(
        _esEdicion ? 'Editar mesa' : 'Crear mesa',
        style: const TextStyle(
          color: AppColors.textoCafe,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreController,
                enabled: !_guardando,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la mesa',
                  hintText: 'Ej: Mesa 5',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el nombre de la mesa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _capacidadController,
                enabled: !_guardando,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Capacidad (personas)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final numero = int.tryParse((value ?? '').trim());
                  if (numero == null || numero <= 0) {
                    return 'Ingresa un número mayor que 0';
                  }
                  return null;
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando ? null : () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _guardando ? null : _guardar,
          style: FilledButton.styleFrom(backgroundColor: AppColors.caramelo),
          child: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(_esEdicion ? 'Guardar' : 'Crear'),
        ),
      ],
    );
  }
}