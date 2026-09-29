import 'package:flutter/material.dart';
import '../widgets/global/bottom_menu.dart';
import 'menu/menu_screen.dart';
import 'user/favoritos_screen.dart';
import 'user/perfil_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MenuScreen(showBottomBar: false), // <-- importante
    FavoritosScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: _currentIndex,
        onItemSelected: (i) {
          setState(() => _currentIndex = i);
        },
      ),
    );
  }
}