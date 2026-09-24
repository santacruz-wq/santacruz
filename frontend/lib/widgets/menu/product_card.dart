import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';
import '../global/favorito_button.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String price;
  final String image;
  final EdgeInsetsGeometry margin;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.margin = const EdgeInsets.only(right: 14, bottom: 8, top: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 14, bottom: 8, top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.textoCafe.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen con botón de favoritos
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                child: SizedBox(
                  height: 110,
                  width: double.infinity,
                  child: Hero(
                    tag: image,
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.cremaClaro,
                        child: const Icon(
                          Icons.local_cafe_rounded,
                          size: 40,
                          color: AppColors.caramelo,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FavoritoButton(productoId: id, size: 14),
                  ),
                ),
              ),
            ],
          ),

          // Información del producto (Texto Centrado)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoCafe,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.caramelo,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
