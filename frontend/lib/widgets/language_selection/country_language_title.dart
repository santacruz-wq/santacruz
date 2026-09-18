import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';
import '../../models/pais_idioma.dart';

class CountryLanguageTile extends StatelessWidget {
  final Idioma item;
  final VoidCallback onTap;

  const CountryLanguageTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cremaClaro,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.carameloClaro.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textoCafe.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.cremaOscuro,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.public,
            color: AppColors.textoCafe,
            size: 24,
          ),
        ),
        title: Text(
          item.nombre,
          style: const TextStyle(
            color: AppColors.textoCafe,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          item.nombre,
          style: const TextStyle(
            color: AppColors.cafeMedio,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: AppColors.caramelo,
        ),
        onTap: onTap,
      ),
    );
  }
}