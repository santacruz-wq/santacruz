import 'package:flutter/material.dart';

import '../../services/socket_service.dart';
import 'pedidos_cocina_screen.dart';
import '../user/perfil_screen.dart';

class CocinaShell extends StatefulWidget {
  const CocinaShell({
    super.key,
  });

  @override
  State<CocinaShell> createState() =>
      _CocinaShellState();
}

class _CocinaShellState
    extends State<CocinaShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    PedidosCocinaScreen(),
    PerfilScreen(
      showBottomBar: false,
    ),
  ];

  @override
  void initState() {
    super.initState();

    SocketService.conectar(
      null,
      esCocina: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.restaurant,
            ),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}