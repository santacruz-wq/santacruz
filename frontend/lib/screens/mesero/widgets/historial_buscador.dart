import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';

/// Campo para buscar por mesa o mesero.
class HistorialBuscador extends StatelessWidget {
  final TextEditingController controller;

  const HistorialBuscador({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        10,
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: AppColors.textoCafe,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar mesa o mesero...',
          hintStyle: TextStyle(
            color: AppColors.cafeMedio,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.cafeMedio,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.cafeMedio,
                  ),
                )
              : null,
          filled: true,
          fillColor: AppColors.cremaClaro,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.carameloClaro.withValues(
                alpha: 0.35,
              ),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.caramelo,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}