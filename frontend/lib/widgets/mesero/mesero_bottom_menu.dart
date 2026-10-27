
import 'package:flutter/material.dart';

import '../../core/config/app_colors.dart';

class MeseroBottomMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const MeseroBottomMenu({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = <IconData>[
      Icons.table_restaurant_rounded,
      Icons.receipt_long_rounded,
      Icons.history_rounded,
      Icons.translate_rounded,
      Icons.person_rounded,
    ];

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: AppColors.cremaClaro,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.cremaOscuro,
            width: 1,
          ),
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final seleccionado = currentIndex == index;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Material(
                  color: seleccionado
                      ? AppColors.caramelo
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onItemSelected(index),
                    child: SizedBox(
                      height: 48,
                      child: Center(
                        child: Icon(
                          items[index],
                          size: 23,
                          color: seleccionado
                              ? AppColors.blanco
                              : AppColors.cafeMedio,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
