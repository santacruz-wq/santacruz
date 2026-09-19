import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

void mostrarDetalleProducto(
  BuildContext context, {
  required String name,
  required String price,
  required String image,
  required String description,
  required bool disponible,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barra decorativa superior
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.textoCafe.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Imagen del producto con animación Hero
                      Hero(
                        tag: image,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 180,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: AppColors.cremaClaro,
                                    child: const Icon(
                                      Icons.local_cafe_rounded,
                                      size: 50,
                                      color: AppColors.caramelo,
                                    ),
                                  ),
                                ),

                                // Overlay de "Agotado"
                                if (!disponible)
                                  Container(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'AGOTADO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Nombre y precio
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textoCafe,
                              ),
                            ),
                          ),
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.caramelo,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Descripción
                      Text(
                        description.isNotEmpty
                            ? description
                            : 'Sin descripción disponible.',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: AppColors.textoCafe.withValues(alpha: 0.8),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Botón de cerrar (X)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textoCafe.withValues(alpha: 0.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppColors.textoCafe,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}