
import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';

class TarjetaEstadistica extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const TarjetaEstadistica({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cremaClaro,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icono,
              color: AppColors.caramelo,
              size: 25,
            ),
            Text(
              valor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.textoCafe,
              ),
            ),
            Text(
              titulo,
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
