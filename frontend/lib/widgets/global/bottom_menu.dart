import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';

class BottomMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const BottomMenu({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            color: AppColors.cremaClaro,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: AppColors.carameloClaro.withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.textoCafe.withValues(alpha: 0.10),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(
                icon: Icons.home_rounded,
                index: 0,
              ),
              _buildItem(
                icon: Icons.favorite_rounded,
                index: 1,
              ),
              _buildItem(
                icon: Icons.person_rounded,
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required int index,
  }) {
    final bool seleccionado = currentIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: seleccionado ? AppColors.caramelo : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: seleccionado
              ? [
                  BoxShadow(
                    color: AppColors.caramelo.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 24,
          color: seleccionado ? Colors.white : AppColors.textoCafe,
        ),
      ),
    );
  }
}