import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final ValueChanged<int>? onChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 18,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        IconData icono;
        if (rating >= i + 1) {
          icono = Icons.star_rounded;
        } else if (rating >= i + 0.5) {
          icono = Icons.star_half_rounded;
        } else {
          icono = Icons.star_border_rounded;
        }

        final estrella = Icon(icono, size: size, color: AppColors.caramelo);

        if (onChanged == null) return estrella;
        return GestureDetector(
          onTap: () => onChanged!(i + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: estrella,
          ),
        );
      }),
    );
  }
}