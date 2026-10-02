import 'package:flutter/material.dart';

import 'pedidos_cocina_screen.dart';
import '../user/perfil_screen.dart';

class CocinaShell extends StatefulWidget {
  const CocinaShell({
    super.key,
  });

  @override
  State<CocinaShell> createState() => _CocinaShellState();
}

class _CocinaShellState extends State<CocinaShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    PedidosCocinaScreen(),
    PerfilScreen(showBottomBar: false),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xFFF8E8D0),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: const Color(0xFFC78C55).withValues(alpha: 0.4),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A3B2A).withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildItem(
                    icon: Icons.restaurant,
                    index: 0,
                  ),
                  _buildItem(
                    icon: Icons.person_rounded,
                    index: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required int index,
  }) {
    final bool seleccionado = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: seleccionado
              ? const Color(0xFFC78C55)
              : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: seleccionado
              ? [
                  BoxShadow(
                    color: const Color(0xFFC78C55).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 24,
          color: seleccionado
              ? Colors.white
              : const Color(0xFF4A3B2A),
        ),
      ),
    );
  }
}