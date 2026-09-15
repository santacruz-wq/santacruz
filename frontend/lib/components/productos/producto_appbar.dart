import 'package:flutter/material.dart';

class ProductoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  const ProductoAppBar({super.key, required this.titulo});

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color dorado = Color(0xFFD4A017);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: cafeOscuro,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: dorado,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
