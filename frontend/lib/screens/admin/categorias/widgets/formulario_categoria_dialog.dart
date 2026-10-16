
import 'package:flutter/material.dart';

import '../../../../models/categoria_model.dart';
import '../../../../services/categoria_service.dart';

class FormularioCategoriaDialog extends StatefulWidget {
  final Categoria? categoria;

  const FormularioCategoriaDialog({
    super.key,
    this.categoria,
  });

  @override
  State<FormularioCategoriaDialog> createState() =>
      _FormularioCategoriaDialogState();
}

class _FormularioCategoriaDialogState
    extends State<FormularioCategoriaDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _imagenController;

  bool _guardando = false;

  bool get _editando => widget.categoria != null;

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController(
      text: widget.categoria?.nombre ?? '',
    );
    _descripcionController = TextEditingController(
      text: widget.categoria?.descripcion ?? '',
    );
    _imagenController = TextEditingController(
      text: widget.categoria?.imagen ?? 'assets/img/categoria.avif',
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _imagenController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      if (_editando) {
        await CategoriaService.actualizarCategoria(
          id: widget.categoria!.id,
          nombre: _nombreController.text.trim(),
          descripcion: _descripcionController.text.trim(),
          imagen: _imagenController.text.trim(),
        );
      } else {
        await CategoriaService.crearCategoria(
          nombre: _nombreController.text.trim(),
          descripcion: _descripcionController.text.trim(),
          imagen: _imagenController.text.trim().isEmpty
              ? 'assets/img/categoria.avif'
              : _imagenController.text.trim(),
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar la categoría: $e'),
        ),
      );

      setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_editando ? 'Editar categoría' : 'Crear categoría'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el nombre de la categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _imagenController,
                decoration: const InputDecoration(
                  labelText: 'Ruta o URL de imagen',
                  prefixIcon: Icon(Icons.image_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _guardando ? null : _guardar,
          child: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_editando ? 'Guardar cambios' : 'Crear'),
        ),
      ],
    );
  }
}
