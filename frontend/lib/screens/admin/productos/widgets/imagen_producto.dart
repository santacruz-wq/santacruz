import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';

class ImagenProducto extends StatelessWidget {
  final String url;
  final double tamano;

  const ImagenProducto({
    super.key,
    required this.url,
    this.tamano = 72,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: tamano,
        height: tamano,
        child: url.isEmpty
            ? const ColoredBox(
                color: AppColors.cremaOscuro,
                child: Icon(Icons.image_outlined),
              )
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: AppColors.cremaOscuro,
                  child: Icon(Icons.broken_image_outlined),
                ),
              ),
      ),
    );
  }
}