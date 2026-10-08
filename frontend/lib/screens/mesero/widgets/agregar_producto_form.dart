import 'package:flutter/material.dart';

import '../../../models/product_model.dart';
import '../helpers/detalle_colores.dart';

/// Formulario del diálogo: producto, cantidad y notas.
class AgregarProductoForm extends StatelessWidget {
  final List<ProductModel> productos;
  final ProductModel? productoSeleccionado;
  final int cantidad;
  final bool guardando;
  final TextEditingController notasController;
  final void Function(ProductModel? producto) onSeleccionar;
  final VoidCallback onAumentar;
  final VoidCallback onDisminuir;

  const AgregarProductoForm({
    super.key,
    required this.productos,
    required this.productoSeleccionado,
    required this.cantidad,
    required this.guardando,
    required this.notasController,
    required this.onSeleccionar,
    required this.onAumentar,
    required this.onDisminuir,
  });

  @override
  Widget build(BuildContext context) {
    const textoCafe = DetalleColores.textoCafe;
    const cafeMedio = DetalleColores.cafeMedio;
    const caramelo = DetalleColores.caramelo;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<ProductModel>(
            initialValue: productoSeleccionado,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Producto',
              prefixIcon: Icon(
                Icons.shopping_bag_outlined,
              ),
            ),
            items: productos.map(
              (producto) {
                return DropdownMenuItem<ProductModel>(
                  value: producto,
                  child: Text(
                    '${producto.nombre} - \$${producto.precio.toStringAsFixed(0)}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ).toList(),
            onChanged: guardando ? null : onSeleccionar,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Cantidad',
                style: TextStyle(
                  color: textoCafe,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: guardando || cantidad <= 1
                    ? null
                    : onDisminuir,
                icon: const Icon(
                  Icons.remove_circle_outline,
                ),
                color: cafeMedio,
              ),
              Text(
                '$cantidad',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textoCafe,
                ),
              ),
              IconButton(
                onPressed: guardando ? null : onAumentar,
                icon: const Icon(
                  Icons.add_circle_outline,
                ),
                color: caramelo,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: notasController,
            maxLines: 2,
            enabled: !guardando,
            decoration: const InputDecoration(
              labelText: 'Notas',
              hintText: 'Ej: sin crema',
              prefixIcon: Icon(
                Icons.note_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }
}