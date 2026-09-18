import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: AppColors.textoCafe,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}