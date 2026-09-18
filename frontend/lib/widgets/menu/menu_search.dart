import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/app_colors.dart';
import '../../providers/language_provider.dart';

class MenuSearch extends StatelessWidget {
  final Function(String) onChanged;

  const MenuSearch({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.cremaClaro,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.carameloClaro.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textoCafe.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          style: const TextStyle(
            color: AppColors.textoCafe,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: AppColors.caramelo,
          decoration: InputDecoration(
            hintText: lang.t('buscar'),
            hintStyle: TextStyle(
              color: AppColors.textoCafe.withOpacity(0.5),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.caramelo,
              size: 24,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ),
    );
  }
}