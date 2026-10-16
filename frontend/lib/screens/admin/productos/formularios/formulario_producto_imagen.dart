import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/product_model.dart';

class FormularioProductoImagen extends StatelessWidget {
  final ProductModel? producto;
  final XFile? imagen;
  final bool guardando;
  final VoidCallback onSeleccionarImagen;

  const FormularioProductoImagen({
    super.key,
    required this.producto,
    required this.imagen,
    required this.guardando,
    required this.onSeleccionarImagen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: InkWell(
            onTap: guardando ? null : onSeleccionarImagen,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 180,
              height: 150,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.cremaClaro,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.cremaOscuro,
                ),
              ),
              child: _contenidoImagen(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text('Toca la imagen para seleccionarla'),
        ),
      ],
    );
  }

  Widget _contenidoImagen() {
    if (imagen != null) {
      return FutureBuilder<Uint8List>(
        future: imagen!.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
            );
          }
          if (snapshot.hasError) {
            return const Icon(
              Icons.broken_image_outlined,
              size: 40,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }

    if (producto != null && producto!.imagenUrl.isNotEmpty) {
      return Image.network(
        producto!.imagenUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(
          Icons.add_a_photo,
          size: 40,
        ),
      );
    }

    return const Icon(Icons.add_a_photo, size: 40);
  }
}