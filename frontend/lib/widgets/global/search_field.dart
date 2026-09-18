import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Buscar...',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(
        color: AppColors.textoCafe,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.cafeMedio.withOpacity(0.7),
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.caramelo,
          size: 22,
        ),
        filled: true,
        fillColor: AppColors.cremaClaro,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.carameloClaro.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.caramelo,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}