import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';

class ResenaCard extends StatelessWidget {
  final String producto;
  final String usuario;
  final String comentario;
  final String fecha;
  final int calificacion;
  final VoidCallback onEliminar;

  const ResenaCard({
    super.key,
    required this.producto,
    required this.usuario,
    required this.comentario,
    required this.fecha,
    required this.calificacion,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cremaClaro,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    producto,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoCafe,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Eliminar reseña',
                  onPressed: onEliminar,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            Row(
              children: List.generate(5, (i) {
                return Icon(
                  i < calificacion ? Icons.star : Icons.star_border,
                  size: 20,
                  color: AppColors.dorado,
                );
              }),
            ),
            const SizedBox(height: 10),
            Text(
              comentario.isEmpty ? 'Sin comentario escrito.' : comentario,
              style: const TextStyle(
                color: AppColors.textoCafe,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 18,
                  color: AppColors.cafeMedio,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    usuario,
                    style: const TextStyle(color: AppColors.cafeMedio),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Fecha: $fecha',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.cafeMedio,
              ),
            ),
          ],
        ),
      ),
    );
  }
}