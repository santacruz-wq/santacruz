import 'package:flutter/material.dart';

import '../../../widgets/menu/menu_header.dart';
import '../../../widgets/menu/menu_search.dart';

class MenuTopSection extends StatelessWidget {
  final ValueChanged<String> onBusquedaChanged;

  const MenuTopSection({
    super.key,
    required this.onBusquedaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MenuHeader(),
          ),
          Positioned(
            bottom: 0,
            left: 15,
            right: 15,
            child: MenuSearch(
              onChanged: (texto) => onBusquedaChanged(texto),
            ),
          ),
        ],
      ),
    );
  }
}