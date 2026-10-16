import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/product_model.dart';
import 'producto_card.dart';

class ProductosContenido extends StatelessWidget {
  final bool cargando;
  final String? error;
  final List<ProductModel> productos;
  final VoidCallback onActualizar;
  final ValueChanged<ProductModel> onEditar;
  final ValueChanged<ProductModel> onCambiarDisponibilidad;

  const ProductosContenido({
    super.key,
    required this.cargando,
    required this.error,
    required this.productos,
    required this.onActualizar,
    required this.onEditar,
    required this.onCambiarDisponibilidad,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Card(
        color: AppColors.cremaClaro,
        child: ListTile(
          leading: const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
          title: Text(error!),
          trailing: IconButton(
            onPressed: onActualizar,
            icon: const Icon(Icons.refresh),
          ),
        ),
      );
    }

    if (productos.isEmpty) {
      return const Card(
        color: AppColors.cremaClaro,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Text('No se encontraron productos.'),
          ),
        ),
      );
    }

    return Column(
      children: productos.map((producto) {
        return ProductoCard(
          producto: producto,
          onEditar: () => onEditar(producto),
          onCambiarDisponibilidad: () =>
              onCambiarDisponibilidad(producto),
        );
      }).toList(),
    );
  }
}