
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/product_model.dart';
import 'imagen_producto.dart';

class ProductoCard extends StatelessWidget {
  final ProductModel producto;
  final VoidCallback onEditar;
  final VoidCallback onCambiarDisponibilidad;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onEditar,
    required this.onCambiarDisponibilidad,
  });

  @override
  Widget build(BuildContext context) {
    final String estado = !producto.visibleMenu
        ? 'Oculto'
        : producto.disponible
            ? 'Disponible'
            : 'Agotado';

    final Color colorEstado = !producto.visibleMenu
        ? Colors.grey.shade700
        : producto.disponible
            ? Colors.green.shade700
            : Colors.orange.shade800;

    return Card(
      color: AppColors.cremaClaro,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ImagenProducto(
          url: producto.imagenUrl,
          tamano: 72,
        ),
        title: Text(
          producto.nombre,
          style: const TextStyle(
            color: AppColors.textoCafe,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Código: ${producto.productId}'),
              Text(
                '\$${producto.precio.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.cafeMedio,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                estado,
                style: TextStyle(
                  color: colorEstado,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (accion) {
            if (accion == 'editar') {
              onEditar();
            } else if (accion == 'estado') {
              onCambiarDisponibilidad();
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'editar',
              child: Text('Editar'),
            ),
            const PopupMenuItem(
              value: 'estado',
              child: Text('Cambiar estado'),
            ),
          ],
        ),
      ),
    );
  }
}
