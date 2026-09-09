import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';
import '../../models/pais_idioma.dart';

class CountryLanguageTile extends StatelessWidget {
  final PaisIdioma item;
  final VoidCallback onTap;

  const CountryLanguageTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.blanco,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Text(item.bandera, style: const TextStyle(fontSize: 28)),
        title: Text(
          item.pais,
          style: const TextStyle(
            color: AppColors.textoCafe,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          item.idiomaNombre,
          style: const TextStyle(
            color: AppColors.caramelo,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.caramelo,
        ),
        onTap: onTap,
      ),
    );
  }
}