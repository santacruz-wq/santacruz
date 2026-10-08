import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/mesero/mesero_bottom_menu.dart';
import 'mesas_screen.dart';
import 'pedidos_screen.dart';
import '../user/perfil_screen.dart';

import '../../providers/auth_provider.dart';
import '../../services/socket_service.dart';

class MeseroShell extends StatefulWidget {
  const MeseroShell({super.key});

  @override
  State<MeseroShell> createState() => _MeseroShellState();
}

class _MeseroShellState extends State<MeseroShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MesasScreen(),
    PedidosScreen(),
    PerfilScreen(showBottomBar: false),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final usuario = auth.usuario;

      if (usuario != null && usuario.id != null) {
        SocketService.conectar(usuario.id!);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: MeseroBottomMenu(
          currentIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}