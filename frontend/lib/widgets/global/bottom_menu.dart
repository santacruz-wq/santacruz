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
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFFF0D09D),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(
                icon: Icons.home,
                index: 0,
              ),
              _buildItem(
                icon: Icons.favorite,
                index: 1,
              ),
              _buildItem(
                icon: Icons.history,
                index: 2,
              ),
              _buildItem(
                icon: Icons.person,
                index: 3,
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
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: seleccionado
              ? AppColors.caramelo
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 27,
          color: seleccionado
              ? Colors.white
              : AppColors.textoCafe,
        ),
      ),
    );
  }
}