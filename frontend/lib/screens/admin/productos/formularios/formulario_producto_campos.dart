import 'package:flutter/material.dart';

import '../../../../models/categoria_model.dart';
import 'formulario_producto_validaciones.dart';

class FormularioProductoCampos extends StatelessWidget {
  final List<Categoria> categorias;
  final String? categoriaId;
  final bool editando;
  final bool guardando;
  final String? error;
  final TextEditingController codigoController;
  final TextEditingController nombreController;
  final TextEditingController descripcionController;
  final TextEditingController precioController;
  final ValueChanged<String?> onCambiarCategoria;

  const FormularioProductoCampos({
    super.key,
    required this.categorias,
    required this.categoriaId,
    required this.editando,
    required this.guardando,
    required this.error,
    required this.codigoController,
    required this.nombreController,
    required this.descripcionController,
    required this.precioController,
    required this.onCambiarCategoria,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!editando) ...[
          TextFormField(
            controller: codigoController,
            decoration: const InputDecoration(
              labelText: 'Código del producto (opcional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
        ],
        TextFormField(
          controller: nombreController,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(),
          ),
          validator: FormularioProductoValidaciones.nombre,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: descripcionController,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Descripción',
            border: OutlineInputBorder(),
          ),
          validator: FormularioProductoValidaciones.descripcion,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: precioController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: const InputDecoration(
            labelText: 'Precio',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
          ),
          validator: FormularioProductoValidaciones.precio,
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: categoriaId,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Categoría',
            border: OutlineInputBorder(),
          ),
          items: categorias.map((categoria) {
            return DropdownMenuItem<String>(
              value: categoria.id,
              child: Text(
                categoria.nombre,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: guardando ? null : onCambiarCategoria,
          validator: FormularioProductoValidaciones.categoria,
        ),
        if (categorias.isEmpty) ...[
          const SizedBox(height: 8),
          const Text(
            'No hay categorías activas disponibles.',
            style: TextStyle(color: Colors.red),
          ),
        ],
        if (error != null) ...[
          const SizedBox(height: 14),
          Text(
            error!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}